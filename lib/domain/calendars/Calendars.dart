import 'WeekCalendars.dart';
import '../../domain/schedules/Schedules.dart';

class WeekSchedulesCalendar {
  final Map<DateTime, WeekCalendars>? weekCalendars;
  final Map<int, Schedules>? schedules;
  final Map<DateTime, Schedules>? holidays;

  WeekSchedulesCalendar({this.schedules, this.weekCalendars, this.holidays});

  factory WeekSchedulesCalendar.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic>? jsonWeekCalendars = json['weekCalendarMap'];
    Map<DateTime, WeekCalendars> weekCalendars = {};
    jsonWeekCalendars!.forEach((key, value) {
      weekCalendars.putIfAbsent(DateTime.parse(key), () => WeekCalendars.fromJson(value));
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

    return WeekSchedulesCalendar(schedules: schedulesMap, weekCalendars: weekCalendars, holidays: map2);
  }
}

class PartWeekSchedules {
  final Map<DateTime, WeekCalendars>? weekCalendars;

  PartWeekSchedules({this.weekCalendars});

  factory PartWeekSchedules.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic>? jsonWeekCalendars = json['weekCalendarMap'];
    Map<DateTime, WeekCalendars> weekCalendars = {};
    jsonWeekCalendars!.forEach((key, value) {
      weekCalendars.putIfAbsent(DateTime.parse(key), () => WeekCalendars.fromJson(value));
    });
    return PartWeekSchedules(
      weekCalendars: weekCalendars,
    );
  }
}
