import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../domain/labels/Labels.dart';
import '../../setting.dart';

List<Labels> parseLabels(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<Labels>((json) => Labels.fromJson(json)).toList();
}

Future<List<Labels>> getLabels(String jwt) async {
  http.Response response = await http.get(
    Uri.parse(serverIP + 'labels'),
    headers: {HttpHeaders.authorizationHeader: "Bearer $jwt", HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8"},
  );
  if (response.statusCode == 200) {
    return compute(parseLabels, response.body);
  } else {
    throw Exception("error: status code ${response.statusCode}");
  }
}

Future<List<Labels>> updateLabels(String jwt, List<Labels> labelsList) async {
  List jsonList = [];
  labelsList.map((item) => jsonList.add(item.toJson())).toList();

  http.Response response = await http.put(
    Uri.parse(serverIP + 'labels'),
    headers: {
      HttpHeaders.authorizationHeader: "Bearer $jwt",
      HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8",
    },
    body: jsonEncode({
      "labels_list": jsonList,
    }),
  );
  if (response.statusCode == 200) {
    return compute(parseLabels, response.body);
  } else {
    throw Exception("error: status code ${response.statusCode}");
  }
}
