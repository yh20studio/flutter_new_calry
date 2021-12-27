class Days {
  final int? scheduleId;
  final int? width;

  Days({this.scheduleId, this.width});

  factory Days.fromJson(Map<String, dynamic> json) {
    return Days(scheduleId: json["scheduleId"], width: json["width"]);
  }
}
