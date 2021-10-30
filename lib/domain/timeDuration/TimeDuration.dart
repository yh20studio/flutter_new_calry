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
