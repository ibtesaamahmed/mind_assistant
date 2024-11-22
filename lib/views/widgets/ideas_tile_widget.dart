import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_quill/quill_delta.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:mind_assistant/config/theme/theme_functions.dart';
import 'package:mind_assistant/constants/app_colors.dart';
import 'package:mind_assistant/constants/app_sizes.dart';
import 'package:mind_assistant/model/ideas_model.dart';
import 'package:mind_assistant/views/screens/ideas/edit_ideas_screen.dart';
import 'package:mind_assistant/views/widgets/my_text_widget.dart';

class IdeasTileWidget extends StatelessWidget {
  IdeasTileWidget({
    required this.idea,
    required this.onDeletTap,
    super.key,
  });
  final IdeasModel idea;
  final VoidCallback onDeletTap;
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Slidable(
        endActionPane: ActionPane(
            extentRatio: 0.3,
            motion: const ScrollMotion(),
            children: [
              Expanded(
                child: InkWell(
                  onTap: onDeletTap,
                  child: Container(
                    margin: const EdgeInsets.only(left: 10, bottom: 20),
                    decoration: BoxDecoration(
                        color: kRedColor,
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Center(
                            child: Icon(
                          Icons.delete,
                          color: kWhiteColor,
                        )),
                        MyText(
                          text: 'Delete',
                          color: kWhiteColor,
                          size: 15,
                          weight: FontWeight.w400,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ]),
        child: GestureDetector(
          onTap: () {
            Get.to(() => EditIdeasScreen(idea: idea));
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: themeController.isDarkTheme.value
                  ? kDPrimaryColor
                  : kWhiteColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: AppSizes.defaultPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  MyText(
                    text: idea.title,
                    color: getTitleFontColor(),
                    weight: FontWeight.w500,
                    size: 21,
                  ),
                  const SizedBox(height: 3),
                  MyText(
                    text: quill.Document.fromDelta(idea.subTitle).toPlainText(),
                    color: getSubTileColor().withOpacity(0.65),
                    weight: FontWeight.w400,
                    size: 17,
                    maxLines: 1,
                    textOverflow: TextOverflow.ellipsis,
                  ),
                  // QuillEditor.basic(
                  //   configurations: const QuillEditorConfigurations(
                  //     autoFocus: false,
                  //   ),
                  //   controller: QuillController(
                  //     document: Document.fromDelta(subTitle),
                  //     selection: const TextSelection.collapsed(offset: 0),
                  //     readOnly: true,
                  //   ),
                  // )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
