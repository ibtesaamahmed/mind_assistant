import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mind_assistant/config/theme/theme_functions.dart';
import 'package:mind_assistant/constants/app_colors.dart';
import 'package:mind_assistant/constants/app_fonts.dart';
import 'package:mind_assistant/constants/app_sizes.dart';
import 'package:mind_assistant/constants/global_instances.dart';
import 'package:mind_assistant/model/backlog_model.dart';
import 'package:mind_assistant/services/notification/notification_service.dart';
import 'package:mind_assistant/utils/snackbars.dart';
import 'package:mind_assistant/views/widgets/custom_textfield_widget.dart';
import 'package:mind_assistant/views/widgets/my_text_widget.dart';
import 'package:uuid/uuid.dart';

class AddNewBacklogScreen extends StatefulWidget {
  AddNewBacklogScreen({
    required this.listTitleText,
    required this.index,
    super.key,
  });
  final String listTitleText;
  final int index;

  @override
  State<AddNewBacklogScreen> createState() => _AddNewBacklogScreenState();
}

class _AddNewBacklogScreenState extends State<AddNewBacklogScreen> {
  final backlogTitleController = TextEditingController();

  final backlogSubTitleController = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    backlogTitleController.dispose();
    backlogSubTitleController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    backlogController.listTitleController.text = widget.listTitleText;
    return Scaffold(
      appBar: AppBar(
        leadingWidth: Get.width * 0.3,
        automaticallyImplyLeading: false,
        title: MyText(
          text: 'New Backlog',
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
              if (backlogTitleController.text.trim().isEmpty ||
                  backlogSubTitleController.text.trim().isEmpty) {
                CustomSnackBars.instance.showFailureSnackbar(
                  title: 'Missing Fields',
                  message: 'Kindly fill all fields',
                );
                return;
              } else if (backlogController.isAutoDelete.value) {
                final backlogItem = BacklogItemModel(
                  id: const Uuid().v4(),
                  title: backlogTitleController.text.trim(),
                  subTitle: backlogSubTitleController.text.trim(),
                  isAutoDelete: backlogController.isAutoDelete.value,
                  endDate: backlogController.endDate.value,
                  createdAt: DateTime.now(),
                );
                backlogController.addBacklogItem(
                    index: widget.index, backlogItem: backlogItem);
                await NotificationService.instance
                    .scheduleBacklogNotificationBefore(backlogItem.endDate!);
                backlogTitleController.clear();
                backlogSubTitleController.clear();
                backlogController.isAutoDelete.value = false;
                backlogController.endDate.value = DateTime.now();
                Get.back();
              } else {
                final backlogItem = BacklogItemModel(
                  id: const Uuid().v4(),
                  title: backlogTitleController.text.trim(),
                  subTitle: backlogSubTitleController.text.trim(),
                  isAutoDelete: backlogController.isAutoDelete.value,
                  createdAt: DateTime.now(),
                );
                backlogController.addBacklogItem(
                    index: widget.index, backlogItem: backlogItem);
                backlogTitleController.clear();
                backlogSubTitleController.clear();
                backlogController.isAutoDelete.value = false;
                backlogController.endDate.value = DateTime.now();
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

            return ListView(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              children: [
                CustomTextField(
                  readOnly: true,
                  controller: backlogController.listTitleController,
                  cursorColor: color,
                  hintText: '',
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
                const SizedBox(height: 15),
                Row(
                  children: [
                    MyText(
                      text: 'Who',
                      weight: FontWeight.w400,
                      size: 17,
                      color: isDarkTheme ? kWhiteColor : kBlackColor,
                    ),
                    const SizedBox(width: 25),
                    Flexible(
                      child: CustomBorderlessTextField(
                        controller: backlogTitleController,
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
                        hintText: 'Name',
                      ),
                    ),
                  ],
                ),
                Divider(
                  color: kGreyColor,
                ),
                Row(
                  children: [
                    MyText(
                      text: 'Why',
                      weight: FontWeight.w400,
                      size: 17,
                      color: isDarkTheme ? kWhiteColor : kBlackColor,
                    ),
                    const SizedBox(width: 25),
                    Flexible(
                      child: CustomBorderlessTextField(
                        controller: backlogSubTitleController,
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
                        hintText: 'Reason',
                      ),
                    ),
                  ],
                ),
                Divider(
                  color: kGreyColor,
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: MyText(
                        text: 'Auto delete',
                        weight: FontWeight.w600,
                        size: 20,
                      ),
                    ),
                    Obx(
                      () => CupertinoSwitch(
                        value: backlogController.isAutoDelete.value,
                        onChanged: (val) {
                          backlogController.isAutoDelete.value =
                              !backlogController.isAutoDelete.value;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Obx(() {
                  final leftDays = daysLeft(backlogController.endDate.value);
                  final selectedDate = backlogController.endDate.value;
                  return backlogController.isAutoDelete.value
                      ? Row(
                          children: [
                            Expanded(
                              child: MyText(
                                text: 'Ends',
                                size: 17,
                                weight: FontWeight.w500,
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: const Color.fromRGBO(
                                        120, 120, 128, 0.12),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: MyText(
                                    paddingTop: 6,
                                    paddingBottom: 6,
                                    paddingLeft: 11,
                                    paddingRight: 11,
                                    color: kBlueColor,
                                    text: formatDateTime(selectedDate),
                                    onTap: () async {
                                      await openFutureDatePicker(context);
                                    },
                                  ),
                                ),
                                const SizedBox(height: 8),
                                MyText(
                                  text: '$leftDays days left',
                                  color: kRedColor,
                                  weight: FontWeight.w500,
                                  size: 12,
                                )
                              ],
                            )
                          ],
                        )
                      : const SizedBox.shrink();
                }),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> openFutureDatePicker(BuildContext context) async {
    DateTime now = DateTime.now();

    await showModalBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        return Container(
          height: 250,
          color: Colors.white,
          child: CupertinoDatePicker(
            initialDateTime: now,
            minimumDate: now,
            maximumYear: DateTime.now().add(const Duration(days: 365 * 5)).year,
            mode: CupertinoDatePickerMode.date,
            onDateTimeChanged: (DateTime date) {
              backlogController.endDate.value = date;
            },
          ),
        );
      },
    );

    // if (selectedDate != null) {
    //   backlogController.endDate.value = selectedDate!;
    // }
  }
}
