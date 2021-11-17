import 'package:flutter_new_calry/domain/labelColors/LabelColors.dart';
import 'dart:convert';
import 'package:flutter_new_calry/domain/schedules/Schedules.dart';

class WeekSchedulesCalendar {
  final Map<DateTime, List<dynamic>>? weekSchedules;
  final Map<int, Schedules>? schedules;
  final Map<DateTime, Schedules>? holidays;

  WeekSchedulesCalendar({this.schedules, this.weekSchedules, this.holidays});

  factory WeekSchedulesCalendar.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic>? weekMap = json['weekSchedules'];
    Map<DateTime, List<dynamic>> map = {};
    weekMap!.forEach((key, value) {
      map.putIfAbsent(DateTime.parse(key), () => value);
    });

    List<Schedules>? schedulesList = json['schedules'].map<Schedules>((json) => Schedules.fromJson(json)).toList();
    Map<int, Schedules> schedulesMap = {};
    schedulesList!.forEach((element) {
      schedulesMap.putIfAbsent(element.id!, () => element);
    });

    Map<String, dynamic>? holidaysMap = json['holidays'];
    Map<DateTime, Schedules> map2 = {};
    holidaysMap!.forEach((key, value) {
      map2.putIfAbsent(DateTime.parse(key), () => Schedules.fromJson(value));
    });

    return WeekSchedulesCalendar(schedules: schedulesMap, weekSchedules: map, holidays: map2);
  }
}

class WeekSchedules {
  final Map<DateTime, List<dynamic>>? weekSchedules;

  WeekSchedules({this.weekSchedules});

  factory WeekSchedules.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic>? weekMap = json['weekSchedules'];
    Map<DateTime, List<dynamic>> map = {};
    weekMap!.forEach((key, value) {
      map.putIfAbsent(DateTime.parse(key), () => value);
    });
    return WeekSchedules(
      weekSchedules: map,
    );
  }
}
