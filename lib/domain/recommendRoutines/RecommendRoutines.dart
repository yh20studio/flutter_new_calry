import '../../domain/timeDuration/TimeDuration.dart';
import '../../domain/routinesCategory/RoutinesCategory.dart';

class RecommendRoutines {
  final int? id;
  final String? icon;
  final String? title;
  final int? duration;
  final TimeDuration? timeDuration;
  final RoutinesCategory? routinesCategory;

  RecommendRoutines({this.id, this.icon, this.title, this.duration, this.timeDuration, this.routinesCategory});

  factory RecommendRoutines.fromJson(Map<String, dynamic> json) {
    return RecommendRoutines(
        id: json['id'],
        icon: json['icon'],
        title: json['title'],
        duration: json['duration'],
        timeDuration: TimeDuration(hour: json['duration'] ~/ 3600, min: json['duration'] % 3600 ~/ 60, sec: json['duration'] % 3600 % 60),
        routinesCategory: json['routinesCategory']);
  }
}
