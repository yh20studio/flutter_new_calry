import '../../domain/routines/Routines.dart';

class RoutinesGroups {
  final int? id;
  final Routines? routines;

  RoutinesGroups({
    this.id,
    this.routines,
  });

  factory RoutinesGroups.fromJson(Map<String, dynamic> json) {
    return RoutinesGroups(id: json['id'], routines: Routines.fromJson(json['routines']));
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'routines': routines!.toJson(),
    };
  }

  Map<String, dynamic> toJsonWithoutId() {
    return {
      'routines': routines!.toJson(),
    };
  }
}
