import 'package:get/get.dart';
import 'package:mind_assistant/config/enums/tasks_status.dart';
import 'package:mind_assistant/model/tasks_model.dart';
import 'package:mind_assistant/services/local%20storage/local_storage_service.dart';

class KanbanController extends GetxController {
  final _localStorageService = LocalStorageService.instance;
  RxList<TasksModel> kanbanTasks = <TasksModel>[].obs;
  addKanbanTask({required TasksModel task}) async {
    kanbanTasks.add(task);
    await _localStorageService.writeKanbanTasksList(kanbanTasks);
  }

  addEditTask({required TasksModel task}) async {
    final index = kanbanTasks.indexWhere(
      (t) => t.id == task.id,
    );
    kanbanTasks[index] = task;
    await _localStorageService.writeKanbanTasksList(kanbanTasks);
  }

  removeKanbanTask({required String id}) async {
    final index = kanbanTasks.indexWhere(
      (task) => task.id == id,
    );
    kanbanTasks.removeAt(index);
    await _localStorageService.writeKanbanTasksList(kanbanTasks);
  }

  changeStatus({required String id, required TasksStatus status}) async {
    final index = kanbanTasks.indexWhere(
      (task) => task.id == id,
    );
    kanbanTasks[index].lastEdited = DateTime.now();
    kanbanTasks[index].status = status;
    await _localStorageService.writeKanbanTasksList(kanbanTasks);
    update();
  }

  @override
  void onInit() async {
    kanbanTasks.value = await _localStorageService.readKanbanTaskList();
    super.onInit();
  }
}
