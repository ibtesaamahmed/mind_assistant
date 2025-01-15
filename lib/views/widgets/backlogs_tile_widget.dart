import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:mind_assistant/config/theme/theme_functions.dart';
import 'package:mind_assistant/constants/app_colors.dart';
import 'package:mind_assistant/constants/app_sizes.dart';
import 'package:mind_assistant/constants/global_instances.dart';
import 'package:mind_assistant/model/backlog_model.dart';
import 'package:mind_assistant/views/screens/backlog/edit_backlog_screen.dart';
import 'package:mind_assistant/views/widgets/my_text_widget.dart';

class BacklogsTileWidget extends StatelessWidget {
  const BacklogsTileWidget({
    required this.backlog,
    required this.onAddBacklogTap,
    super.key,
  });
  final BacklogModel backlog;
  final VoidCallback onAddBacklogTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Slidable(
          endActionPane: ActionPane(
            extentRatio: 2 / 8,
            motion: const ScrollMotion(),
            children: [
              SlidableAction(
                onPressed: (_) {
                  backlogController.deleteBacklog(id: backlog.id);
                },
                backgroundColor: kRedColor,
                icon: Icons.delete,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MyText(
                text: backlog.title,
                weight: FontWeight.w500,
                size: 21,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: ElevatedButton(
                  onPressed: onAddBacklogTap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kBlueColor,
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.add_circle,
                        color: kWhiteColor,
                      ),
                      MyText(
                        text: 'Backlog',
                        color: kWhiteColor,
                        weight: FontWeight.w400,
                        paddingLeft: 4,
                        size: 15,
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        const SizedBox(height: 15),
        Divider(
          color: Colors.grey.withOpacity(0.5),
        ),
        SingleChildScrollView(
          child: ListView.builder(
            itemCount: backlog.backlogItems.length,
            shrinkWrap: true,
            physics:
                const NeverScrollableScrollPhysics(), // Prevent inner ListView from scrolling
            itemBuilder: (context, index) => BacklogItemTile(
              backlogItem: backlog.backlogItems[index],
              backlogId: backlog.id,
            ),
          ),
        ),
      ],
    );
  }
}

class BacklogItemTile extends StatelessWidget {
  const BacklogItemTile(
      {required this.backlogItem, required this.backlogId, super.key});
  final String backlogId;
  final BacklogItemModel backlogItem;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSizes.verticalPadding,
      child: GestureDetector(
        onTap: () {
          Get.to(
            () => EditBacklogScreen(
              backlogItem: backlogItem,
              index: backlogController.backLogs.indexWhere(
                (element) => element.id == backlogId,
              ),
            ),
          );
        },
        child: Slidable(
          endActionPane: ActionPane(
            extentRatio: 2 / 8,
            motion: const ScrollMotion(),
            children: [
              SlidableAction(
                onPressed: (context) {
                  backlogController.deleteBacklogItem(
                      backlogIndex: backlogController.backLogs.indexWhere(
                        (element) => element.id == backlogId,
                      ),
                      backlogItem: backlogItem);
                },
                backgroundColor: kRedColor,
                icon: Icons.delete,
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 3),
                height: 20,
                width: 20,
                decoration: BoxDecoration(
                  color:
                      !backlogItem.isAutoDelete || backlogItem.endDate == null
                          ? kGreenColor
                          : daysLeft(backlogItem.endDate!) <= 30
                              ? kRedColor
                              : daysLeft(backlogItem.endDate!) > 30
                                  ? kYellowColor
                                  : kGreenColor,
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyText(
                      text: backlogItem.title,
                      weight: FontWeight.w500,
                      size: 17,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        MyText(
                          // text: backlogItem.subTitle,
                          text:
                              'Lasts: ${DateTime.now().difference(backlogItem.createdAt).inDays}',
                          weight: FontWeight.w400,
                          size: 17,
                          color: themeController.isDarkTheme.value
                              ? kWhiteColor.withOpacity(0.5)
                              : kGreyColor,
                        ),
                        backlogItem.endDate != null
                            ? MyText(
                                text:
                                    '${daysLeft(backlogItem.endDate!)} days left',
                                color: kRedColor,
                                weight: FontWeight.w500,
                                size: 12,
                                paddingRight: 10,
                              )
                            : const SizedBox.shrink(),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
