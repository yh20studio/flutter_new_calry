import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'functions.dart';
import 'dart:convert';

class Member {
  final int? id;
  final String? name;
  final String? email;
  final String? picture;

  Member({this.id, this.name, this.email, this.picture});

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(id: json['id'], name: json['name'], email: json['email'], picture: json['picture']);
  }
}

class RoutinesCategory {
  final int? id;
  final String? title;

  RoutinesCategory({this.id, this.title});

  factory RoutinesCategory.fromJson(Map<String, dynamic> json) {
    return RoutinesCategory(
      id: json['id'],
      title: json['title'],
    );
  }
}

class Archives {
  final int? id;
  final String? title;
  final String? content;
  final String? url;

  Archives({this.id, this.title, this.content, this.url});

  factory Archives.fromJson(Map<String, dynamic> json) {
    return Archives(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      url: json['url'],
    );
  }
}

class CustomRoutines {
  final int? id;
  final String? icon;
  final String? title;
  final int? duration;
  final TimeDuration? timeDuration;

  CustomRoutines({this.id, this.icon, this.title, this.duration, this.timeDuration});

  factory CustomRoutines.fromJson(Map<String, dynamic> json) {
    return CustomRoutines(
        id: json['id'],
        icon: json['icon'],
        title: json['title'],
        duration: json['duration'],
        timeDuration: TimeDuration(hour: json['duration'] ~/ 3600, min: json['duration'] % 3600 ~/ 60, sec: json['duration'] % 3600 % 60));
  }
}

class RecommendRoutines {
  final int? id;
  final String? icon;
  final String? title;
  final int? duration;
  final TimeDuration? timeDuration;
  final Category? category;

  RecommendRoutines({this.id, this.icon, this.title, this.duration, this.timeDuration, this.category});

  factory RecommendRoutines.fromJson(Map<String, dynamic> json) {
    return RecommendRoutines(
        id: json['id'],
        icon: json['icon'],
        title: json['title'],
        duration: json['duration'],
        timeDuration: TimeDuration(hour: json['duration'] ~/ 3600, min: json['duration'] % 3600 ~/ 60, sec: json['duration'] % 3600 % 60),
        category: json['category']);
  }
}

class RoutinesGroups {
  final int? id;
  final String? title;
  final List<Routines>? routinesList;
  final int? duration;
  final TimeDuration? timeDuration;

  RoutinesGroups({this.id, this.title, this.routinesList, this.duration, this.timeDuration});

  factory RoutinesGroups.fromJson(Map<String, dynamic> json) {
    return RoutinesGroups(
        id: json['id'],
        title: json['title'],
        routinesList: json['routinesList'].map<Routines>((json) => Routines.fromJson(json)).toList(),
        duration: json['duration'],
        timeDuration: TimeDuration(hour: json['duration'] ~/ 3600, min: json['duration'] % 3600 ~/ 60, sec: json['duration'] % 3600 % 60));
  }
}

class Routines {
  final int? id;
  final String? icon;
  final String? title;
  final List<Memos>? routines_memosList;
  final int? duration;
  final TimeDuration? timeDuration;

  Routines({this.id, this.icon, this.title, this.routines_memosList, this.duration, this.timeDuration});

  factory Routines.fromJson(Map<String, dynamic> json) {
    return Routines(
        id: json['id'],
        icon: json['icon'],
        title: json['title'],
        routines_memosList: json['routines_memosList'].map<Memos>((json) => Memos.fromJson(json)).toList(),
        duration: json['duration'],
        timeDuration: TimeDuration(hour: json['duration'] ~/ 3600, min: json['duration'] % 3600 ~/ 60, sec: json['duration'] % 3600 % 60));
  }
}

class Memos {
  final int? id;
  final int? routines_id;
  final String? content;
  final DateTime? created_date;
  final DateTime? modified_date;

  Memos({this.id, this.routines_id, this.content, this.created_date, this.modified_date});

  factory Memos.fromJson(Map<String, dynamic> json) {
    return Memos(
        id: json['id'],
        routines_id: json['routines_id'],
        content: json['content'],
        created_date: DateTime.utc(json['created_date'][0], json['created_date'][1], json['created_date'][2]),
        modified_date: DateTime.utc(json['modified_date'][0], json['modified_date'][1], json['modified_date'][2]));
  }
}

