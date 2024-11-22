import 'package:get/get.dart';
import 'package:mind_assistant/constants/global_instances.dart';
import 'package:mind_assistant/model/habit_model.dart';
import 'package:mind_assistant/model/schedule_notification_model.dart';
import 'package:mind_assistant/services/local%20storage/local_storage_service.dart';

class HabitsController extends GetxController {
  final _localStorageService = LocalStorageService.instance;
  RxBool haveNotification = false.obs;
  RxString selectedTime = '12:00'.obs;
  RxList<Habit> habits = <Habit>[].obs;
  RxList<ScheduleNotificationModel> habitNotifications =
      <ScheduleNotificationModel>[].obs;

  addHabit({required Habit habit}) async {
    habits.add(habit);
    await _localStorageService.writeHabits(habits);
    update();
  }

  updateHabit({required Habit habit}) async {
    final index = habits.indexWhere(
      (element) => element.habitId == habit.habitId,
    );
    habits[index] = habit;
    await _localStorageService.writeHabits(habits);
    update();
  }

  deleteHabit({required String habitId}) async {
    final index = habits.indexWhere(
      (element) => element.habitId == habitId,
    );
    habits.removeAt(index);
    await _localStorageService.writeHabits(habits);
    update();
  }

  @override
  void onInit() async {
    habits.value = await _localStorageService.readHabits();
    habitNotifications.value = await _localStorageService
        .readScheduleNotificationsList(key: habitScheduleNotificationsKey);
    super.onInit();
  }
}
