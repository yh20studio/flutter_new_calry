import 'package:flutter_new_calry/domain/routinesMemos/RoutinesMemos.dart';
import 'package:flutter_new_calry/domain/timeDuration/TimeDuration.dart';

class Routines {
  final int? id;
  final String? title;
  final List<RoutinesMemos>? routines_memosList;
  final int? duration;
  final TimeDuration? timeDuration;

  Routines({this.id, this.title, this.routines_memosList, this.duration, this.timeDuration});

  factory Routines.fromJson(Map<String, dynamic> json) {
    return Routines(
      id: json['id'],
      title: json['title'],
      routines_memosList:
          json['routines_memosList'] == null ? [] : json['routines_memosList'].map<RoutinesMemos>((json) => RoutinesMemos.fromJson(json)).toList(),
      duration: json['duration'],
      timeDuration: TimeDuration(hour: json['duration'] ~/ 3600, min: json['duration'] % 3600 ~/ 60, sec: json['duration'] % 3600 % 60),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'routines_memosList': routines_memosList!.map((i) => i.toJson()).toList(),
      'duration': duration,
    };
  }
}
