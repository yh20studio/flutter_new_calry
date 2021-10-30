import 'package:flutter_new_calry/domain/labels/Labels.dart';

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

class DayCalendar {
  final int? id;
  final int? gap;
  DayCalendar({this.id, this.gap});
  factory DayCalendar.fromJson(Map<String, dynamic> json) {
    return DayCalendar(
      id: json['holiday'],
      gap: json['holiday'],
    );
  }
}

class Day {
  final DateTime? date;
  final bool? holiday;
  final List<Schedules>? schedules;

  Day({this.date, this.holiday, this.schedules});

  factory Day.fromJson(Map<String, dynamic> json) {
    return Day(
      date: DateTime.utc(json['date'][0], json['date'][1], json['date'][2]),
      holiday: json['holiday'],
      schedules: json['schedules'].map<Schedules>((json) => Schedules.fromJson(json)).toList(),
    );
  }
}

class Schedules {
  final int? id;
  final String? title;
  final String? content;
  final DateTime? startDate;
  final DateTime? endDate;
  final Labels? labels;

  Schedules({this.id, this.title, this.content, this.startDate, this.endDate, this.labels});

  factory Schedules.fromJson(Map<String, dynamic> json) {
    return Schedules(
        id: json['id'],
        title: json['title'],
        content: json['content'],
        startDate: DateTime.utc(json['start_date'][0], json['start_date'][1], json['start_date'][2], json['start_date'][3], json['start_date'][4]),
        endDate: DateTime.utc(json['end_date'][0], json['end_date'][1], json['end_date'][2], json['start_date'][3], json['start_date'][4]),
        labels: Labels.fromJson(json['labels']));
  }
}
