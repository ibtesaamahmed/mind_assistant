import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mind_assistant/config/theme/theme_functions.dart';
import 'package:mind_assistant/constants/app_colors.dart';
import 'package:mind_assistant/constants/app_images.dart';
import 'package:mind_assistant/constants/app_sizes.dart';
import 'package:mind_assistant/constants/global_instances.dart';
import 'package:mind_assistant/controller/habits_controller.dart';
import 'package:mind_assistant/model/habit_model.dart';
import 'package:mind_assistant/views/screens/habits/add_new_habit_screen.dart';
import 'package:mind_assistant/views/widgets/habits_calendar_view.dart';
import 'package:mind_assistant/views/widgets/my_text_widget.dart';

class HabitsScreen extends StatelessWidget {
  const HabitsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: MyText(
          text: 'Habits',
          size: 17,
          weight: FontWeight.w600,
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              // isEmptyState = !isEmptyState;
              habitsController.haveNotification(false);
              habitsController.selectedTime('12:00');
              Get.to(
                () => const AddNewHabitScreen(),
                transition: Transition.rightToLeft,
              );
            },
            child: MyText(
              text: '+Add',
              color: kBlueColor,
              weight: FontWeight.w400,
              size: 17,
            ),
          ),
        ],
      ),
      body: GetBuilder<HabitsController>(
        init: habitsController,
        builder: (controller) => controller.habits.isEmpty
            ? _emptyState()
            : HabitCalendarView(
                habits: controller.habits,
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
                Assets.imagesHabitsBig,
                // fit: BoxFit.cover,
                height: 103,
                width: 85,
                scale: 1 / 3,
              ),
              const SizedBox(height: 20),
              Obx(
                () => MyText(
                  text:
                      'You don\'t yet have a habit that you are tracking. Create a habit to introduce it into your life and track your implementation progress',
                  size: 20,
                  weight: FontWeight.w600,
                  color: themeController.isDarkTheme.value
                      ? kWhiteColor.withOpacity(0.5)
                      : kGreyColor,
                  textAlign: TextAlign.center,
                ),
              )
            ],
          ),
        ),
      );
}
