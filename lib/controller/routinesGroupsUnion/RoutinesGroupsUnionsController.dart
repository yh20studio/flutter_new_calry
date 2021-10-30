import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_new_calry/setting.dart';
import 'package:flutter_new_calry/controller/member/MemberController.dart';
import 'dart:io';
import 'package:flutter_new_calry/domain/routinesGroupsUnions/RoutinesGroupsUnions.dart';

List<RoutinesGroupsUnions> parseRoutinesGroupsUnions(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<RoutinesGroupsUnions>((json) => RoutinesGroupsUnions.fromJson(json)).toList();
}

RoutinesGroupsUnions parseRoutinesGroupsUnion(String responseBody) {
  final parsed = jsonDecode(responseBody);
  return RoutinesGroupsUnions.fromJson(parsed);
}

Future<List<RoutinesGroupsUnions>> getRoutinesGroupsUnions() async {
  String jwt = await getJWT();
  http.Response response = await http.get(
    Uri.parse(serverIP + 'routinesGroups/unions'),
    headers: {HttpHeaders.authorizationHeader: "Bearer $jwt", HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8"},
  );
  if (response.statusCode == 200) {
    return compute(parseRoutinesGroupsUnions, response.body);
  } else {
    throw Exception("error: status code ${response.statusCode}");
  }
}

Future<RoutinesGroupsUnions> postRoutinesGroupsUnions(RoutinesGroupsUnions routinesGroupsUnions) async {
  String jwt = await getJWT();

  print(routinesGroupsUnions.routinesGroupsList!.map((i) => i.toJsonWithoutId()).toList());
  http.Response response = await http.post(
    Uri.parse(serverIP + 'routinesGroups/unions'),
    headers: {
      HttpHeaders.authorizationHeader: "Bearer $jwt",
      HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8",
      HttpHeaders.acceptHeader: "application/json; charset=UTF-8"
    },
    body: jsonEncode(
      {"title": routinesGroupsUnions.title, "routinesGroupsList": routinesGroupsUnions.routinesGroupsList!.map((i) => i.toJsonWithoutId()).toList()},
    ),
  );

  if (response.statusCode == 200) {
    return compute(parseRoutinesGroupsUnion, response.body);
  } else {
    throw Exception("error: status code ${response.statusCode}");
  }
}

Future<RoutinesGroupsUnions> updateRoutinesGroupsUnions(RoutinesGroupsUnions routinesGroupsUnions) async {
  String jwt = await getJWT();
  http.Response response = await http.put(
    Uri.parse(serverIP + 'routinesGroups/unions/${routinesGroupsUnions.id}'),
    headers: {
      HttpHeaders.authorizationHeader: "Bearer $jwt",
      HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8",
    },
    body: jsonEncode({"title": routinesGroupsUnions.title, "routinesGroupsList": routinesGroupsUnions.routinesGroupsList!.map((i) => i.toJson()).toList()}),
  );
  if (response.statusCode == 200) {
    return compute(parseRoutinesGroupsUnion, response.body);
  } else {
    throw Exception("error: status code ${response.statusCode}");
  }
}

Future<String> deleteRoutinesGroupsUnions(RoutinesGroupsUnions routinesGroupsUnions) async {
  String jwt = await getJWT();

  final url = Uri.parse(serverIP + 'routinesGroups/unions/${routinesGroupsUnions.id}');
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