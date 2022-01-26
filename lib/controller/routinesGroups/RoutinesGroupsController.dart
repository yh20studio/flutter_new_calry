import 'dart:convert';

import '../../domain/routinesGroups/RoutinesGroups.dart';

List<RoutinesGroups> parseRoutinesGroups(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<RoutinesGroups>((json) => RoutinesGroups.fromJson(json)).toList();
}

RoutinesGroups parseRoutinesGroup(String responseBody) {
  final parsed = jsonDecode(responseBody);
  return RoutinesGroups.fromJson(parsed);
}
