import 'package:get/get.dart';
import 'package:mind_assistant/config/theme/theme_controller.dart';
import 'package:mind_assistant/controller/backlog_controller.dart';
import 'package:mind_assistant/controller/habits_controller.dart';
import 'package:mind_assistant/controller/ideas_controller.dart';
import 'package:mind_assistant/controller/kanban_controller.dart';

class InitialBindings implements Bindings {
  @override
  void dependencies() {
    Get.put<ThemeController>(ThemeController());
    Get.put<BacklogController>(BacklogController());
    Get.put<IdeasController>(IdeasController());
    Get.put<KanbanController>(KanbanController());
    Get.put<HabitsController>(HabitsController());
  }
}
