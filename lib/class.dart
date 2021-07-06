class Member {
  final int? id;
  final String? name;
  final String? email;
  final String? picture;

  Member({this.id, this.name, this.email, this.picture});

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
        id: json['id'],
        name: json['name'],
        email: json['email'],
        picture: json['picture']);
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