class TimeDuration {
  int? hour;
  int? min;
  int? sec;

  TimeDuration({this.hour, this.min, this.sec});
}

class Date {
  final DateTime? dateTime;
  final bool? holiday;

  Date({this.dateTime, this.holiday});

  factory Date.fromJson(Map<String, dynamic> json) {
    return Date(dateTime: DateTime.utc(json['date'][0], json['date'][1], json['date'][2]), holiday: json['holiday']);
  }
}

class WeekSchedulesCalendar {
  final Map<DateTime, List<dynamic>>? weekSchedules;
  final Map<int, Schedule>? schedules;
  final Map<DateTime, Schedule>? holidays;

  WeekSchedulesCalendar({this.schedules, this.weekSchedules, this.holidays});

  factory WeekSchedulesCalendar.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic>? weekMap = json['weekSchedules'];
    Map<DateTime, List<dynamic>> map = {};
    weekMap!.forEach((key, value) {
      map.putIfAbsent(DateTime.parse(key), () => value);
    });

    List<Schedule>? schedulesList = json['schedules'].map<Schedule>((json) => Schedule.fromJson(json)).toList();
    Map<int, Schedule> schedulesMap = {};
    schedulesList!.forEach((element) {
      schedulesMap.putIfAbsent(element.id!, () => element);
    });

    Map<String, dynamic>? holidaysMap = json['holidays'];
    Map<DateTime, Schedule> map2 = {};
    holidaysMap!.forEach((key, value) {
      map2.putIfAbsent(DateTime.parse(key), () => Schedule.fromJson(value));
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
  final List<Schedule>? schedules;

  Day({this.date, this.holiday, this.schedules});

  factory Day.fromJson(Map<String, dynamic> json) {
    return Day(
      date: DateTime.utc(json['date'][0], json['date'][1], json['date'][2]),
      holiday: json['holiday'],
      schedules: json['schedules'].map<Schedule>((json) => Schedule.fromJson(json)).toList(),
    );
  }
}

class Schedule {
  final int? id;
  final String? title;
  final String? content;
  final DateTime? startDate;
  final DateTime? endDate;
  final Labels? labels;

  Schedule({this.id, this.title, this.content, this.startDate, this.endDate, this.labels});

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
        id: json['id'],
        title: json['title'],
        content: json['content'],
        startDate: DateTime.utc(json['start_date'][0], json['start_date'][1], json['start_date'][2]),
        endDate: DateTime.utc(json['end_date'][0], json['end_date'][1], json['end_date'][2]),
        labels: Labels.fromJson(json['labels']));
  }
}

class Labels {
  final int? id;
  final String? title;
  final int? sequence;
  final LabelColors? label_colors;

  Labels({this.id, this.title, this.sequence, this.label_colors});

  factory Labels.fromJson(Map<String, dynamic> json) {
    return Labels(id: json['id'], title: json['title'], sequence: json['sequence'], label_colors: LabelColors.fromJson(json['label_colors']));
  }

  Map<String, dynamic> toJson() => {'id': id, 'title': title, 'sequence': sequence, 'label_colors': label_colors!.toJson()};

  static Map<String, dynamic> toMap(Labels labels) =>
      {'id': labels.id, 'title': labels.title, 'sequence': labels.sequence, 'label_colors': LabelColors.toMap(labels.label_colors!)};

  static String encode(List<Labels> labels) => json.encode(
        labels.map<Map<String, dynamic>>((labels) => Labels.toMap(labels)).toList(),
      );

  static List<Labels> decode(String labels) => (json.decode(labels) as List<dynamic>).map<Labels>((item) => Labels.fromJson(item)).toList();
}

class LabelColors {
  final int? id;
  final String? title;
  final String? code;

  LabelColors({this.id, this.title, this.code});

  factory LabelColors.fromJson(Map<String, dynamic> json) {
    return LabelColors(id: json['id'], title: json['title'], code: json['code']);
  }

  Map<String, dynamic> toJson() => {'id': id, 'title': title, 'code': code};

  static Map<String, dynamic> toMap(LabelColors labelColors) => {'id': labelColors.id, 'title': labelColors.title, 'code': labelColors.code};
}
