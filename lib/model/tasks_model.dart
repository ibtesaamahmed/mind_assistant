import 'package:flutter_quill/quill_delta.dart';
import 'package:mind_assistant/config/enums/tasks_status.dart';

class TasksModel {
  String id;
  String title;
  Delta subTitle;
  DateTime lastEdited;
  TasksStatus status;
  TasksModel({
    required this.id,
    required this.title,
    required this.subTitle,
    required this.lastEdited,
    required this.status,
  });
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'subTitle': subTitle.toJson(),
      'lastEdited': lastEdited.toIso8601String(),
      'status': status.name,
    };
  }

  factory TasksModel.fromJson(Map<String, dynamic> map) {
    return TasksModel(
      id: map['id'],
      title: map['title'],
      subTitle: Delta.fromJson(map['subTitle']),
      lastEdited: DateTime.parse(map['lastEdited']),
      status: TasksStatus.values.firstWhere((e) => e.name == map['status']),
    );
  }
}
