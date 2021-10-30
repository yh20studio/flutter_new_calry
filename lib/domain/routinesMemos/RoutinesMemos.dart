class RoutinesMemos {
  final int? id;
  final int? routines_id;
  final String? content;
  final DateTime? created_date;
  final DateTime? modified_date;

  RoutinesMemos({this.id, this.routines_id, this.content, this.created_date, this.modified_date});

  factory RoutinesMemos.fromJson(Map<String, dynamic> json) {
    return RoutinesMemos(
        id: json['id'],
        content: json['content'],
        created_date: json['created_date'] == null ? null : DateTime.utc(json['created_date'][0], json['created_date'][1], json['created_date'][2]),
        modified_date: json['modified_date'] == null ? null : DateTime.utc(json['modified_date'][0], json['modified_date'][1], json['modified_date'][2]));
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'routines_id': routines_id,
      'content': content,
      'created_date': [created_date!.year, created_date!.month, created_date!.day, created_date!.hour, created_date!.minute, created_date!.second],
      'modified_date': [modified_date!.year, modified_date!.month, modified_date!.day, modified_date!.hour, modified_date!.minute, modified_date!.second],
    };
  }
}
