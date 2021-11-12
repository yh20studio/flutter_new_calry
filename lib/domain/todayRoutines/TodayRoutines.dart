import 'package:flutter/material.dart';
import 'package:flutter_new_calry/domain/routines/Routines.dart';

class TodayRoutines {
  final int? id;
  final TimeOfDay? finishTime;
  final bool? finish;
  final Routines? routines;
  final String? date;

  TodayRoutines({this.id, this.finishTime, this.finish, this.routines, this.date});

  factory TodayRoutines.fromJson(Map<String, dynamic> json) {
    return TodayRoutines(
        id: json['id'],
        finishTime: json['finishTime'] == null ? null : TimeOfDay(hour: json['finishTime'][0], minute: json['finishTime'][1]),
        finish: json['finish'],
        routines: Routines.fromJson(json['routines']));
  }

  Map<String, dynamic> toJson() {
    return {
      'finishTime': finishTime,
      'finish': finish,
      'routines': routines!.toJson(),
    };
  }
}
