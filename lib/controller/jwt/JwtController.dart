import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';
import '../../setting.dart';
import '../../dialog/AlertDialog.dart';

Future getJwt(BuildContext context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.getString('accessToken') == null) {
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  } else {
    DateTime accessTokenExpiresIn = DateTime.fromMillisecondsSinceEpoch(prefs.getInt('accessTokenExpiresIn')!);
    DateTime now = DateTime.now();
    if (accessTokenExpiresIn.isBefore(now)) {
      try {
        var httpPostReissue = await postReissueAccess(prefs.getString('accessToken'), prefs.getInt('accessTokenExpiresIn'));
        prefs.setString('accessToken', jsonDecode(httpPostReissue)['accessToken']);
        prefs.setInt('accessTokenExpiresIn', jsonDecode(httpPostReissue)['accessTokenExpiresIn']);
        return prefs.getString('accessToken')!;
      } catch (e) {
        var dialogResult = await alertDialog(navigatorKey.currentContext!, "로그인이 유효하지 않습니다. 다시 로그인 해주세요.");
        if (dialogResult == 'ok') {
          Navigator.of(context).pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
        }
      }
    } else {
      return prefs.getString('accessToken')!;
    }
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
