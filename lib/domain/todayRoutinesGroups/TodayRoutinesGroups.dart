import 'package:flutter_new_calry/domain/todayRoutines/TodayRoutines.dart';

class TodayRoutinesGroups {
  final int? id;
  final DateTime? date;
  final int? success;
  final int? fail;
  final List<TodayRoutines>? todayRoutinesList;

  TodayRoutinesGroups({this.id, this.date, this.success, this.fail, this.todayRoutinesList});

  factory TodayRoutinesGroups.fromJson(Map<String, dynamic> json) {
    return TodayRoutinesGroups(
      id: json['id'],
      date: DateTime.utc(json['date'][0], json['date'][1], json['date'][2]),
      success: json['success'],
      fail: json['fail'],
      todayRoutinesList: json['todayRoutinesList'] == null ? [] : json['todayRoutinesList'].map<TodayRoutines>((json) => TodayRoutines.fromJson(json)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'date': "${date!.year}-${date!.month}-${date!.day}", 'success': success, 'fail': fail};
  }
}
