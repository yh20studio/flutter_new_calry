import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../setting.dart';
import '../../domain/calendars/Calendars.dart';

WeekSchedulesCalendar parseWeekSchedulesCalendar(String responseBody) {
  final parsed = jsonDecode(responseBody);
  return WeekSchedulesCalendar.fromJson(parsed);
}

PartWeekSchedules parsePartWeekSchedules(String responseBody) {
  final parsed = jsonDecode(responseBody);
  return PartWeekSchedules.fromJson(parsed);
}

Future<WeekSchedulesCalendar> getWholeSchedules(String jwt) async {
    http.Response response = await http.get(
      Uri.parse(serverIP + 'calendars/whole'),
      headers: {HttpHeaders.authorizationHeader: "Bearer $jwt", HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8"},
    );
    if (response.statusCode == 200) {
      return compute(parseWeekSchedulesCalendar, response.body);
    } else {
      throw Exception("error: status code ${response.statusCode}");
    }
}

Future<PartWeekSchedules> getPartSchedules(String jwt, String updateStart, String updateEnd) async {
  http.Response response = await http.get(
    Uri.parse(serverIP + 'calendars/part/${updateStart}/${updateEnd}'),
    headers: {HttpHeaders.authorizationHeader: "Bearer $jwt", HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8"},
  );
  if (response.statusCode == 200) {
    return compute(parsePartWeekSchedules, response.body);
  } else {
    throw Exception("error: status code ${response.statusCode}");
  }
}
