import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_new_calry/domain/focusTodos/FocusTodos.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_new_calry/setting.dart';
import 'package:flutter_new_calry/controller/member/MemberController.dart';
import 'dart:io';

List<FocusTodos> parseFocusTodos(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<FocusTodos>((json) => FocusTodos.fromJson(json)).toList();
}

FocusTodos parseFocusTodo(String responseBody) {
  final parsed = jsonDecode(responseBody);
  return FocusTodos.fromJson(parsed);
}

Future<List<FocusTodos>> getFocusTodos() async {
  try {
    String jwt = await getJWT();
    http.Response response = await http.get(
      Uri.parse(serverIP + 'focusTodos'),
      headers: {HttpHeaders.authorizationHeader: "Bearer $jwt", HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8"},
    );
    if (response.statusCode == 200) {
      return compute(parseFocusTodos, response.body);
    } else {
      throw Exception("error: status code ${response.statusCode}");
    }
  } catch (e) {
    return Future.error("Need Login");
  }
}

Future<FocusTodos> postFocusTodos(FocusTodos focusTodos) async {
  String jwt = await getJWT();
  http.Response response = await http.post(
    Uri.parse(serverIP + 'focusTodos'),
    headers: {
      HttpHeaders.authorizationHeader: "Bearer $jwt",
      HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8",
      HttpHeaders.acceptHeader: "application/json; charset=UTF-8"
    },
    body: jsonEncode(
      {
        "content": focusTodos.content,
        "success": focusTodos.success,
      },
    ),
  );
  if (response.statusCode == 200) {
    return compute(parseFocusTodo, response.body);
  } else {
    throw Exception("error: status code ${response.statusCode}");
  }
}

Future<FocusTodos> updateFocusTodos(FocusTodos focusTodos) async {
  String jwt = await getJWT();

  http.Response response = await http.put(
    Uri.parse(serverIP + 'focusTodos/${focusTodos.id}'),
    headers: {
      HttpHeaders.authorizationHeader: "Bearer $jwt",
      HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8",
    },
    body: jsonEncode({
      "content": focusTodos.content,
      "success": focusTodos.success,
    }),
  );
  if (response.statusCode == 200) {
    return compute(parseFocusTodo, response.body);
  } else {
    throw Exception("error: status code ${response.statusCode}");
  }
}

Future<FocusTodos> successFocusTodos(FocusTodos focusTodos) async {
  String jwt = await getJWT();

  http.Response response = await http.put(
    Uri.parse(serverIP + 'focusTodos/success/${focusTodos.id}'),
    headers: {
      HttpHeaders.authorizationHeader: "Bearer $jwt",
      HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8",
    },
    body: jsonEncode({
      "success": focusTodos.success,
      "successDateTime": focusTodos.successDateTime!.toIso8601String(),
    }),
  );
  if (response.statusCode == 200) {
    return compute(parseFocusTodo, response.body);
  } else {
    throw Exception("error: status code ${response.statusCode}");
  }
}

Future<String> deleteFocusTodos(FocusTodos focusTodos) async {
  String jwt = await getJWT();
  final url = Uri.parse(serverIP + 'focusTodos/${focusTodos.id}');
  final request = http.Request("DELETE", url);
  request.headers.addAll(<String, String>{
    HttpHeaders.authorizationHeader: "Bearer $jwt",
    HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8",
  });

  final response = await request.send();
  if (response.statusCode == 200) {
    return await response.stream.bytesToString();
  } else {
    throw Exception("error: status code ${response.statusCode}");
  }
}
