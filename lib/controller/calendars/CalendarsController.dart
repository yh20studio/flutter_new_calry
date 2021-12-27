import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_new_calry/setting.dart';
import 'package:flutter_new_calry/controller/member/MemberController.dart';
import 'dart:io';
import 'package:flutter_new_calry/domain/calendars/Calendars.dart';

WeekSchedulesCalendar parseWeekSchedulesCalendar(String responseBody) {
  final parsed = jsonDecode(responseBody);
  return WeekSchedulesCalendar.fromJson(parsed);
}

PartWeekSchedules parsePartWeekSchedules(String responseBody) {
  final parsed = jsonDecode(responseBody);
  return PartWeekSchedules.fromJson(parsed);
}

Future<WeekSchedulesCalendar> getWholeSchedules() async {
  try {
    String jwt = await getJWT();
    http.Response response = await http.get(
      Uri.parse(serverIP + 'calendars/whole'),
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

Future<PartWeekSchedules> getPartSchedules(String updateStart, String updateEnd) async {
  String jwt = await getJWT();

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
