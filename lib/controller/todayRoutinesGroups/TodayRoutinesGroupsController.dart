import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../domain/todayRoutinesGroups/TodayRoutinesGroups.dart';
import '../../setting.dart';

Map<String, TodayRoutinesGroups> parseTodayRoutinesGroupsMap(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  Map<String, TodayRoutinesGroups> todayRoutinesGroupsMap = {};
  List<TodayRoutinesGroups> list = parsed.map<TodayRoutinesGroups>((json) => TodayRoutinesGroups.fromJson(json)).toList();
  list.forEach((element) {
    todayRoutinesGroupsMap.putIfAbsent("${element.date!.year}-${element.date!.month}-${element.date!.day}", () => element);
  });
  return todayRoutinesGroupsMap;
}

TodayRoutinesGroups parseTodayRoutinesGroup(String responseBody) {
  final parsed = jsonDecode(responseBody);
  return TodayRoutinesGroups.fromJson(parsed);
}

Future<Map<String, TodayRoutinesGroups>> getAllTodayRoutinesGroups(String jwt) async {
    http.Response response = await http.get(
      Uri.parse(serverIP + 'todayRoutinesGroups/'),
      headers: {HttpHeaders.authorizationHeader: "Bearer $jwt", HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8"},
    );
    if (response.statusCode == 200) {
      return compute(parseTodayRoutinesGroupsMap, response.body);
    } else {
      throw Exception("error: status code ${response.statusCode}");
    }
}

Future<TodayRoutinesGroups> getTodayRoutinesGroups(String jwt, DateTime date) async {
    http.Response response = await http.get(
      Uri.parse(serverIP + 'todayRoutinesGroups/${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}'),
      headers: {HttpHeaders.authorizationHeader: "Bearer $jwt", HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8"},
    );
    if (response.statusCode == 200) {
      return compute(parseTodayRoutinesGroup, response.body);
    } else {
      throw Exception("error: status code ${response.statusCode}");
    }
}
