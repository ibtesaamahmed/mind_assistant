import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mind_assistant/config/enums/tasks_status.dart';
import 'package:mind_assistant/config/theme/theme_functions.dart';
import 'package:mind_assistant/constants/app_colors.dart';
import 'package:mind_assistant/constants/app_images.dart';
import 'package:mind_assistant/constants/app_sizes.dart';
import 'package:mind_assistant/constants/global_instances.dart';
import 'package:mind_assistant/controller/kanban_controller.dart';
import 'package:mind_assistant/views/screens/kanban/add_new_kanban_screen.dart';
import 'package:mind_assistant/views/widgets/my_text_widget.dart';
import 'package:mind_assistant/views/widgets/tasks_tile_widget.dart';

class KanbanScreen extends StatelessWidget {
  KanbanScreen({super.key});
  bool isEmptyState = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: MyText(
          text: 'Knaban',
          size: 17,
          weight: FontWeight.w600,
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              // isEmptyState = !isEmptyState;
              Get.to(
                () => const AddNewKanbanScreen(),
                transition: Transition.rightToLeft,
              );
            },
            child: MyText(
              text: '+Add Task',
              color: kBlueColor,
              weight: FontWeight.w400,
              size: 17,
            ),
          ),
        ],
      ),
      body: Obx(
        () => kanbanController.kanbanTasks.isEmpty
            ? _emptyState()
            : GetBuilder<KanbanController>(
                init: kanbanController,
                builder: (controller) => Padding(
                  padding: AppSizes.defaultPadding,
                  child: TasksTileWidget(
                    todoTasks: controller.kanbanTasks
                        .where(
                          (task) => task.status == TasksStatus.todo,
                        )
                        .toList(),
                    progressTasks: controller.kanbanTasks
                        .where(
                          (task) => task.status == TasksStatus.progress,
                        )
                        .toList(),
                    doneTasks: controller.kanbanTasks
                        .where(
                          (task) => task.status == TasksStatus.done,
                        )
                        .toList(),
                  ),
                ),
              ),
      ),
    );
  }

  Widget _emptyState() => Padding(
        padding: AppSizes.defaultPadding,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                Assets.imagesKanbanBig,
                // fit: BoxFit.cover,
                height: 103,
                width: 85,
                scale: 1 / 3,
              ),
              const SizedBox(height: 20),
              Obx(
                () => MyText(
                  text: 'There are no tasks at this stage yet',
                  size: 20,
                  weight: FontWeight.w600,
                  color: themeController.isDarkTheme.value
                      ? kWhiteColor.withOpacity(0.5)
                      : kGreyColor,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      );
}
