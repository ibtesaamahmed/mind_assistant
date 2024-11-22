import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mind_assistant/constants/app_colors.dart';
import 'package:mind_assistant/constants/app_sizes.dart';
import 'package:mind_assistant/constants/global_instances.dart';
import 'package:mind_assistant/model/habit_model.dart';
import 'package:mind_assistant/views/widgets/my_text_widget.dart';

class HabitEditCalendarView extends StatefulWidget {
  final Habit habit;
  final VoidCallback onTap;

  const HabitEditCalendarView(
      {super.key, required this.habit, required this.onTap});

  @override
  State<HabitEditCalendarView> createState() => _HabitEditCalendarViewState();
}

class _HabitEditCalendarViewState extends State<HabitEditCalendarView> {
  late DateTime selectedMonth;

  @override
  void initState() {
    super.initState();
    selectedMonth = DateTime.now(); // Start with the current month
  }

  List<DateTime> getDaysInMonth(DateTime month) {
    final int totalDays = DateTime(month.year, month.month + 1, 0).day;
    return List.generate(
      totalDays,
      (index) => DateTime(month.year, month.month, index + 1),
    );
  }

  void updateMonth(int increment) {
    setState(() {
      selectedMonth =
          DateTime(selectedMonth.year, selectedMonth.month + increment, 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final daysInMonth = getDaysInMonth(selectedMonth);

    return Column(
      children: [
        // Month and Navigation Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () => updateMonth(-1), // Go to previous month
              icon: const Icon(
                Icons.arrow_back_ios,
                color: kBlueColor,
              ),
            ),
            MyText(
              text: "${selectedMonth.monthName()} ${selectedMonth.year}",
              weight: FontWeight.w600,
              size: 17,
            ),
            IconButton(
              onPressed: () => updateMonth(1), // Go to next month
              icon: const Icon(
                Icons.arrow_forward_ios,
                color: kBlueColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        // Days of the Month Grid
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: daysInMonth.length,
            itemBuilder: (context, index) {
              final date = daysInMonth[index];
              final isSelected = widget.habit.habitDates.any((habitDate) =>
                  habitDate.year == date.year &&
                  habitDate.month == date.month &&
                  habitDate.day == date.day);

              return GestureDetector(
                onTap: () {
                  if (isSelected) {
                    widget.habit.habitDates.removeWhere((habitDate) =>
                        habitDate.year == date.year &&
                        habitDate.month == date.month &&
                        habitDate.day == date.day);
                  } else {
                    widget.habit.habitDates.add(date);
                  }
                  habitsController.updateHabit(habit: widget.habit);
                  widget.onTap();
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      MyText(
                        text: date.dayName(),
                        weight: FontWeight.w400,
                        size: 17,
                      ),
                      MyText(
                        text: "${date.day}",
                        weight: FontWeight.w600,
                        size: 20,
                      ),
                      const SizedBox(height: 25),
                      Icon(
                        isSelected
                            ? Icons.check_circle
                            : Icons.radio_button_unchecked,
                        color: isSelected ? widget.habit.color : Colors.grey,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
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
