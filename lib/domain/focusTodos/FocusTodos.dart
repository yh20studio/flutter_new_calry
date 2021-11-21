import 'package:flutter_new_calry/domain/member/Member.dart';

class FocusTodos {
  final int? id;
  final String? content;
  final bool? success;
  final DateTime? successDateTime;
  final Member? member;

  FocusTodos({this.id, this.content, this.success, this.successDateTime, this.member});

  factory FocusTodos.fromJson(Map<String, dynamic> json) {
    return FocusTodos(
        id: json['id'],
        content: json['content'],
        success: json['success'],
        successDateTime: json['successDateTime'] == null
            ? null
            : DateTime.utc(
                json['successDateTime'][0], json['successDateTime'][1], json['successDateTime'][2], json['successDateTime'][3], json['successDateTime'][4]),
        member: Member.fromJson(json['member']));
  }
}
