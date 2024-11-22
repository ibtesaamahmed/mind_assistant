import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:get/get.dart';
import 'package:mind_assistant/config/theme/theme_functions.dart';
import 'package:mind_assistant/constants/app_colors.dart';
import 'package:mind_assistant/constants/app_fonts.dart';
import 'package:mind_assistant/constants/app_sizes.dart';
import 'package:mind_assistant/constants/global_instances.dart';
import 'package:mind_assistant/model/ideas_model.dart';
import 'package:mind_assistant/utils/snackbars.dart';
import 'package:mind_assistant/views/widgets/custom_textfield_widget.dart';
import 'package:mind_assistant/views/widgets/my_text_widget.dart';

class EditIdeasScreen extends StatefulWidget {
  final IdeasModel idea;
  const EditIdeasScreen({required this.idea, super.key});

  @override
  State<EditIdeasScreen> createState() => EditIdeasScreenState();
}

class EditIdeasScreenState extends State<EditIdeasScreen> {
  final ideaTitleController = TextEditingController();
  final quill.QuillController ideaSubTitleController =
      quill.QuillController.basic();
  @override
  void initState() {
    super.initState();
    ideaTitleController.text = widget.idea.title;
    ideaSubTitleController.document =
        quill.Document.fromDelta(widget.idea.subTitle);
  }

