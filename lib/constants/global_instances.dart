import 'dart:ui';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mind_assistant/controller/backlog_controller.dart';
import 'package:mind_assistant/controller/habits_controller.dart';
import 'package:mind_assistant/controller/ideas_controller.dart';
import 'package:mind_assistant/controller/kanban_controller.dart';

final backlogController = Get.find<BacklogController>();
final ideasController = Get.find<IdeasController>();
final kanbanController = Get.find<KanbanController>();
final habitsController = Get.find<HabitsController>();
String darkThemeKey = 'darkTheme';
String backLogsKey = 'backlogs';
String ideasKey = 'ideas';
String kanbanTasksKey = 'kanbanTasks';
String habitsKey = 'habits';
String backlogScheduleNotificationsKey = 'backlogScheduleNotifications';
String habitScheduleNotificationsKey = 'habitScheduleNotifications';

String formatDateTime(DateTime dateTime) {
  return DateFormat('MMM d, y').format(dateTime);
}

int daysLeft(DateTime targetDate) {
  DateTime now = DateTime.now();
  Duration difference = targetDate.difference(now);
  return difference.inDays;
}
