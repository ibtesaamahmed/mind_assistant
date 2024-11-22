import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mind_assistant/config/theme/theme_functions.dart';
import 'package:mind_assistant/constants/app_colors.dart';
import 'package:mind_assistant/constants/app_images.dart';
import 'package:mind_assistant/constants/app_sizes.dart';
import 'package:mind_assistant/constants/global_instances.dart';
import 'package:mind_assistant/views/screens/ideas/add_new_idea_screen.dart';
import 'package:mind_assistant/views/widgets/common_image_widget.dart';
import 'package:mind_assistant/views/widgets/ideas_tile_widget.dart';
import 'package:mind_assistant/views/widgets/my_text_widget.dart';

class IdeasScreen extends StatelessWidget {
  IdeasScreen({super.key});
  bool isEmptyState = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: MyText(
            text: 'Ideas',
            size: 17,
            weight: FontWeight.w600,
          ),
          centerTitle: true,
          actions: [
            TextButton(
              onPressed: () {
                // isEmptyState = !isEmptyState;
                Get.to(
                  () => const AddNewIdeaScreen(),
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
        body: isEmptyState
            ? _emptyState()
            : Padding(
                padding: AppSizes.defaultPadding,
                child: Obx(
                  () => ideasController.ideas.isEmpty
                      ? _emptyState()
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          itemCount: ideasController.ideas.length,
                          itemBuilder: (context, index) => IdeasTileWidget(
                            idea: ideasController.ideas[index],
                            onDeletTap: () {
                              ideasController.removeIdeas(index: index);
                            },
                          ),
                        ),
                ),
              ));
  }

  Widget _emptyState() => Padding(
        padding: AppSizes.defaultPadding,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                Assets.imagesIdeasBig,
                // fit: BoxFit.cover,
                height: 103,
                width: 85,
                scale: 1 / 3,
              ),
              const SizedBox(height: 20),
              Obx(
                () => MyText(
                  text: 'Create the folder for your ideas',
                  size: 20,
                  textAlign: TextAlign.center,
                  weight: FontWeight.w600,
                  color: themeController.isDarkTheme.value
                      ? kWhiteColor.withOpacity(0.5)
                      : kGreyColor,
                ),
              )
            ],
          ),
        ),
      );
}
