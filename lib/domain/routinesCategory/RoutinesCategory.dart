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
