import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mind_assistant/config/theme/theme_functions.dart';
import 'package:mind_assistant/constants/app_colors.dart';
import 'package:mind_assistant/constants/app_images.dart';
import 'package:mind_assistant/constants/app_sizes.dart';
import 'package:mind_assistant/constants/global_instances.dart';
import 'package:mind_assistant/controller/backlog_controller.dart';
import 'package:mind_assistant/views/screens/backlog/add_new_backlog_screen.dart';
import 'package:mind_assistant/views/screens/backlog/add_new_list_screen.dart';
import 'package:mind_assistant/views/widgets/backlogs_tile_widget.dart';
import 'package:mind_assistant/views/widgets/my_text_widget.dart';

class BacklogScreen extends StatefulWidget {
  const BacklogScreen({super.key});

  @override
  State<BacklogScreen> createState() => _BacklogScreenState();
}

class _BacklogScreenState extends State<BacklogScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero).then(
      (_) async {
        await backlogController.autoDelete();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: MyText(
          text: 'Backlogs',
          size: 17,
          weight: FontWeight.w600,
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              backlogController.listTitleController.clear();
              Get.to(
                () => const AddNewListScreen(),
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
      body: Obx(
        () => backlogController.backLogs.isEmpty
            ? _emptyState()
            : GetBuilder<BacklogController>(
                init: backlogController,
                builder: (controller) {
                  if (backlogController.backLogs.isEmpty) {
                    return _emptyState();
                  } else {
                    return Padding(
                      padding: AppSizes.defaultPadding,
                      child: ListView.builder(
                        itemCount: backlogController.backLogs.length,
                        itemBuilder: (context, index) => BacklogsTileWidget(
                          backlog: backlogController.backLogs[index],
                          onAddBacklogTap: () {
                            Get.to(
                              () => AddNewBacklogScreen(
                                  listTitleText:
                                      backlogController.backLogs[index].title,
                                  index: index),
                              transition: Transition.rightToLeft,
                            );
                          },
                        ),
                      ),
                    );
                  }
                },
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
                Assets.imagesBacklogBig,
                // fit: BoxFit.cover,
                height: 103,
                width: 85,
                scale: 1 / 3,
              ),
              const SizedBox(height: 20),
              Obx(
                () => MyText(
                  text:
                      'Create a list of things you plan to do, watch or try in the future so you don\'t forget about it. Some things will probably lose relevance, so don\'t forget to clean up your backlog',
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
