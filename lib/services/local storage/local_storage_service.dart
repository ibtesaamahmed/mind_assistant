import 'dart:convert';
import 'dart:developer';

import 'package:mind_assistant/constants/global_instances.dart';
import 'package:mind_assistant/model/backlog_model.dart';
import 'package:mind_assistant/model/habit_model.dart';
import 'package:mind_assistant/model/ideas_model.dart';
import 'package:mind_assistant/model/schedule_notification_model.dart';
import 'package:mind_assistant/model/tasks_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  LocalStorageService._privateConstructor();

  static LocalStorageService? _instance;

  static LocalStorageService get instance {
    _instance ??= LocalStorageService._privateConstructor();
    return _instance!;
  }

  /// For Theme

  Future<void> writeTheme(bool isDarkTheme) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      prefs.setBool(darkThemeKey, isDarkTheme);
      log('theme added to local storage successfully');
    } catch (e) {
      log(e.toString());
    }
  }

  Future<bool> readTheme() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final isDarkTheme = prefs.getBool(darkThemeKey);
      log('theme fetched from local storage successfully');
      return isDarkTheme ?? false;
    } catch (e) {
      return false;
    }
  }

  /// For Backlog

  Future<void> writeBacklogList(List<BacklogModel> backlogList) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      List<String> jsonList =
          backlogList.map((backlog) => json.encode(backlog.toJson())).toList();
      await prefs.remove(backLogsKey);
      await prefs.setStringList(backLogsKey, jsonList);
      log('backlogs added to local storage successfully');
    } catch (e) {
      log(e.toString());
    }
  }

  Future<List<BacklogModel>> readBacklogList() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      List<String>? jsonList = prefs.getStringList(backLogsKey);
      if (jsonList == null) {
        return [];
      }
      log('backlogs fetched from local storage successfully');
      return jsonList
          .map((jsonString) => BacklogModel.fromJson(json.decode(jsonString)))
          .toList();
    } catch (e) {
      log(e.toString());
      return [];
    }
  }

  /// For Ideas

  Future<void> writeIdeasList(List<IdeasModel> ideasList) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      List<String> jsonList =
          ideasList.map((idea) => json.encode(idea.toJson())).toList();
      await prefs.remove(ideasKey);
      await prefs.setStringList(ideasKey, jsonList);
      log('ideas added to local storage successfully');
    } catch (e) {
      log(e.toString());
    }
  }

  Future<List<IdeasModel>> readIdeasList() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      List<String>? jsonList = prefs.getStringList(ideasKey);
      if (jsonList == null) {
        return [];
      }
      log('ideas fetched from local storage successfully');
      return jsonList
          .map((jsonString) => IdeasModel.fromJson(json.decode(jsonString)))
          .toList();
    } catch (e) {
      log(e.toString());
      return [];
    }
  }

  /// For Kanban Tasks

  Future<void> writeKanbanTasksList(List<TasksModel> taskList) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      List<String> jsonList =
          taskList.map((task) => json.encode(task.toJson())).toList();
      await prefs.remove(kanbanTasksKey);
      await prefs.setStringList(kanbanTasksKey, jsonList);
      log('kanban task added to local storage successfully');
    } catch (e) {
      log(e.toString());
    }
  }

  Future<List<TasksModel>> readKanbanTaskList() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      List<String>? jsonList = prefs.getStringList(kanbanTasksKey);
      if (jsonList == null) {
        return [];
      }
      log('kanban tasks fetched from local storage successfully');
      return jsonList
          .map((jsonString) => TasksModel.fromJson(json.decode(jsonString)))
          .toList();
    } catch (e) {
      log(e.toString());
      return [];
    }
  }

  /// For Habits

  Future<void> writeHabits(List<Habit> habitList) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      List<String> jsonList =
          habitList.map((habit) => json.encode(habit.toJson())).toList();
      await prefs.remove(habitsKey);
      await prefs.setStringList(habitsKey, jsonList);
      log('habits added to local storage successfully');
    } catch (e) {
      log(e.toString());
    }
  }

  Future<List<Habit>> readHabits() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      List<String>? jsonList = prefs.getStringList(habitsKey);
      if (jsonList == null) {
        return [];
      }
      log('habits fetched from local storage successfully');
      return jsonList
          .map((jsonString) => Habit.fromJson(json.decode(jsonString)))
          .toList();
    } catch (e) {
      log(e.toString());
      return [];
    }
  }

  /// For Schedule Notifications

  Future<void> writeScheduleNotificationsList({
    required List<ScheduleNotificationModel> notications,
    required String key,
  }) async {
    notications.forEach(
      (element) => log(element.toJson().toString()),
    );
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      List<String> jsonList = notications
          .map((notication) => json.encode(notication.toJson()))
          .toList();
      await prefs.remove(key);
      await prefs.setStringList(key, jsonList);
      log('notificaitons added to local storage successfully');
    } catch (e) {
      log(e.toString());
    }
  }

  Future<List<ScheduleNotificationModel>> readScheduleNotificationsList(
      {required String key}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      List<String>? jsonList = prefs.getStringList(key);
      if (jsonList == null) {
        return [];
      }
      log('notifications fetched from local storage successfully');
      return jsonList
          .map((jsonString) =>
              ScheduleNotificationModel.fromJson(json.decode(jsonString)))
          .toList();
    } catch (e) {
      log(e.toString());
      return [];
    }
  }
}
