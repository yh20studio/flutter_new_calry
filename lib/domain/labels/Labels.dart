import 'package:flutter_new_calry/domain/labelColors/LabelColors.dart';
import 'dart:convert';

class Labels {
  final int? id;
  final String? title;
  final int? sequence;
  final LabelColors? label_colors;

  Labels({this.id, this.title, this.sequence, this.label_colors});

  factory Labels.fromJson(Map<String, dynamic> json) {
    return Labels(id: json['id'], title: json['title'], sequence: json['sequence'], label_colors: LabelColors.fromJson(json['label_colors']));
  }

  Map<String, dynamic> toJson() => {'id': id, 'title': title, 'sequence': sequence, 'label_colors': label_colors!.toJson()};

  static Map<String, dynamic> toMap(Labels labels) =>
      {'id': labels.id, 'title': labels.title, 'sequence': labels.sequence, 'label_colors': LabelColors.toMap(labels.label_colors!)};

  static String encode(List<Labels> labels) => json.encode(
        labels.map<Map<String, dynamic>>((labels) => Labels.toMap(labels)).toList(),
      );

  static List<Labels> decode(String labels) => (json.decode(labels) as List<dynamic>).map<Labels>((item) => Labels.fromJson(item)).toList();
}
