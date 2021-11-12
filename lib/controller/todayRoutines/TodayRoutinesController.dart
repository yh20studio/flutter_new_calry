import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_new_calry/domain/todayRoutines/TodayRoutines.dart';
import 'package:flutter_new_calry/setting.dart';
import 'package:flutter_new_calry/controller/member/MemberController.dart';
import 'dart:io';

List<TodayRoutines> parseTodayRoutines(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<TodayRoutines>((json) => TodayRoutines.fromJson(json)).toList();
}

TodayRoutines parseTodayRoutine(String responseBody) {
  final parsed = jsonDecode(responseBody);
  return TodayRoutines.fromJson(parsed);
}

Future<TodayRoutines> postTodayRoutines(TodayRoutines todayRoutines) async {
  String jwt = await getJWT();
  http.Response response = await http.post(
    Uri.parse(serverIP + 'todayRoutines'),
    headers: {
      HttpHeaders.authorizationHeader: "Bearer $jwt",
      HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8",
      HttpHeaders.acceptHeader: "application/json; charset=UTF-8"
    },
    body: jsonEncode(
      {
        "finish_time": todayRoutines.finishTime,
        "finish": todayRoutines.finish,
        "date": todayRoutines.date,
        "routines": todayRoutines.routines!.toJson(),
      },
    ),
  );
  if (response.statusCode == 200) {
    return compute(parseTodayRoutine, response.body);
  } else {
    throw Exception("error: status code ${response.statusCode}");
  }
}

Future<List<TodayRoutines>> postTodayRoutinesList(String date, List<TodayRoutines> todayRoutinesList) async {
  String jwt = await getJWT();

  http.Response response = await http.post(
    Uri.parse(serverIP + 'todayRoutines/list'),
    headers: {
      HttpHeaders.authorizationHeader: "Bearer $jwt",
      HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8",
      HttpHeaders.acceptHeader: "application/json; charset=UTF-8"
    },
    body: jsonEncode({"date": date, "todayRoutinesList": todayRoutinesList.map((i) => i.toJson()).toList()}),
  );
  if (response.statusCode == 200) {
    return compute(parseTodayRoutines, response.body);
  } else {
    throw Exception("error: status code ${response.statusCode}");
  }
}

Future<TodayRoutines> updateTodayRoutines(TodayRoutines todayRoutines) async {
  String jwt = await getJWT();
  http.Response response = await http.put(
    Uri.parse(serverIP + 'todayRoutines/${todayRoutines.id}'),
    headers: {
      HttpHeaders.authorizationHeader: "Bearer $jwt",
      HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8",
    },
    body: jsonEncode({
      "finishTime": DateTime.now().toIso8601String(),
      "finish": true,
    }),
  );
  if (response.statusCode == 200) {
    return compute(parseTodayRoutine, response.body);
  } else {
    throw Exception("error: status code ${response.statusCode}");
  }
}

Future<String> deleteTodayRoutines(TodayRoutines todayRoutines) async {
  String jwt = await getJWT();
  final url = Uri.parse(serverIP + 'todayRoutines/${todayRoutines.id}');
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
