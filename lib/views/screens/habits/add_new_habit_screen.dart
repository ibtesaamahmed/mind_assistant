import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mind_assistant/config/theme/theme_functions.dart';
import 'package:mind_assistant/constants/app_colors.dart';
import 'package:mind_assistant/constants/app_fonts.dart';
import 'package:mind_assistant/constants/app_sizes.dart';
import 'package:mind_assistant/constants/global_instances.dart';
import 'package:mind_assistant/model/habit_model.dart';
import 'package:mind_assistant/model/schedule_notification_model.dart';
import 'package:mind_assistant/services/local%20storage/local_storage_service.dart';
import 'package:mind_assistant/services/notification/notification_service.dart';
import 'package:mind_assistant/utils/snackbars.dart';
import 'package:mind_assistant/views/widgets/custom_textfield_widget.dart';
import 'package:mind_assistant/views/widgets/my_text_widget.dart';
import 'package:uuid/uuid.dart';

class AddNewHabitScreen extends StatefulWidget {
  const AddNewHabitScreen({super.key});

  @override
  State<AddNewHabitScreen> createState() => _AddNewHabitScreenState();
}

class _AddNewHabitScreenState extends State<AddNewHabitScreen> {
  final habitTitleController = TextEditingController();
  final habitDescriptionController = TextEditingController();

