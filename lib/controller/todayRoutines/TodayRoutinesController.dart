import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../domain/todayRoutines/TodayRoutines.dart';
import '../../setting.dart';

List<TodayRoutines> parseTodayRoutines(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<TodayRoutines>((json) => TodayRoutines.fromJson(json)).toList();
}

TodayRoutines parseTodayRoutine(String responseBody) {
  final parsed = jsonDecode(responseBody);
  return TodayRoutines.fromJson(parsed);
}

Future<TodayRoutines> postTodayRoutines(String jwt, TodayRoutines todayRoutines) async {
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

Future<List<TodayRoutines>> postTodayRoutinesList(String jwt, String date, List<TodayRoutines> todayRoutinesList) async {
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

Future<TodayRoutines> updateTodayRoutines(String jwt, TodayRoutines todayRoutines) async {
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

Future<String> deleteTodayRoutines(String jwt, TodayRoutines todayRoutines) async {
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
