import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:mind_assistant/config/theme/theme_functions.dart';
import 'package:mind_assistant/constants/app_colors.dart';
import 'package:mind_assistant/constants/app_images.dart';
import 'package:mind_assistant/constants/app_sizes.dart';
import 'package:mind_assistant/views/widgets/my_text_widget.dart';
import 'package:permission_handler/permission_handler.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  RxBool isNotification = true.obs;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: getAppBarBackgroundColor(),
        automaticallyImplyLeading: false,
        title: MyText(
          text: 'Settings',
          size: 17,
          weight: FontWeight.w600,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: AppSizes.defaultPadding,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Obx(
                    () => Icon(
                      Icons.wb_sunny_sharp,
                      color: themeController.isDarkTheme.value
                          ? kWhiteColor
                          : kBlackColor,
                      size: 25,
                    ),
                  ),
                  Expanded(
                    child: MyText(
                      text: 'Dark Theme',
                      weight: FontWeight.w600,
                      size: 21,
                      paddingLeft: 5,
                    ),
                  ),
                  Obx(
                    () => CupertinoSwitch(
                      value: themeController.isDarkTheme.value,
                      onChanged: (val) {
                        themeController.onToggle();
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Divider(
                color: Colors.grey.withOpacity(0.5),
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Obx(
                    () => Icon(
                      Icons.notifications_sharp,
                      color: themeController.isDarkTheme.value
                          ? kWhiteColor
                          : kBlackColor,
                      size: 25,
                    ),
                  ),
                  Expanded(
                    child: MyText(
                      text: 'Notifications',
                      weight: FontWeight.w600,
                      paddingLeft: 5,
                      size: 21,
                    ),
                  ),
                  Obx(
                    () => CupertinoSwitch(
                      value: isNotification.value,
                      onChanged: (val) {
                        isNotification.value = !isNotification.value;
                        if (isNotification.value) {
                          Permission.notification.request();
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Divider(
                color: Colors.grey.withOpacity(0.5),
              ),
              const SizedBox(height: 20),
              MyText(
                text: 'Description',
                weight: FontWeight.w600,
                size: 21,
              ),
              const SizedBox(height: 18),
              const _DescriptionTile(
                imagePath: Assets.imagesIdeasBig,
                title: 'Ideas',
                body:
                    'Create lists, keep notes, or just jot down ideas on different topics so you don\'t lose track of them in your head.',
              ),
              const SizedBox(height: 20),
              const _DescriptionTile(
                imagePath: Assets.imagesHabitsBig,
                title: 'Habits',
                body:
                    'Introduce habits into your life and note their implementation by day. Analyze the implementation of the habit by month and set reminders to make the habit stick in your mind.',
              ),
              const SizedBox(height: 20),
              const _DescriptionTile(
                imagePath: Assets.imagesKanbanBig,
                title: 'Kanban',
                body:
                    'Create the tasks you want to accomplish and progress them as you complete them. This will help you see how many tasks you have to complete, how many are in the works, how many you have completed, and help you distribute your workload wisely.',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DescriptionTile extends StatelessWidget {
  const _DescriptionTile({
    required this.imagePath,
    required this.title,
    required this.body,
  });
  final String imagePath;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(
          () => Image.asset(
            imagePath,
            height: 43,
            width: 35,
            color:
                themeController.isDarkTheme.value ? kWhiteColor : kBlackColor,
            scale: 1 / 3,
          ),
        ),
        const SizedBox(width: 15),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              MyText(
                text: title,
                weight: FontWeight.w600,
                size: 17,
              ),
              const SizedBox(height: 5),
              Obx(
                () => MyText(
                  text: body,
                  weight: FontWeight.w400,
                  size: 17,
                  color: themeController.isDarkTheme.value
                      ? kWhiteColor.withOpacity(0.5)
                      : kSecondaryColor,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
