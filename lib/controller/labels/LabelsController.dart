import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_new_calry/domain/labels/Labels.dart';
import 'package:flutter_new_calry/setting.dart';

import 'package:flutter_new_calry/controller/member/MemberController.dart';
import 'dart:io';

List<Labels> parseLabels(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<Labels>((json) => Labels.fromJson(json)).toList();
}

Future<List<Labels>> getLabels() async {
  String jwt = await getJWT();
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

Future<List<Labels>> updateLabels(List<Labels> labelsList) async {
  String jwt = await getJWT();
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
