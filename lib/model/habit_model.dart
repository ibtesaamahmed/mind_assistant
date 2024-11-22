import 'package:flutter/material.dart';

class Habit {
  String habitId;
  String title;
  String description;
  Color color;
  List<String> repeatDays;
  bool notificationEnabled;
  String time;
  DateTime createdTime;
  List<DateTime> habitDates;

  Habit({
    required this.habitId,
    required this.title,
    required this.description,
    required this.color,
    required this.repeatDays,
    required this.notificationEnabled,
    required this.time,
    required this.createdTime,
    required this.habitDates,
  });

  Map<String, dynamic> toJson() {
    return {
      'habitId': habitId,
      'title': title,
      'description': description,
      'color': color.value,
      'repeatDays': repeatDays,
      'notificationEnabled': notificationEnabled,
      'time': time,
      'createdTime': createdTime.toIso8601String(),
      'habitDates': habitDates.map(
        (date) {
          return date.toIso8601String();
        },
      ).toList(),
    };
  }

  static Habit fromJson(Map<String, dynamic> map) {
    return Habit(
      habitId: map['habitId'],
      title: map['title'],
      description: map['description'],
      color: Color(map['color']),
      repeatDays: List<String>.from(map['repeatDays']),
      notificationEnabled: map['notificationEnabled'],
      time: map['time'],
      createdTime: DateTime.parse(map['createdTime']),
      habitDates: (map['habitDates'] as List<dynamic>)
          .map((date) => DateTime.parse(date))
          .toList(),
    );
  }
}
