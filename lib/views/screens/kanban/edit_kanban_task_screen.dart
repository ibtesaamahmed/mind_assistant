import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:get/get.dart';
import 'package:mind_assistant/config/enums/tasks_status.dart';
import 'package:mind_assistant/config/theme/theme_functions.dart';
import 'package:mind_assistant/constants/app_colors.dart';
import 'package:mind_assistant/constants/app_fonts.dart';
import 'package:mind_assistant/constants/app_sizes.dart';
import 'package:mind_assistant/constants/global_instances.dart';
import 'package:mind_assistant/model/tasks_model.dart';
import 'package:mind_assistant/utils/snackbars.dart';
import 'package:mind_assistant/views/widgets/custom_textfield_widget.dart';
import 'package:mind_assistant/views/widgets/my_text_widget.dart';
import 'package:uuid/uuid.dart';

class EditKanbanTaskScreen extends StatefulWidget {
  final TasksModel task;
  const EditKanbanTaskScreen({required this.task, super.key});

  @override
  State<EditKanbanTaskScreen> createState() => _EditKanbanTaskScreenState();
}

class _EditKanbanTaskScreenState extends State<EditKanbanTaskScreen> {
  final taskTitleController = TextEditingController();
  final quill.QuillController taskSubTitleController =
      quill.QuillController.basic();

  @override
  void initState() {
    super.initState();
    taskTitleController.text = widget.task.title;
    taskSubTitleController.document =
        quill.Document.fromDelta(widget.task.subTitle);
  }

  @override
  void dispose() {
    super.dispose();
    taskTitleController.dispose();
    taskSubTitleController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: Get.width * 0.3,
        automaticallyImplyLeading: false,
        title: MyText(
          text: 'Task',
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
              if (taskTitleController.text.trim().isEmpty) {
                customSnackbar.showFailureSnackbar(
                    title: 'Missing Field', message: 'Title is required');
              } else {
                final task = TasksModel(
                  id: widget.task.id,
                  title: taskTitleController.text.trim(),
                  subTitle: taskSubTitleController.document.toDelta(),
                  lastEdited: DateTime.now(),
                  status: widget.task.status,
                );
                kanbanController.addEditTask(task: task);
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
                  controller: taskTitleController,
                  cursorColor: color,
                  hintText: 'Task Title',
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
                      controller: taskSubTitleController,
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
                      controller: taskSubTitleController,
                      configurations: quill.QuillSimpleToolbarConfigurations(
                        customButtons: [],
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
}
