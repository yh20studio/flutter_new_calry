import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../setting.dart';
import '../../controller/member/MemberController.dart';
import '../../domain/routinesMemos/RoutinesMemos.dart';

RoutinesMemos parseRoutinesMemo(String responseBody) {
  final parsed = jsonDecode(responseBody);
  return RoutinesMemos.fromJson(parsed);
}

Future<RoutinesMemos> postRoutinesMemos(RoutinesMemos routinesMemos) async {
  String jwt = await getJWT();
  http.Response response = await http.post(
    Uri.parse(serverIP + 'routines/memos'),
    headers: {
      HttpHeaders.authorizationHeader: "Bearer $jwt",
      HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8",
      HttpHeaders.acceptHeader: "application/json; charset=UTF-8"
    },
    body: jsonEncode(
      {
        "routines_id": routinesMemos.routines_id,
        "content": routinesMemos.content,
      },
    ),
  );
  if (response.statusCode == 200) {
    return compute(parseRoutinesMemo, response.body);
  } else {
    throw Exception("error: status code ${response.statusCode}");
  }
}

Future<RoutinesMemos> updateRoutinesMemos(RoutinesMemos routinesMemos) async {
  String jwt = await getJWT();
  http.Response response = await http.put(
    Uri.parse(serverIP + 'routines/memos/${routinesMemos.id}'),
    headers: {
      HttpHeaders.authorizationHeader: "Bearer $jwt",
      HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8",
    },
    body: jsonEncode({
      "content": routinesMemos.content,
    }),
  );
  if (response.statusCode == 200) {
    return compute(parseRoutinesMemo, response.body);
  } else {
    throw Exception("error: status code ${response.statusCode}");
  }
}

Future<String> deleteRoutinesMemos(RoutinesMemos routinesMemos) async {
  String jwt = await getJWT();
  final url = Uri.parse(serverIP + 'routines/memos/${routinesMemos.id}');
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
