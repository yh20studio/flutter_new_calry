import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_new_calry/domain/quickSchedules/QuickSchedules.dart';
import 'package:flutter_new_calry/setting.dart';
import 'package:flutter_new_calry/controller/member/MemberController.dart';
import 'dart:io';

List<QuickSchedules> parseQuickSchedules(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<QuickSchedules>((json) => QuickSchedules.fromJson(json)).toList();
}

QuickSchedules parseQuickSchedule(String responseBody) {
  final parsed = jsonDecode(responseBody);
  return QuickSchedules.fromJson(parsed);
}

Future<List<QuickSchedules>> getQuickSchedules() async {
  try {
    String jwt = await getJWT();
    http.Response response = await http.get(
      Uri.parse(serverIP + 'quickSchedules'),
      headers: {HttpHeaders.authorizationHeader: "Bearer $jwt", HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8"},
    );
    if (response.statusCode == 200) {
      return compute(parseQuickSchedules, response.body);
    } else {
      throw Exception("error: status code ${response.statusCode}");
    }
  } catch (e) {
    return Future.error(e.toString());
  }
}

Future<QuickSchedules> postQuickSchedules(QuickSchedules quickSchedules) async {
  String jwt = await getJWT();
  http.Response response;
  if (quickSchedules.startTime == null && quickSchedules.endTime == null) {
    response = await http.post(
      Uri.parse(serverIP + 'quickSchedules'),
      headers: {
        HttpHeaders.authorizationHeader: "Bearer $jwt",
        HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8",
        HttpHeaders.acceptHeader: "application/json; charset=UTF-8"
      },
      body: jsonEncode(
        {"title": quickSchedules.title, "content": quickSchedules.content, "labels": quickSchedules.labels},
      ),
    );
  } else {
    String startTime_hour = quickSchedules.startTime!.hour == 0 ? "00" : "${quickSchedules.startTime!.hour}";
    String endTime_hour = quickSchedules.endTime!.hour == 0 ? "00" : "${quickSchedules.endTime!.hour}";

    String startTime_minute = quickSchedules.startTime!.minute == 0 ? "00" : "${quickSchedules.startTime!.minute}";
    String endTime_minute = quickSchedules.endTime!.minute == 0 ? "00" : "${quickSchedules.endTime!.minute}";
    response = await http.post(
      Uri.parse(serverIP + 'quickSchedules'),
      headers: {
        HttpHeaders.authorizationHeader: "Bearer $jwt",
        HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8",
        HttpHeaders.acceptHeader: "application/json; charset=UTF-8"
      },
      body: jsonEncode(
        {
          "title": quickSchedules.title,
          "content": quickSchedules.content,
          "start_time": "$startTime_hour:$startTime_minute",
          "end_time": "$endTime_hour:$endTime_minute",
          "labels": quickSchedules.labels
        },
      ),
    );
  }
  if (response.statusCode == 200) {
    return compute(parseQuickSchedule, response.body);
  } else {
    throw Exception("error: status code ${response.statusCode}");
  }
}

Future<QuickSchedules> updateQuickSchedules(QuickSchedules quickSchedules) async {
  String jwt = await getJWT();
  http.Response response;
  if (quickSchedules.startTime == null && quickSchedules.endTime == null) {
    response = await http.put(
      Uri.parse(serverIP + 'quickSchedules/${quickSchedules.id}'),
      headers: {
        HttpHeaders.authorizationHeader: "Bearer $jwt",
        HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8",
      },
      body: jsonEncode({"title": quickSchedules.title, "content": quickSchedules.content, "labels": quickSchedules.labels}),
    );
  } else {
    String startTime_hour = quickSchedules.startTime!.hour == 0 ? "00" : "${quickSchedules.startTime!.hour}";
    String endTime_hour = quickSchedules.endTime!.hour == 0 ? "00" : "${quickSchedules.endTime!.hour}";

    String startTime_minute = quickSchedules.startTime!.minute == 0 ? "00" : "${quickSchedules.startTime!.minute}";
    String endTime_minute = quickSchedules.endTime!.minute == 0 ? "00" : "${quickSchedules.endTime!.minute}";

    response = await http.post(
      Uri.parse(serverIP + 'quickSchedules'),
      headers: {
        HttpHeaders.authorizationHeader: "Bearer $jwt",
        HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8",
        HttpHeaders.acceptHeader: "application/json; charset=UTF-8"
      },
      body: jsonEncode(
        {
          "title": quickSchedules.title,
          "content": quickSchedules.content,
          "start_time": "$startTime_hour:$startTime_minute",
          "end_time": "$endTime_hour:$endTime_minute",
          "labels": quickSchedules.labels
        },
      ),
    );
  }

  if (response.statusCode == 200) {
    return compute(parseQuickSchedule, response.body);
  } else {
    throw Exception("error: status code ${response.statusCode}");
  }
}

Future<String> deleteQuickSchedules(QuickSchedules quickSchedules) async {
  String jwt = await getJWT();
  final url = Uri.parse(serverIP + 'quickSchedules/${quickSchedules.id}');
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