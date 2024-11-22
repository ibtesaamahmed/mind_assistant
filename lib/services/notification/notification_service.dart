import 'dart:developer';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mind_assistant/model/schedule_notification_model.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as TZ;
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:uuid/uuid.dart';

class NotificationService {
  NotificationService._privateConstructor();

  static NotificationService? _instance;

  static NotificationService get instance {
    _instance ??= NotificationService._privateConstructor();
    return _instance!;
  }

  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> requestNotificationPermission() async {
    Permission.notification.request();
  }

  Future<void> initializeNotifications() async {
    TZ.initializeTimeZones();
    await requestNotificationPermission();

    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: androidInitializationSettings);
    await FlutterLocalNotificationsPlugin().initialize(initializationSettings);
  }

  Future<void> scheduleBacklogNotificationBefore(DateTime eventDateTime) async {
    TZ.initializeTimeZones();
    final String localTimeZone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(localTimeZone));
    await requestNotificationPermission();

    final tz.TZDateTime notificationDateTime =
        tz.TZDateTime.from(eventDateTime, tz.local)
            .subtract(const Duration(days: 30));

    try {
      await FlutterLocalNotificationsPlugin().zonedSchedule(
        0,
        'Backlog Deletion',
        'One of your backlog items is about to be deleted!',
        notificationDateTime,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            "backlogAlert",
            "backlogAlert",
            channelDescription: 'Channel for backlog reminders',
            importance: Importance.high,
            priority: Priority.high,
            playSound: true,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exact,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );
      log('successfull scheduled');
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> scheduleRepeatNotifications(
      {required List<String> selectedDays,
      required String selectedTime,
      required ScheduleNotificationModel notificationModel,
      required String body,
      required String title}) async {
    TZ.initializeTimeZones();
    final String localTimeZone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(localTimeZone));
    await requestNotificationPermission();

    final timeParts = selectedTime.split(':');
    final int hour = int.parse(timeParts[0]);
    final int minute = int.parse(timeParts[1]);

    for (String day in selectedDays) {
      int weekday = _getWeekday(day);
      DateTime now = DateTime.now();

      DateTime nextDay =
          now.add(Duration(days: (weekday - now.weekday + 7) % 7));
      DateTime nextDateTime =
          DateTime(nextDay.year, nextDay.month, nextDay.day, hour, minute);

      if (nextDateTime.isBefore(now)) {
        nextDateTime = nextDateTime.add(const Duration(days: 7));
      }
      final tz.TZDateTime notificationDateTime =
          tz.TZDateTime.from(nextDateTime, tz.local);

      await FlutterLocalNotificationsPlugin().zonedSchedule(
        Uuid().v4().hashCode.abs(),
        title,
        body,
        notificationDateTime,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'habitAlert',
            'habitAlert',
            channelDescription: 'Channel for habit reminders',
            importance: Importance.high,
            priority: Priority.high,
          ),
        ),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      );
    }
  }

  Future<void> cancelScheduleNotification({required int id}) async {
    await FlutterLocalNotificationsPlugin().cancel(id);
  }

  int _getWeekday(String day) {
    switch (day) {
      case 'Monday':
        return DateTime.monday;
      case 'Tuesday':
        return DateTime.tuesday;
      case 'Wednesday':
        return DateTime.wednesday;
      case 'Thursday':
        return DateTime.thursday;
      case 'Friday':
        return DateTime.friday;
      case 'Saturday':
        return DateTime.saturday;
      case 'Sunday':
        return DateTime.sunday;
      default:
        return DateTime.monday; // Default to Monday if no match
    }
  }
}
