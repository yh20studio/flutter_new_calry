import 'Week.dart';

class WeekCalendars {
  final List<Week>? weeks;

  WeekCalendars({this.weeks});

  factory WeekCalendars.fromJson(Map<String, dynamic> json) {
    return WeekCalendars(weeks: json['weeks'].map<Week>((json) => Week.fromJson(json)).toList());
  }
}
