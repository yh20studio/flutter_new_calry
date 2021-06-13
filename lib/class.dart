class Archives {
  final int? id;
  final String? title;
  final String? content;
  final String? url;
  final String? author;

  Archives({this.id, this.title, this.content, this.url, this.author});

  factory Archives.fromJson(Map<String, dynamic> json) {
    return Archives(
        id: json['id'],
        title: json['title'],
        content: json['content'],
        url: json['url'],
        author: json['author']);
  }
}
