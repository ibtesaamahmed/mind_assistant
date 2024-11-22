import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mind_assistant/config/theme/theme_functions.dart';
import 'package:mind_assistant/constants/app_colors.dart';
import 'package:mind_assistant/constants/app_fonts.dart';
import 'package:mind_assistant/constants/app_sizes.dart';
import 'package:mind_assistant/constants/global_instances.dart';
import 'package:mind_assistant/controller/habits_controller.dart';
import 'package:mind_assistant/model/habit_model.dart';
import 'package:mind_assistant/model/schedule_notification_model.dart';
import 'package:mind_assistant/services/notification/notification_service.dart';
import 'package:mind_assistant/views/widgets/custom_textfield_widget.dart';
import 'package:mind_assistant/views/widgets/habit_edit_calendar_view.dart';
import 'package:mind_assistant/views/widgets/habits_calendar_view.dart';
import 'package:mind_assistant/views/widgets/my_text_widget.dart';
import 'package:uuid/uuid.dart';

class EditHabitScreen extends StatefulWidget {
  final Habit habit;
  const EditHabitScreen({
    required this.habit,
    super.key,
  });

  @override
  State<EditHabitScreen> createState() => _EditHabitScreenState();
}

class _EditHabitScreenState extends State<EditHabitScreen> {
  List<Map<String, dynamic>> days = [
    {
      'day': 'Monday',
      'isSelected': false,
    },
    {
      'day': 'Tuesday',
      'isSelected': false,
    },
    {
      'day': 'Wednesday',
      'isSelected': false,
    },
    {
      'day': 'Thursday',
      'isSelected': false,
    },
    {
      'day': 'Friday',
      'isSelected': false,
    },
    {
      'day': 'Saturday',
      'isSelected': false,
    },
    {
      'day': 'Sunday',
      'isSelected': false,
    },
  ];

