import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_new_calry/domain/member/Member.dart';
import 'package:flutter_new_calry/setting.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:flutter_new_calry/main.dart';
import 'package:flutter_new_calry/dialog/AlertDialog.dart';

Member parseMember(String responseBody) {
  final parsed = jsonDecode(responseBody);
  return Member.fromJson(parsed);
}

Future getJWT() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.getString('accessToken') == null) {
    print("Need Login");
    navigatorKey.currentState!.pushNamed('login');
  } else {
    DateTime accessTokenExpiresIn = DateTime.fromMillisecondsSinceEpoch(prefs.getInt('accessTokenExpiresIn')!);
    DateTime now = DateTime.now();
    if (accessTokenExpiresIn.isBefore(now)) {
      print("Expires");
      try {
        var httpPostReissue = await postReissueAccess(prefs.getString('accessToken'), prefs.getInt('accessTokenExpiresIn'));
        prefs.setString('accessToken', jsonDecode(httpPostReissue)['accessToken']);
        prefs.setInt('accessTokenExpiresIn', jsonDecode(httpPostReissue)['accessTokenExpiresIn']);
        return prefs.getString('accessToken')!;
      } catch (e) {
        print("reLogin!");
        var dialogResult = await alertDialog(navigatorKey.currentContext!, "로그인이 유효하지 않습니다. 다시 로그인 해주세요.");
        if (dialogResult == 'ok') {
          navigatorKey.currentState!.pushNamed('login');
        }
      }
    } else {
      return prefs.getString('accessToken')!;
    }
  }
}

Future<String> authenticationUser() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  DateTime now = DateTime.now();
  if (prefs.getInt('accessTokenExpiresIn') == null) {
    return 'fail';
  } else {
    DateTime accessTokenExpiresIn = DateTime.fromMillisecondsSinceEpoch(prefs.getInt('accessTokenExpiresIn')!);
    if (accessTokenExpiresIn.isBefore(now)) {
      try {
        var httpPostReissue = await postReissueAccess(prefs.getString('accessToken'), prefs.getInt('accessTokenExpiresIn'));
        prefs.setString('accessToken', jsonDecode(httpPostReissue)['accessToken']);
        prefs.setInt('accessTokenExpiresIn', jsonDecode(httpPostReissue)['accessTokenExpiresIn']);
        return 'success';
      } catch (e) {
        print(e);
        return 'fail';
      }
    } else {
      return 'fail';
    }
  }
}

Future<Member> getMyInfo() async {
  String jwt = await getJWT();
  http.Response response = await http.get(
    Uri.parse(serverIP + 'member/info'),
    headers: {HttpHeaders.authorizationHeader: "Bearer $jwt", HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8"},
  );
  if (response.statusCode == 200) {
    return compute(parseMember, response.body);
  } else {
    throw Exception("error: status code ${response.statusCode}");
  }
}

Future postSignUp(String email, String password, String name) async {
  http.Response response = await http.post(
    Uri.parse(serverIP + 'member/signup'),
    headers: {HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8", HttpHeaders.acceptHeader: "application/json; charset=UTF-8"},
    body: jsonEncode(
      {"email": email, "password": password, "name": name},
    ),
  );
  if (response.statusCode == 200) {
    return response.body;
  } else {
    throw jsonDecode(response.body)["message"];
  }
}

Future postLogin(String email, String password) async {
  http.Response response = await http.post(
    Uri.parse(serverIP + 'member/login'),
    headers: {HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8", HttpHeaders.acceptHeader: "application/json; charset=UTF-8"},
    body: jsonEncode(
      {"email": email, "password": password},
    ),
  );
  if (response.statusCode == 200) {
    return response.body;
  } else {
    throw Exception(jsonDecode(response.body)["message"]);
  }
}

Future postLogout(String? accessToken, int? accessTokenExpiresIn) async {
  String jwt = await getJWT();
  http.Response response = await http.post(
    Uri.parse(serverIP + 'member/logout'),
    headers: {
      HttpHeaders.authorizationHeader: "Bearer $jwt",
      HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8",
      HttpHeaders.acceptHeader: "application/json; charset=UTF-8"
    },
    body: jsonEncode(
      {
        "accessToken": accessToken,
        "accessTokenExpiresIn": accessTokenExpiresIn,
      },
    ),
  );
  if (response.statusCode == 200) {
    return jsonDecode(response.body)['message'];
  } else {
    throw Exception("error: status code ${response.statusCode}");
  }
}

Future postReissueAccess(String? accessToken, int? accessTokenExpiresIn) async {
  http.Response response = await http.post(
    Uri.parse(serverIP + 'member/reissue/access'),
    headers: {HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8", HttpHeaders.acceptHeader: "application/json; charset=UTF-8"},
    body: jsonEncode(
      {
        "accessToken": accessToken,
        "accessTokenExpiresIn": accessTokenExpiresIn,
      },
    ),
  );
  if (response.statusCode == 200) {
    return response.body;
  } else {
    throw Exception("error: status code ${response.statusCode}");
  }
}