  @override
  void dispose() {
    super.dispose();
    ideaTitleController.dispose();
    ideaSubTitleController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: Get.width * 0.3,
        automaticallyImplyLeading: false,
        title: MyText(
          text: 'Group',
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
              final customSnackbar = CustomSnackBars.instance;
              if (ideaTitleController.text.trim().isEmpty) {
                customSnackbar.showFailureSnackbar(
                    title: 'Missing Field', message: 'Title is required');
              } else {
                final idea = IdeasModel(
                  id: widget.idea.id,
                  title: ideaTitleController.text.trim(),
                  subTitle: ideaSubTitleController.document.toDelta(),
                );
                ideasController.editIdea(idea: idea);
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

            return Column(
              children: [
                CustomTextField(
                  readOnly: false,
                  controller: ideaTitleController,
                  cursorColor: color,
                  hintText: 'Title',
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
                Expanded(
                  child: DefaultTextStyle(
                    style: TextStyle(
                      color: isDarkTheme
                          ? kWhiteColor
                          : kBlackColor, // Text color for the editor
                      fontSize: 17,
                    ),
                    child: quill.QuillEditor.basic(
                      controller: ideaSubTitleController,
                      configurations: const quill.QuillEditorConfigurations(
                        showCursor: true,
                      ),
                    ),
                  ),
                ),
                Obx(() {
                  final color = themeController.isDarkTheme.value
                      ? kWhiteColor
                      : kBlackColor;
                  return Theme(
                    data: Theme.of(context).copyWith(
                      iconTheme: IconThemeData(
                        color: color,
                      ),
                    ),
                    child: quill.QuillSimpleToolbar(
                      controller: ideaSubTitleController,
                      configurations: quill.QuillSimpleToolbarConfigurations(
                        axis: Axis.horizontal,
                        buttonOptions: quill.QuillSimpleToolbarButtonOptions(
                          fontSize: quill.QuillToolbarFontSizeButtonOptions(
                            onSelected: (value) {
                              FocusScope.of(context).unfocus();
                            },
                            afterButtonPressed: () {
                              FocusScope.of(context).unfocus();
                            },
                            style: TextStyle(
                              color: color,
                            ),
                          ),
                          fontFamily: quill.QuillToolbarFontFamilyButtonOptions(
                            onSelected: (value) {
                              FocusScope.of(context).unfocus();
                            },
                            afterButtonPressed: () {
                              FocusScope.of(context).unfocus();
                            },
                            style: TextStyle(
                              color: color,
                            ),
                          ),
                          selectHeaderStyleDropdownButton: quill
                              .QuillToolbarSelectHeaderStyleDropdownButtonOptions(
                            afterButtonPressed: () {
                              FocusScope.of(context).unfocus();
                            },
                            textStyle: TextStyle(
                              color: color,
                            ),
                          ),
                        ),
                        showColorButton: false,
                        showSearchButton: false,
                        showBackgroundColorButton: false,
                        showUndo: false,
                        showRedo: false,
                        showSuperscript: false,
                        showSubscript: false,
                        showLink: false,
                        showClipboardCopy: false,
                        showClipboardCut: false,
                        showClipboardPaste: false,
                        showAlignmentButtons: false,
                        showRightAlignment: false,
                        showLeftAlignment: false,
                        showCenterAlignment: false,
                        showJustifyAlignment: false,
                        showClearFormat: false,
                        showIndent: false,
                        showCodeBlock: false,
                        showDividers: false,
                        showQuote: false,
                        showDirection: false,
                        showLineHeightButton: false,
                        showInlineCode: false,
                        showListCheck: false,
                      ),
                    ),
                  );
                }),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _CustomBorderlessTextField extends StatelessWidget {
  final TextEditingController controller;
  final TextStyle hintTextStyle;
  final TextStyle textStyle;
  final Color cursorColor;
  final String hintText;
  const _CustomBorderlessTextField({
    required this.controller,
    required this.hintTextStyle,
    required this.textStyle,
    required this.cursorColor,
    required this.hintText,
  });
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      cursorColor: cursorColor,
      cursorOpacityAnimates: false,
      style: textStyle,
      showCursor: true,
      maxLines: null,
      expands: true,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: hintTextStyle,
        border: InputBorder.none, // Remove all borders
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        focusedErrorBorder: InputBorder.none,
      ),
      // selectionControls: MyTextSelectionControls(onEdit: () {
      //   _showEditOptions(context);
      // }),
    );
  }

  // void _showEditOptions(BuildContext context) {
  //   showModalBottomSheet(
  //     context: context,
  //     builder: (context) {
  //       return Wrap(
  //         children: [
  //           ListTile(
  //             leading: const Icon(Icons.title),
  //             title: const Text("Heading"),
  //             onTap: () {
  //               _applyTextFormat(TextFormat.heading);
  //               Get.back();
  //             },
  //           ),
  //           ListTile(
  //             leading: const Icon(Icons.format_list_bulleted),
  //             title: const Text("Bullet Points"),
  //             onTap: () {
  //               _applyTextFormat(TextFormat.bullet);
  //               Get.back();
  //             },
  //           ),
  //           ListTile(
  //             leading: const Icon(Icons.strikethrough_s),
  //             title: const Text("Strikethrough"),
  //             onTap: () {
  //               _applyTextFormat(TextFormat.strikethrough);
  //               Get.back();
  //             },
  //           ),
  //           // Add more options if needed
  //         ],
  //       );
  //     },
  //   );
  // }

  // void _applyTextFormat(TextFormat format) {
  //   final text = ideasController.ideaSubTitleController.text;
  //   final selection = ideasController.ideaSubTitleController.selection;

  //   if (selection.isCollapsed) {
  //     // If no text is selected, we don’t apply any format
  //     print("No text selected");
  //     return;
  //   }

  //   final selectedText = text.substring(selection.start, selection.end);
  //   String newText;

  //   switch (format) {
  //     case TextFormat.heading:
  //       // Simulate heading by making text uppercase
  //       newText = selectedText.toUpperCase();
  //       break;

  //     case TextFormat.bullet:
  //       // Add bullet points at the beginning of each line in the selection
  //       newText = selectedText
  //           .split('\n')
  //           .map((line) => '• $line') // Adding bullet before each line
  //           .join('\n');
  //       break;

  //     case TextFormat.strikethrough:
  //       // Simulate strikethrough by surrounding text with '~' symbols
  //       newText = '~$selectedText~';
  //       break;

  //     default:
  //       newText = selectedText;
  //   }

  //   // Replace the selected text with the formatted text
  //   ideasController.ideaSubTitleController.value = TextEditingValue(
  //     text: text.replaceRange(selection.start, selection.end, newText),
  //     selection:
  //         TextSelection.collapsed(offset: selection.start + newText.length),
  //   );
  // }
}



                // Expanded(
                //   child: _CustomBorderlessTextField(
                //     controller: ideasController.ideaSubTitleController,
                //     hintTextStyle: TextStyle(
                //       fontWeight: FontWeight.w400,
                //       fontSize: 17,
                //       color: isDarkTheme
                //           ? kWhiteColor.withOpacity(0.65)
                //           : kGreyColor,
                //       fontFamily: AppFonts.Inter,
                //     ),
                //     textStyle: TextStyle(
                //       fontWeight: FontWeight.w400,
                //       fontSize: 17,
                //       color: isDarkTheme ? kWhiteColor : kBlackColor,
                //       fontFamily: AppFonts.Inter,
                //     ),
                //     cursorColor: kBlueColor,
                //     hintText: '',
                //   ),
                // )