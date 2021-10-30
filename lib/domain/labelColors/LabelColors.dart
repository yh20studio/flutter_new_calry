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
