import 'Days.dart';

class Week {
  final List<Days>? schedules;

  Week({this.schedules});

  factory Week.fromJson(Map<String, dynamic> json) {
    return Week(schedules: json['schedules'].map<Days>((json) => Days.fromJson(json)).toList());
  }
}
