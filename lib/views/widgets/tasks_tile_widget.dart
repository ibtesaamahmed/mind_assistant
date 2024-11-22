import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mind_assistant/config/enums/tasks_status.dart';
import 'package:mind_assistant/config/theme/theme_functions.dart';
import 'package:mind_assistant/constants/app_colors.dart';
import 'package:mind_assistant/constants/app_sizes.dart';
import 'package:mind_assistant/constants/global_instances.dart';
import 'package:mind_assistant/model/tasks_model.dart';
import 'package:mind_assistant/views/screens/kanban/edit_kanban_task_screen.dart';
import 'package:mind_assistant/views/widgets/my_text_widget.dart';

class TasksTileWidget extends StatelessWidget {
  const TasksTileWidget({
    required this.todoTasks,
    required this.progressTasks,
    required this.doneTasks,
    super.key,
  });
  final List<TasksModel> todoTasks;
  final List<TasksModel> progressTasks;
  final List<TasksModel> doneTasks;

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      children: [
        /// Todo

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            MyText(
              text: 'To do',
              color: const Color.fromRGBO(61, 186, 232, 1),
              weight: FontWeight.w500,
              size: 17,
            ),
            MyText(
                text: '${todoTasks.length}',
                color: const Color.fromRGBO(61, 186, 232, 1),
                weight: FontWeight.w500,
                size: 17)
          ],
        ),
        const SizedBox(height: 8),
        Divider(
          color: Colors.grey.withOpacity(0.5),
        ),
        Padding(
          padding: AppSizes.verticalPadding,
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: todoTasks.length,
            itemBuilder: (context, index) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Slidable(
                  endActionPane: ActionPane(
                    motion: ScrollMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (context) {
                          kanbanController.changeStatus(
                              id: todoTasks[index].id,
                              status: TasksStatus.progress);
                        },
                        backgroundColor: kOrangeColor,
                        icon: Icons.arrow_circle_right_rounded,
                        foregroundColor: kWhiteColor,
                      ),
                      SlidableAction(
                        onPressed: (context) {
                          kanbanController.removeKanbanTask(
                              id: todoTasks[index].id);
                        },
                        backgroundColor: kRedColor,
                        icon: Icons.delete,
                      ),
                    ],
                  ),
                  child: GestureDetector(
                    onTap: () {
                      Get.to(
                          () => EditKanbanTaskScreen(task: todoTasks[index]));
                    },
                    child: ListView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        MyText(
                          text: todoTasks[index].title,
                          weight: FontWeight.w500,
                          size: 21,
                        ),
                        const SizedBox(height: 3),
                        Obx(
                          () => MyText(
                            // text: todoTasks[index].title,
                            text:
                                'Last edited : ${formatDateTime(todoTasks[index].lastEdited)}',
                            weight: FontWeight.w400,
                            size: 14,
                            color: themeController.isDarkTheme.value
                                ? kWhiteColor.withOpacity(0.5)
                                : kGreyColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Divider(
                  color: Colors.grey.withOpacity(0.5),
                ),
              ],
            ),
          ),
        ),

        /// PROGRESS
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            MyText(
              text: 'Progress',
              color: kOrangeColor,
              weight: FontWeight.w500,
              size: 17,
            ),
            MyText(
                text: '${progressTasks.length}',
                color: kOrangeColor,
                weight: FontWeight.w500,
                size: 17)
          ],
        ),
        const SizedBox(height: 8),
        Divider(
          color: Colors.grey.withOpacity(0.5),
        ),
        Padding(
          padding: AppSizes.verticalPadding,
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: progressTasks.length,
            itemBuilder: (context, index) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Slidable(
                  endActionPane: ActionPane(
                    motion: ScrollMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (context) {
                          kanbanController.changeStatus(
                              id: progressTasks[index].id,
                              status: TasksStatus.done);
                        },
                        backgroundColor: kGreenColor,
                        icon: Icons.arrow_circle_right_rounded,
                        foregroundColor: kWhiteColor,
                      ),
                      SlidableAction(
                        onPressed: (context) {
                          kanbanController.removeKanbanTask(
                              id: progressTasks[index].id);
                        },
                        backgroundColor: kRedColor,
                        icon: Icons.delete,
                      ),
                    ],
                  ),
                  child: GestureDetector(
                    onTap: () {
                      Get.to(() =>
                          EditKanbanTaskScreen(task: progressTasks[index]));
                    },
                    child: ListView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        MyText(
                          text: progressTasks[index].title,
                          weight: FontWeight.w500,
                          size: 21,
                        ),
                        const SizedBox(height: 3),
                        Obx(
                          () => MyText(
                            // text: todoTasks[index].title,
                            text:
                                'Last edited : ${formatDateTime(progressTasks[index].lastEdited)}',
                            weight: FontWeight.w400,
                            size: 14,
                            color: themeController.isDarkTheme.value
                                ? kWhiteColor.withOpacity(0.5)
                                : kGreyColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Divider(
                  color: Colors.grey.withOpacity(0.5),
                ),
              ],
            ),
          ),
        ),

        /// Done
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            MyText(
              text: 'Done',
              color: kGreenColor,
              weight: FontWeight.w500,
              size: 17,
            ),
            MyText(
                text: '${doneTasks.length}',
                color: kGreenColor,
                weight: FontWeight.w500,
                size: 17)
          ],
        ),
        const SizedBox(height: 8),
        Divider(
          color: Colors.grey.withOpacity(0.5),
        ),
        Padding(
          padding: AppSizes.verticalPadding,
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: doneTasks.length,
            itemBuilder: (context, index) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Slidable(
                  endActionPane: ActionPane(
                    motion: ScrollMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (context) {
                          kanbanController.removeKanbanTask(
                              id: doneTasks[index].id);
                        },
                        backgroundColor: kRedColor,
                        icon: Icons.delete,
                      ),
                    ],
                  ),
                  child: GestureDetector(
                    onTap: () {
                      Get.to(
                          () => EditKanbanTaskScreen(task: doneTasks[index]));
                    },
                    child: ListView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        MyText(
                          text: doneTasks[index].title,
                          weight: FontWeight.w500,
                          size: 21,
                        ),
                        const SizedBox(height: 3),
                        Obx(
                          () => MyText(
                            // text: todoTasks[index].title,
                            text:
                                'Last edited : ${formatDateTime(doneTasks[index].lastEdited)}',
                            weight: FontWeight.w400,
                            size: 14,
                            color: themeController.isDarkTheme.value
                                ? kWhiteColor.withOpacity(0.5)
                                : kGreyColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Divider(
                  color: Colors.grey.withOpacity(0.5),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String formatDateTime(DateTime dateTime) {
    final DateFormat formatter = DateFormat('dd.MM.yy (HH:mm)');
    return formatter.format(dateTime);
  }
}
