import 'package:flutter/material.dart';

import '../../domain/labels/Labels.dart';

class QuickSchedules {
  final int? id;
  final String? title;
  final String? content;
  final TimeOfDay? startTime;
  final TimeOfDay? endTime;
  final Labels? labels;

  QuickSchedules({this.id, this.title, this.content, this.startTime, this.endTime, this.labels});

  factory QuickSchedules.fromJson(Map<String, dynamic> json) {
    return QuickSchedules(
        id: json['id'],
        title: json['title'],
        content: json['content'],
        startTime: json['start_time'] == null ? null : TimeOfDay(hour: json['start_time'][0], minute: json['start_time'][1]),
        endTime: json['end_time'] == null ? null : TimeOfDay(hour: json['end_time'][0], minute: json['end_time'][1]),
        labels: Labels.fromJson(json['labels']));
  }
}
