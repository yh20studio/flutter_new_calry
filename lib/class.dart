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

class CustomRoutines {
  final int? id;
  final String? icon;
  final String? title;
  final int? duration;
  final TimeDuration? timeDuration;

  CustomRoutines(
      {this.id, this.icon, this.title, this.duration, this.timeDuration});

  factory CustomRoutines.fromJson(Map<String, dynamic> json) {
    return CustomRoutines(
        id: json['id'],
        icon: json['icon'],
        title: json['title'],
        duration: json['duration'],
        timeDuration: TimeDuration(
            hour: json['duration'] ~/ 3600,
            min: json['duration'] % 3600 ~/ 60,
            sec: json['duration'] % 3600 % 60));
  }
}

class Routines {
  final int? id;
  final String? icon;
  final String? title;
  final List<Memos>? routines_memosList;
  final int? duration;
  final TimeDuration? timeDuration;

  Routines(
      {this.id,
      this.icon,
      this.title,
      this.routines_memosList,
      this.duration,
      this.timeDuration});

  factory Routines.fromJson(Map<String, dynamic> json) {
    return Routines(
        id: json['id'],
        icon: json['icon'],
        title: json['title'],
        routines_memosList: json['routines_memosList']
            .map<Memos>((json) => Memos.fromJson(json))
            .toList(),
        duration: json['duration'],
        timeDuration: TimeDuration(
            hour: json['duration'] ~/ 3600,
            min: json['duration'] % 3600 ~/ 60,
            sec: json['duration'] % 3600 % 60));
  }
}

class Memos {
  final int? id;
  final int? routines_id;
  final String? content;
  final DateTime? created_date;
  final DateTime? modified_date;

  Memos(
      {this.id,
      this.routines_id,
      this.content,
      this.created_date,
      this.modified_date});

  factory Memos.fromJson(Map<String, dynamic> json) {
    return Memos(
        id: json['id'],
        routines_id: json['routines_id'],
        content: json['content'],
        created_date: DateTime.utc(json['created_date'][0],
            json['created_date'][1], json['created_date'][2]),
        modified_date: DateTime.utc(json['modified_date'][0],
            json['modified_date'][1], json['modified_date'][2]));
  }
}

class TimeDuration {
  int? hour;
  int? min;
  int? sec;

  TimeDuration({this.hour, this.min, this.sec});
}
