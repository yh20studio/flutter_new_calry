import '../../domain/routinesGroups/RoutinesGroups.dart';

class RoutinesGroupsUnions {
  final int? id;
  final String? title;
  final List<RoutinesGroups>? routinesGroupsList;

  RoutinesGroupsUnions({this.id, this.title, this.routinesGroupsList});

  factory RoutinesGroupsUnions.fromJson(Map<String, dynamic> json) {
    return RoutinesGroupsUnions(
      id: json['id'],
      title: json['title'],
      routinesGroupsList:
          json['routinesGroupsList'] == null ? [] : json['routinesGroupsList'].map<RoutinesGroups>((json) => RoutinesGroups.fromJson(json)).toList(),
    );
  }
}