  final habitTitleController = TextEditingController();
  final habitDescriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    habitTitleController.text = widget.habit.title;
    habitDescriptionController.text = widget.habit.description;
    habitsController.haveNotification.value = widget.habit.notificationEnabled;
    habitsController.selectedTime.value = widget.habit.time;
    for (int index = 0; index < days.length; index++) {
      if (widget.habit.repeatDays.contains(days[index]['day'])) {
        days[index]['isSelected'] = true;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _onUpdate();
        return Future.value(true);
      },
      child: Scaffold(
        appBar: AppBar(
          leadingWidth: Get.width * 0.3,
          automaticallyImplyLeading: false,
          title: MyText(
            text: 'Habit',
            size: 17,
            weight: FontWeight.w600,
          ),
          centerTitle: true,
          leading: GestureDetector(
            onTap: () {
              _onUpdate();
              Get.back();
            },
            child: Row(
              children: [
                const Icon(
                  Icons.arrow_back_ios_new,
                  color: kBlueColor,
                ),
                MyText(
                  text: 'Back',
                  color: kBlueColor,
                  weight: FontWeight.w400,
                  size: 17,
                ),
              ],
            ),
          ),
          actions: [
            GestureDetector(
              onTap: () {
                habitsController.deleteHabit(habitId: widget.habit.habitId);
                Get.back();
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Icon(
                    Icons.delete,
                    color: kRedColor,
                  ),
                  MyText(
                    text: 'Delete',
                    color: kRedColor,
                    weight: FontWeight.w400,
                    size: 17,
                    paddingRight: 10,
                  ),
                ],
              ),
            ),
          ],
        ),
        body: Obx(() {
          final isDarkTheme = themeController.isDarkTheme.value;
          final color = isDarkTheme ? kWhiteColor : kBlackColor;
          return Padding(
            padding: AppSizes.verticalPadding,
            child: ListView(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              children: [
                Padding(
                  padding: AppSizes.horizontalPadding,
                  child: CustomTextField(
                    readOnly: false,
                    controller: habitTitleController,
                    cursorColor: color,
                    hintText: 'Habit Title',
                    hintTextStyle: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 34,
                      fontFamily: AppFonts.Inter,
                      color: color,
                    ),
                    textStyle: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 34,
                      fontFamily: AppFonts.Inter,
                      color: color,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: AppSizes.horizontalPadding,
                  child: CustomTextField(
                    maxLines: 3,
                    readOnly: false,
                    controller: habitDescriptionController,
                    hintTextStyle: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 17,
                      color: isDarkTheme
                          ? kWhiteColor.withOpacity(0.65)
                          : kGreyColor,
                      fontFamily: AppFonts.Inter,
                    ),
                    textStyle: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 17,
                      color: isDarkTheme ? kWhiteColor : kBlackColor,
                      fontFamily: AppFonts.Inter,
                    ),
                    cursorColor: kBlueColor,
                    hintText: 'Description of your new habit',
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: Get.height * 0.3,
                  child: GetBuilder<HabitsController>(
                    init: habitsController,
                    builder: (controller) => HabitEditCalendarView(
                      habit: widget.habit,
                      onTap: () {
                        getBestSeries(widget.habit.habitDates);
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: AppSizes.horizontalPadding,
                  child: Divider(
                    color: Colors.grey.withOpacity(0.5),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: AppSizes.horizontalPadding,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MyText(
                        text: 'Start from',
                        weight: FontWeight.w600,
                        size: 20,
                      ),
                      MyText(
                        text: DateFormat('MM.dd.yyyy')
                            .format(widget.habit.createdTime),
                        weight: FontWeight.w400,
                        size: 17,
                        color: isDarkTheme ? kWhiteColor : kGreyColor,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                Padding(
                  padding: AppSizes.horizontalPadding,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MyText(
                        text: 'Completed',
                        weight: FontWeight.w600,
                        size: 20,
                      ),
                      GetBuilder<HabitsController>(
                        init: habitsController,
                        builder: (controller) => MyText(
                          text: '${widget.habit.habitDates.length} times',
                          weight: FontWeight.w400,
                          size: 17,
                          color: isDarkTheme ? kWhiteColor : kGreyColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                Padding(
                  padding: AppSizes.horizontalPadding,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MyText(
                        text: 'Best series',
                        weight: FontWeight.w600,
                        size: 20,
                      ),
                      GetBuilder<HabitsController>(
                        init: habitsController,
                        builder: (controller) => MyText(
                          text:
                              '${getBestSeries(widget.habit.habitDates)} times',
                          weight: FontWeight.w400,
                          size: 17,
                          color: isDarkTheme ? kWhiteColor : kGreyColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: AppSizes.horizontalPadding,
                  child: Divider(
                    color: Colors.grey.withOpacity(0.5),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: AppSizes.horizontalPadding,
                  child: Row(
                    children: [
                      Expanded(
                        child: MyText(
                          text: 'Notification',
                          weight: FontWeight.w600,
                          size: 20,
                        ),
                      ),
                      Obx(
                        () => CupertinoSwitch(
                          value: habitsController.haveNotification.value,
                          onChanged: (_) {
                            habitsController.haveNotification.value =
                                !habitsController.haveNotification.value;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                if (habitsController.haveNotification.value) ...[
                  const SizedBox(height: 20),
                  Padding(
                    padding: AppSizes.horizontalPadding,
                    child: Row(
                      children: [
                        Expanded(
                          child: MyText(
                            text: 'Time',
                            weight: FontWeight.w500,
                            size: 17,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.bottomSheet(
                              Container(
                                height: Get.height * 0.35,
                                decoration: BoxDecoration(
                                  color: isDarkTheme
                                      ? Colors.grey[850]
                                      : kWhiteColor,
                                  borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(10),
                                    topLeft: Radius.circular(10),
                                  ),
                                ),
                                child: CupertinoTheme(
                                  data: CupertinoThemeData(
                                    textTheme: CupertinoTextThemeData(
                                      pickerTextStyle: TextStyle(
                                        color: isDarkTheme
                                            ? kWhiteColor
                                            : kBlackColor,
                                        fontFamily: AppFonts.Inter,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  child: CupertinoTimerPicker(
                                    mode: CupertinoTimerPickerMode.hm,
                                    onTimerDurationChanged: (value) {
                                      habitsController.selectedTime.value =
                                          formatDurationTo24HourString(value);
                                      log(formatDurationTo24HourString(value));
                                    },
                                  ),
                                ),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 6,
                              horizontal: 12,
                            ),
                            decoration: BoxDecoration(
                              color: isDarkTheme
                                  ? kGreyColor
                                  : kGreyColor.withOpacity(0.25),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Obx(
                              () => MyText(
                                text: habitsController.selectedTime.value,
                                weight: FontWeight.w400,
                                size: 17,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: AppSizes.horizontalPadding,
                    child: MyText(
                      text: 'Repeat',
                      weight: FontWeight.w500,
                      size: 17,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: AppSizes.horizontalPadding,
                    child: SizedBox(
                      height: 50,
                      child: ListView.builder(
                        itemCount: days.length,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: ChoiceChip(
                              showCheckmark: false,
                              onSelected: (value) {
                                days[index]['isSelected'] =
                                    !days[index]['isSelected'];
                                setState(() {});
                              },
                              label: MyText(
                                text: days[index]['day']
                                    .toString()
                                    .substring(0, 3)
                                    .toUpperCase()
                                    .toString(),
                                size: 12,
                                weight: FontWeight.w600,
                              ),
                              selected: days[index]['isSelected'],
                              selectedColor: kGreenColor,
                              disabledColor:
                                  isDarkTheme ? kBlackColor : kWhiteColor,
                              backgroundColor:
                                  isDarkTheme ? kBlackColor : kWhiteColor,
                            ),
                          );
                        },
                      ),
                    ),
                  )
                ],
              ],
            ),
          );
        }),
      ),
    );
  }

  String formatDurationTo24HourString(Duration duration) {
    final hours = duration.inHours.toString().padLeft(2, '0');
    final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    return "$hours:$minutes";
  }

  int getBestSeries(List<DateTime> dates) {
    if (dates.isEmpty) return 0;

    List<DateTime> sortedDates = dates.toSet().toList()
      ..sort((a, b) => a.compareTo(b));

    int longestStreak = 1;
    int currentStreak = 1;

    for (int i = 1; i < sortedDates.length; i++) {
      if (sortedDates[i].difference(sortedDates[i - 1]).inDays == 1) {
        currentStreak++;
        if (currentStreak >= longestStreak) {
          longestStreak = currentStreak;
        }
      } else {
        currentStreak = 1;
      }
    }

    log(longestStreak.toString());

    return longestStreak;
  }

  _onUpdate() async {
    log('updated');
    List<String> repeats = [];
    for (var repeat in days) {
      if (repeat['isSelected']) {
        repeats.add(repeat['day']);
      }
    }
    Habit editedHabbit = Habit(
      habitId: widget.habit.habitId,
      title: habitTitleController.text.trim(),
      description: habitDescriptionController.text.trim(),
      color: widget.habit.color,
      repeatDays: repeats,
      notificationEnabled: habitsController.haveNotification.value,
      time: habitsController.selectedTime.value,
      createdTime: widget.habit.createdTime,
      habitDates: widget.habit.habitDates,
    );
    if (editedHabbit.notificationEnabled) {
      await NotificationService.instance.scheduleRepeatNotifications(
        title: editedHabbit.title,
        body: editedHabbit.description,
        notificationModel: ScheduleNotificationModel(
          notificationId: const Uuid().v4().hashCode.abs(),
          id: editedHabbit.habitId,
        ),
        selectedDays: editedHabbit.repeatDays,
        selectedTime: editedHabbit.time,
      );
    }
    habitsController.updateHabit(habit: editedHabbit);
    setState(() {});
  }
}
