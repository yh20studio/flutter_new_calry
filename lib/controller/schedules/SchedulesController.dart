import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../domain/schedules/Schedules.dart';
import '../../setting.dart';

List<Schedules> parseSchedules(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<Schedules>((json) => Schedules.fromJson(json)).toList();
}

Schedules parseSchedule(String responseBody) {
  final parsed = jsonDecode(responseBody);
  return Schedules.fromJson(parsed);
}

Future<List<Schedules>> getDaySchedules(String jwt, ) async {
    String now = DateTime.now().toIso8601String();
    now = now.substring(0, now.length - 1);
    http.Response response = await http.get(
      Uri.parse(serverIP + 'schedules/day/${now}'),
      headers: {HttpHeaders.authorizationHeader: "Bearer $jwt", HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8"},
    );
    if (response.statusCode == 200) {
      return compute(parseSchedules, response.body);
    } else {
      throw Exception("error: status code ${response.statusCode}");
    }
}

Future<Schedules> postSchedules(String jwt, Schedules schedules) async {
  print(schedules.startDate!.toIso8601String());
  http.Response response = await http.post(
    Uri.parse(serverIP + 'schedules'),
    headers: {
      HttpHeaders.authorizationHeader: "Bearer $jwt",
      HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8",
      HttpHeaders.acceptHeader: "application/json; charset=UTF-8"
    },
    body: jsonEncode(
      {
        "title": schedules.title,
        "content": schedules.content,
        "start_date": schedules.startDate!.toIso8601String(),
        "end_date": schedules.endDate!.toIso8601String(),
        "labels": schedules.labels
      },
    ),
  );
  if (response.statusCode == 200) {
    return compute(parseSchedule, response.body);
  } else {
    throw Exception("error: status code ${response.statusCode}");
  }
}

Future<Schedules> updateSchedules(String jwt, Schedules schedules) async {
  http.Response response = await http.put(
    Uri.parse(serverIP + 'schedules/${schedules.id}'),
    headers: {
      HttpHeaders.authorizationHeader: "Bearer $jwt",
      HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8",
    },
    body: jsonEncode({
      "title": schedules.title,
      "content": schedules.content,
      "start_date": schedules.startDate!.toIso8601String(),
      "end_date": schedules.endDate!.toIso8601String(),
      "labels": schedules.labels
    }),
  );
  if (response.statusCode == 200) {
    return compute(parseSchedule, response.body);
  } else {
    throw Exception("error: status code ${response.statusCode}");
  }
}

Future<String> deleteSchedules(String jwt, Schedules schedules) async {
  final url = Uri.parse(serverIP + 'schedules/${schedules.id}');
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
