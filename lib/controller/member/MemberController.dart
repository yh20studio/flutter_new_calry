import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/member/Member.dart';
import '../../setting.dart';
import '../jwt/JwtController.dart';

Member parseMember(String responseBody) {
  final parsed = jsonDecode(responseBody);
  return Member.fromJson(parsed);
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

Future<Member> getMyInfo(String jwt) async {
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

Future postLogout(String jwt, String? accessToken, int? accessTokenExpiresIn) async {
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
