import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../setting.dart';
import '../../domain/routines/Routines.dart';

List<Routines> parseRoutines(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<Routines>((json) => Routines.fromJson(json)).toList();
}

Routines parseRoutine(String responseBody) {
  final parsed = jsonDecode(responseBody);
  return Routines.fromJson(parsed);
}

Future<List<Routines>> getRoutines(String jwt) async {
  http.Response response = await http.get(
    Uri.parse(serverIP + 'routines'),
    headers: {HttpHeaders.authorizationHeader: "Bearer $jwt", HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8"},
  );
  if (response.statusCode == 200) {
    return compute(parseRoutines, response.body);
  } else {
    throw Exception("error: status code ${response.statusCode}");
  }
}

Future<Routines> postRoutines(String jwt, Routines routines) async {
  http.Response response = await http.post(
    Uri.parse(serverIP + 'routines'),
    headers: {
      HttpHeaders.authorizationHeader: "Bearer $jwt",
      HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8",
      HttpHeaders.acceptHeader: "application/json; charset=UTF-8"
    },
    body: jsonEncode(
      {
        "title": routines.title,
        "duration": routines.duration,
      },
    ),
  );
  if (response.statusCode == 200) {
    return compute(parseRoutine, response.body);
  } else {
    throw Exception("error: status code ${response.statusCode}");
  }
}

Future<Routines> updateRoutines(String jwt, Routines routines) async {
  http.Response response = await http.put(
    Uri.parse(serverIP + 'routines/${routines.id}'),
    headers: {
      HttpHeaders.authorizationHeader: "Bearer $jwt",
      HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8",
    },
    body: jsonEncode({
      "title": routines.title,
      "duration": routines.duration,
    }),
  );
  if (response.statusCode == 200) {
    return compute(parseRoutine, response.body);
  } else {
    throw Exception("error: status code ${response.statusCode}");
  }
}

Future<String> deleteRoutines(String jwt, Routines routines) async {
  final url = Uri.parse(serverIP + 'routines/${routines.id}');
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
