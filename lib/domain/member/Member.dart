class Member {
  final int? id;
  final String? name;
  final String? email;

  Member({this.id, this.name, this.email});

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(id: json['id'], name: json['name'], email: json['email']);
  }
}
