import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mind_assistant/config/theme/theme_functions.dart';
import 'package:mind_assistant/constants/app_colors.dart';
import 'package:mind_assistant/constants/app_fonts.dart';
import 'package:mind_assistant/constants/app_images.dart';
import 'package:mind_assistant/views/screens/backlog/backlog_screen.dart';
import 'package:mind_assistant/views/screens/habits/habits_screen.dart';
import 'package:mind_assistant/views/screens/ideas/ideas_screen.dart';
import 'package:mind_assistant/views/screens/kanban/kanban_screen.dart';
import 'package:mind_assistant/views/screens/settings/settings_screen.dart';
import 'package:mind_assistant/views/widgets/common_image_widget.dart';

// ignore: must_be_immutable
class BottomNavBarWidget extends StatefulWidget {
  int index;
  BottomNavBarWidget({super.key, this.index = 0});

  @override
  State<BottomNavBarWidget> createState() => _BottomNavBarWidgetState();
}

class _BottomNavBarWidgetState extends State<BottomNavBarWidget> {
  List<Widget> screensWidgetsList = <Widget>[
    IdeasScreen(),
    BacklogScreen(),
    KanbanScreen(),
    HabitsScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: getAppBarBackgroundColor(),
      //   automaticallyImplyLeading: false,
      //   title: MyText(
      //     text: 'Ideas',
      //     size: 17,
      //     color: getTitleFontColor(),
      //     weight: FontWeight.w600,
      //   ),
      //   centerTitle: true,
      //   actions: [
      //     TextButton(
      //       onPressed: () {},
      //       child: MyText(
      //         text: '+Add',
      //         color: kBlueColor,
      //       ),
      //     ),
      //   ],
      // ),
      body: screensWidgetsList[widget.index],
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          elevation: 2,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          enableFeedback: true,
          selectedItemColor: kGreenColor,
          selectedLabelStyle: const TextStyle(
            fontFamily: AppFonts.Inter,
            color: kGreenColor,
          ),
          unselectedLabelStyle: TextStyle(
              color: themeController.isDarkTheme.value
                  ? kWhiteColor.withOpacity(0.5)
                  : kGreyColor),
          unselectedItemColor: themeController.isDarkTheme.value
              ? kWhiteColor.withOpacity(0.5)
              : kGreyColor,
          backgroundColor: themeController.isDarkTheme.value
              ? kDPrimaryColor
              : kPrimaryColor,
          type: BottomNavigationBarType.fixed,
          onTap: (value) {
            widget.index = value;
            setState(() {});
          },
          currentIndex: widget.index,
          items: [
            BottomNavigationBarItem(
              icon: CommonImageView(
                imageColor: (widget.index == 0)
                    ? kGreenColor
                    : themeController.isDarkTheme.value
                        ? kWhiteColor.withOpacity(0.5)
                        : kGreyColor,
                imagePath: Assets.imagesIdea,
                height: 20,
                width: 20,
                fit: BoxFit.contain,
              ),
              label: 'Ideas',
            ),
            BottomNavigationBarItem(
              icon: CommonImageView(
                imageColor: (widget.index == 1)
                    ? kGreenColor
                    : themeController.isDarkTheme.value
                        ? kWhiteColor.withOpacity(0.5)
                        : kGreyColor,
                imagePath: Assets.imagesBacklog,
                height: 20,
                width: 20,
                fit: BoxFit.contain,
              ),
              label: 'Backlog',
            ),
            BottomNavigationBarItem(
              icon: CommonImageView(
                imageColor: (widget.index == 2)
                    ? kGreenColor
                    : themeController.isDarkTheme.value
                        ? kWhiteColor.withOpacity(0.5)
                        : kGreyColor,
                imagePath: Assets.imagesKanban,
                height: 20,
                width: 20,
                fit: BoxFit.contain,
              ),
              label: 'Kanban',
            ),
            BottomNavigationBarItem(
              icon: CommonImageView(
                imageColor: (widget.index == 3)
                    ? kGreenColor
                    : themeController.isDarkTheme.value
                        ? kWhiteColor.withOpacity(0.5)
                        : kGreyColor,
                imagePath: Assets.imagesHabits,
                height: 20,
                width: 20,
                fit: BoxFit.contain,
              ),
              label: 'Habits',
            ),
            BottomNavigationBarItem(
              icon: CommonImageView(
                imageColor: (widget.index == 4)
                    ? kGreenColor
                    : themeController.isDarkTheme.value
                        ? kWhiteColor.withOpacity(0.5)
                        : kGreyColor,
                imagePath: Assets.imagesSettings,
                height: 20,
                width: 20,
                fit: BoxFit.contain,
              ),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}
