import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mind_assistant/constants/app_colors.dart';
import 'package:mind_assistant/constants/app_sizes.dart';
import 'package:mind_assistant/constants/global_instances.dart';
import 'package:mind_assistant/model/habit_model.dart';
import 'package:mind_assistant/views/screens/habits/edit_habit_screen.dart';
import 'package:mind_assistant/views/widgets/my_text_widget.dart';

class HabitCalendarView extends StatelessWidget {
  final List<Habit> habits;

  const HabitCalendarView({super.key, required this.habits});

  @override
  Widget build(BuildContext context) {
    final DateTime today = DateTime.now();
    final List<DateTime> weekDays = List.generate(
      7,
      (index) => today.add(Duration(days: index)),
    );

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: Get.width * 1.5,
        child: Padding(
          padding: const EdgeInsets.only(left: 12, top: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: Get.width * 0.3,
                    child: MyText(
                      text: '${today.monthName()}\n${today.year}',
                      weight: FontWeight.w400,
                      size: 17,
                    ),
                  ),
                  const SizedBox(width: 20),
                  ...weekDays.map((date) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        children: [
                          MyText(
                            text: date.dayName(),
                            weight: FontWeight.w400,
                            size: 17,
                          ),
                          const SizedBox(height: 4),
                          MyText(
                            text: "${date.day}",
                            weight: FontWeight.w600,
                            size: 20,
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
              Divider(
                color: Colors.grey.withOpacity(0.5),
                endIndent: Get.width * 0.2,
              ),
              Expanded(
                child: SizedBox(
                  width: Get.width * 1.5,
                  child: ListView.builder(
                    itemCount: habits.length,
                    itemBuilder: (context, habitIndex) {
                      Habit habit = habits[habitIndex];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Get.to(
                                      () => EditHabitScreen(
                                        habit: habit,
                                      ),
                                      transition: Transition.rightToLeft,
                                    );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: habit.color,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    width: Get.width * 0.3,
                                    child: MyText(
                                      text: habit.title,
                                      size: 17,
                                      weight: FontWeight.w500,
                                      color: kWhiteColor,
                                      paddingTop: 8,
                                      paddingBottom: 8,
                                      paddingLeft: 10,
                                      paddingRight: 10,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                ...weekDays.map((date) {
                                  bool isSelected =
                                      habit.habitDates.any((habitDate) {
                                    return habitDate.year == date.year &&
                                        habitDate.month == date.month &&
                                        habitDate.day == date.day;
                                    // && habitDate.isSelected;
                                  });

                                  return Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 11),
                                    child: GestureDetector(
                                      onTap: () {
                                        if (isSelected) {
                                          final index =
                                              habit.habitDates.indexWhere(
                                            (habitDate) =>
                                                habitDate.year == date.year &&
                                                habitDate.month == date.month &&
                                                habitDate.day == date.day,
                                          );
                                          habit.habitDates.removeAt(index);
                                        } else {
                                          habit.habitDates.add(date);
                                        }
                                        habitsController.updateHabit(
                                            habit: habit);
                                      },
                                      child: Icon(
                                        isSelected
                                            ? Icons.check_circle
                                            : Icons.radio_button_unchecked,
                                        color: isSelected
                                            ? habit.color
                                            : Colors.grey,
                                      ),
                                    ),
                                  );
                                }),
                              ],
                            ),
                            Divider(
                              color: Colors.grey.withOpacity(0.5),
                              endIndent: Get.width * 0.2,
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

extension DateTimeExtensions on DateTime {
  String dayName() {
    return ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"][weekday - 1];
  }

  String monthName() {
    return [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December"
    ][month - 1];
  }
}
