import 'package:flutter_new_calry/domain/schedules/Schedules.dart';
import 'package:flutter_new_calry/domain/timeDuration/TimeDuration.dart';
import 'Days.dart';

class Week {
  final List<Days>? schedules;

  Week({this.schedules});

  factory Week.fromJson(Map<String, dynamic> json) {
    return Week(schedules: json['schedules'].map<Days>((json) => Days.fromJson(json)).toList());
  }
}
