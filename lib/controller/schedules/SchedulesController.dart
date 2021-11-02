import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_new_calry/domain/schedules/Schedules.dart';
import 'package:flutter_new_calry/setting.dart';
import 'package:flutter_new_calry/controller/member/MemberController.dart';
import 'dart:io';

List<Schedules> parseSchedules(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<Schedules>((json) => Schedules.fromJson(json)).toList();
}

Schedules parseSchedule(String responseBody) {
  final parsed = jsonDecode(responseBody);
  return Schedules.fromJson(parsed);
}

WeekSchedulesCalendar parseWeekSchedulesCalendar(String responseBody) {
  final parsed = jsonDecode(responseBody);
  return WeekSchedulesCalendar.fromJson(parsed);
}

WeekSchedules parseWeekSchedules(String responseBody) {
  final parsed = jsonDecode(responseBody);
  return WeekSchedules.fromJson(parsed);
}

Future<WeekSchedulesCalendar> getWholeSchedules() async {
  try {
    String jwt = await getJWT();
    http.Response response = await http.get(
      Uri.parse(serverIP + 'schedules/whole'),
      headers: {HttpHeaders.authorizationHeader: "Bearer $jwt", HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8"},
    );
    if (response.statusCode == 200) {
      return compute(parseWeekSchedulesCalendar, response.body);
    } else {
      throw Exception("error: status code ${response.statusCode}");
    }
  } catch (e) {
    return Future.error("Need login");
  }
}

Future<WeekSchedules> getPartSchedules(String updateStart, String updateEnd) async {
  String jwt = await getJWT();

  http.Response response = await http.get(
    Uri.parse(serverIP + 'schedules/part/${updateStart}/${updateEnd}'),
    headers: {HttpHeaders.authorizationHeader: "Bearer $jwt", HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8"},
  );
  if (response.statusCode == 200) {
    return compute(parseWeekSchedules, response.body);
  } else {
    throw Exception("error: status code ${response.statusCode}");
  }
}

Future<List<Schedules>> getDaySchedules() async {
  try {
    String jwt = await getJWT();
    DateTime now = DateTime.now();
    http.Response response = await http.get(
      Uri.parse(serverIP + 'schedules/day/${now.year}-${now.month}-${now.day}'),
      headers: {HttpHeaders.authorizationHeader: "Bearer $jwt", HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8"},
    );
    if (response.statusCode == 200) {
      return compute(parseSchedules, response.body);
    } else {
      throw Exception("error: status code ${response.statusCode}");
    }
  } catch (e) {
    return Future.error("Need Login");
  }
}

Future<Schedules> postSchedules(Schedules schedules) async {
  String jwt = await getJWT();
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

Future<Schedules> updateSchedules(Schedules schedules) async {
  String jwt = await getJWT();

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

Future<String> deleteSchedules(Schedules schedules) async {
  String jwt = await getJWT();
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
