import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'class.dart';
import 'setting.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

//GET METHOD

Future<List<Archives>> getArchives() async {
  http.Response response = await http.get(
    Uri.parse(serverIP + 'archives/get'),
    headers: {HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8"},
  );
  if (response.statusCode == 200) {
    return compute(parseArchives, response.body);
  } else {
    throw Exception("error: status code ${response.statusCode}");
  }
}

List<Archives> parseArchives(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<Archives>((json) => Archives.fromJson(json)).toList();
}

//POST METHOD

Future postArchives(Archives archives) async {
  http.Response response = await http.post(
    Uri.parse(serverIP + 'archives/post'),
    headers: {
      HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8",
      HttpHeaders.acceptHeader: "application/json; charset=UTF-8"
    },
    body: jsonEncode(
      {
        "id": archives.id,
        "title": archives.title,
        "content": archives.content,
        "url": archives.url,
        "author": archives.author
      },
    ),
  );
  return response.body;
}

//Delete

Future<String> deleteArchives(Archives archives) async {
  final url = Uri.parse(serverIP + 'archives/delete/${archives.id}');
  final request = http.Request("DELETE", url);
  request.headers.addAll(<String, String>{
    HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8",
  });

  final response = await request.send();
  if (response.statusCode == 200) {
    return await response.stream.bytesToString();
  } else {
    throw Exception("error: status code ${response.statusCode}");
  }
}

//PUT

Future<http.Response> updateArchives(Archives archives) async {
  return http.put(
    Uri.parse(serverIP + 'archives/put/${archives.id}'),
    headers: {
      HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8",
    },
    body: jsonEncode({
      "title": archives.title,
      "content": archives.content,
      "url": archives.url,
    }),
  );
}