  List<Map<String, dynamic>> colors = [];
  List<Map<String, dynamic>> days = [];
  @override
  void initState() {
    super.initState();
    colors = [
      {
        'color': const Color(0xFFEE4747),
        'isSelected': false,
      },
      {
        'color': const Color.fromARGB(238, 110, 71, 1),
        'isSelected': false,
      },
      {
        'color': const Color.fromRGBO(238, 174, 71, 1),
        'isSelected': false,
      },
      {
        'color': const Color.fromRGBO(238, 232, 71, 1),
        'isSelected': false,
      },
      {
        'color': const Color.fromRGBO(144, 238, 71, 1),
        'isSelected': false,
      },
      {
        'color': const Color.fromRGBO(71, 238, 116, 1),
        'isSelected': false,
      },
      {
        'color': const Color.fromRGBO(71, 238, 205, 1),
        'isSelected': false,
      },
      {
        'color': const Color.fromRGBO(71, 238, 238, 1),
        'isSelected': false,
      },
      {
        'color': const Color.fromRGBO(61, 186, 232, 1),
        'isSelected': false,
      },
      {
        'color': const Color.fromRGBO(71, 80, 238, 1),
        'isSelected': false,
      },
      {
        'color': const Color.fromRGBO(177, 71, 238, 1),
        'isSelected': false,
      },
      {
        'color': const Color.fromRGBO(238, 71, 152, 1),
        'isSelected': false,
      },
    ];
    days = [
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
  }

  @override
  void dispose() {
    super.dispose();
    habitTitleController.dispose();
    habitDescriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: Get.width * 0.3,
        automaticallyImplyLeading: false,
        title: MyText(
          text: 'New Habit',
          size: 17,
          weight: FontWeight.w600,
        ),
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Row(
            children: [
              const Icon(
                Icons.arrow_back_ios_new,
                color: kBlueColor,
              ),
              MyText(
                text: 'Cancel',
                color: kBlueColor,
                weight: FontWeight.w400,
                size: 17,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              final customSnackbars = CustomSnackBars.instance;
              bool isColorSelected = colors.any((color) => color['isSelected']);
              bool isDaySelected = days.any((day) => day['isSelected']);

              if (habitTitleController.text.trim().isEmpty) {
                customSnackbars.showFailureSnackbar(
                    title: 'Error', message: 'Habit title is required');
              } else if (habitDescriptionController.text.trim().isEmpty) {
                customSnackbars.showFailureSnackbar(
                    title: 'Error', message: 'Habit description is required');
              } else if (!isColorSelected) {
                customSnackbars.showFailureSnackbar(
                    title: 'Error', message: 'Kindly select a color');
              } else if (habitsController.haveNotification.value &&
                  !isDaySelected) {
                customSnackbars.showFailureSnackbar(
                    title: 'Error',
                    message: 'Kindly select at least one day for repeat');
              } else {
                List<String> selectedDays = [];
                for (var day in days) {
                  if (day['isSelected']) {
                    selectedDays.add(day['day']);
                  }
                }
                final habit = Habit(
                  habitId: const Uuid().v4(),
                  title: habitTitleController.text.trim(),
                  description: habitDescriptionController.text.trim(),
                  color: colors.firstWhere(
                    (color) => color['isSelected'],
                  )['color'],
                  repeatDays: selectedDays,
                  notificationEnabled: habitsController.haveNotification.value,
                  time: habitsController.selectedTime.value,
                  createdTime: DateTime.now(),
                  habitDates: [],
                );
                if (habit.notificationEnabled) {
                  final noti = ScheduleNotificationModel(
                    notificationId: const Uuid().v4().hashCode.abs(),
                    id: habit.habitId,
                  );
                  await NotificationService.instance
                      .scheduleRepeatNotifications(
                    title: habit.title,
                    body: habit.description,
                    notificationModel: noti,
                    selectedDays: habit.repeatDays,
                    selectedTime: habit.time,
                  );
                }
                habitsController.addHabit(habit: habit);
                Get.back();
              }
            },
            child: MyText(
              text: 'Save',
              color: kBlueColor,
              weight: FontWeight.w400,
              size: 17,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: AppSizes.defaultPadding,
        child: Obx(() {
          final isDarkTheme = themeController.isDarkTheme.value;
          final color = isDarkTheme ? kWhiteColor : kBlackColor;
          return ListView(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            children: [
              CustomTextField(
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
              const SizedBox(height: 10),
              CustomTextField(
                maxLines: 3,
                readOnly: false,
                controller: habitDescriptionController,
                hintTextStyle: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 17,
                  color:
                      isDarkTheme ? kWhiteColor.withOpacity(0.65) : kGreyColor,
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
              const SizedBox(height: 10),
              MyText(
                text: 'Color',
                weight: FontWeight.w600,
                size: 20,
              ),
              const SizedBox(height: 10),
              GridView.builder(
                itemCount: colors.length,
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 6,
                ),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      colors[index]['isSelected'] =
                          !colors[index]['isSelected'];
                      if (colors[index]['isSelected']) {
                        for (int i = 0; i < colors.length; i++) {
                          if (i == index) {
                            continue;
                          } else {
                            colors[i]['isSelected'] = false;
                          }
                        }
                      }
                      setState(() {});
                    },
                    child: Stack(
                      children: [
                        Container(
                          margin: const EdgeInsets.all(10),
                          height: 43,
                          width: 43,
                          decoration: BoxDecoration(
                            color: colors[index]['color'],
                            shape: BoxShape.circle,
                          ),
                        ),
                        if (colors[index]['isSelected'])
                          Align(
                            alignment: Alignment.center,
                            child: Container(
                              height: 18,
                              width: 18,
                              decoration: const BoxDecoration(
                                color: kWhiteColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 10),
              Row(
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
              if (habitsController.haveNotification.value) ...[
                const SizedBox(height: 20),
                Row(
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
                              color:
                                  isDarkTheme ? Colors.grey[850] : kWhiteColor,
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(10),
                                topLeft: Radius.circular(10),
                              ),
                            ),
                            child: CupertinoTheme(
                              data: CupertinoThemeData(
                                textTheme: CupertinoTextThemeData(
                                  pickerTextStyle: TextStyle(
                                    color:
                                        isDarkTheme ? kWhiteColor : kBlackColor,
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
                const SizedBox(height: 20),
                MyText(
                  text: 'Repeat',
                  weight: FontWeight.w500,
                  size: 17,
                ),
                const SizedBox(height: 10),
                SizedBox(
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
                )
              ]
            ],
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
}
