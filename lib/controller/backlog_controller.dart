import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mind_assistant/constants/global_instances.dart';
import 'package:mind_assistant/model/backlog_model.dart';
import 'package:mind_assistant/model/schedule_notification_model.dart';
import 'package:mind_assistant/services/local%20storage/local_storage_service.dart';

class BacklogController extends GetxController {
  final _localStorageService = LocalStorageService.instance;
  // final listTitleController = TextEditingController();
  RxList<BacklogModel> backLogs = <BacklogModel>[].obs;
  RxList<ScheduleNotificationModel> backLogNotifications =
      <ScheduleNotificationModel>[].obs;
  RxBool isAutoDelete = false.obs;
  Rx<DateTime> endDate = DateTime.now().obs;
  addBacklogList({required BacklogModel backlog}) async {
    backLogs.add(backlog);
    await _localStorageService.writeBacklogList(backLogs);
    update();
  }

  deleteBacklog({required String id}) async {
    final index = backLogs.indexWhere(
      (backlog) => backlog.id == id,
    );
    backLogs.removeAt(index);
    await _localStorageService.writeBacklogList(backLogs);
    update();
  }

  addBacklogItem(
      {required int index, required BacklogItemModel backlogItem}) async {
    backLogs[index].backlogItems.add(backlogItem);
    if (backLogs.isNotEmpty) {
      for (int index = 0; index < backLogs.length; index++) {
        backLogs[index].backlogItems =
            sortBacklogItems(backLogs[index].backlogItems);
      }
    }
    await _localStorageService.writeBacklogList(backLogs);

    update();
  }

  editBacklogItem(
      {required int backlogIndex,
      required BacklogItemModel backlogItem}) async {
    final itemIndex = backLogs[backlogIndex].backlogItems.indexWhere(
          (element) => element.id == backlogItem.id,
        );
    backLogs[backlogIndex].backlogItems[itemIndex] = backlogItem;
    if (backLogs.isNotEmpty) {
      for (int index = 0; index < backLogs.length; index++) {
        backLogs[index].backlogItems =
            sortBacklogItems(backLogs[index].backlogItems);
      }
    }
    await _localStorageService.writeBacklogList(backLogs);

    update();
  }

  deleteBacklogItem(
      {required int backlogIndex,
      required BacklogItemModel backlogItem}) async {
    final itemIndex = backLogs[backlogIndex].backlogItems.indexWhere(
          (element) => element.id == backlogItem.id,
        );
    backLogs[backlogIndex].backlogItems.removeAt(itemIndex);
    if (backLogs.isNotEmpty) {
      for (int index = 0; index < backLogs.length; index++) {
        backLogs[index].backlogItems =
            sortBacklogItems(backLogs[index].backlogItems);
      }
    }
    await _localStorageService.writeBacklogList(backLogs);

    update();
  }

  autoDelete() async {
    backLogs.value = await _localStorageService.readBacklogList();

    if (backLogs.isNotEmpty) {
      for (int i = 0; i < backLogs.length; i++) {
        final backlog = backLogs[i];
        if (backlog.backlogItems.isNotEmpty) {
          for (int index = 0; index < backlog.backlogItems.length; index++) {
            if (backlog.backlogItems[index].endDate != null &&
                backlog.backlogItems[index].isAutoDelete) {
              if (backlog.backlogItems[index].endDate!
                  .isBefore(DateTime.now())) {
                backlog.backlogItems.removeAt(index);
              }
            }
          }
        }
      }
    }
    await _localStorageService.writeBacklogList(backLogs);
  }

  List<BacklogItemModel> sortBacklogItems(List<BacklogItemModel> backlogItems) {
    backlogItems.sort((a, b) {
      int diffA = _getEndDateDifferenceInDays(a);
      int diffB = _getEndDateDifferenceInDays(b);

      if (diffA <= 30 && diffB > 30) {
        return -1;
      } else if (diffA > 30 && diffB <= 30) {
        return 1;
      }

      if (a.isAutoDelete && !b.isAutoDelete) {
        return -1;
      } else if (!a.isAutoDelete && b.isAutoDelete) {
        return 1;
      }

      return a.title.compareTo(b.title);
    });

    return backlogItems;
  }

  int _getEndDateDifferenceInDays(BacklogItemModel item) {
    if (item.endDate == null) {
      return 999999;
    }

    final now = DateTime.now();
    final difference = item.endDate!.difference(now).inDays;

    return difference;
  }

  @override
  void onInit() async {
    backLogs.value = await _localStorageService.readBacklogList();
    if (backLogs.isNotEmpty) {
      for (int index = 0; index < backLogs.length; index++) {
        backLogs[index].backlogItems =
            sortBacklogItems(backLogs[index].backlogItems);
      }
    }
    backLogNotifications.value = await _localStorageService
        .readScheduleNotificationsList(key: backlogScheduleNotificationsKey);
    super.onInit();
  }
}
