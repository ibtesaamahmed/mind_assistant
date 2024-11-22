import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mind_assistant/config/theme/theme_functions.dart';
import 'package:mind_assistant/constants/app_colors.dart';
import 'package:mind_assistant/constants/app_fonts.dart';
import 'package:mind_assistant/constants/app_sizes.dart';
import 'package:mind_assistant/constants/global_instances.dart';
import 'package:mind_assistant/model/backlog_model.dart';
import 'package:mind_assistant/views/widgets/custom_textfield_widget.dart';
import 'package:mind_assistant/views/widgets/my_text_widget.dart';
import 'package:uuid/uuid.dart';

class AddNewListScreen extends StatelessWidget {
  const AddNewListScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: Get.width * 0.3,
        automaticallyImplyLeading: false,
        title: MyText(
          text: 'New List',
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
            onPressed: () {
              if (backlogController.listTitleController.text.isNotEmpty) {
                final backlog = BacklogModel(
                    id: const Uuid().v4(),
                    title: backlogController.listTitleController.text,
                    backlogItems: []);
                backlogController.addBacklogList(backlog: backlog);
                Get.back();
              } else {
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
        child: Obx(
          () {
            final isDarkTheme = themeController.isDarkTheme.value;
            final color = isDarkTheme ? kWhiteColor : kBlackColor;

            return CustomTextField(
              readOnly: false,
              controller: backlogController.listTitleController,
              cursorColor: color,
              hintText: 'Backlog List Title',
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
            );
          },
        ),
      ),
    );
  }
}
