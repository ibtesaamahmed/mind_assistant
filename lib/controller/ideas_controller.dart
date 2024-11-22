import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:get/get.dart';
import 'package:mind_assistant/model/ideas_model.dart';
import 'package:mind_assistant/services/local%20storage/local_storage_service.dart';

class IdeasController extends GetxController {
  final _localStorageService = LocalStorageService.instance;
  RxList<IdeasModel> ideas = <IdeasModel>[].obs;

  addIdea({required IdeasModel idea}) async {
    ideas.add(idea);
    await _localStorageService.writeIdeasList(ideas);
  }

  editIdea({required IdeasModel idea}) async {
    final index = ideas.indexWhere(
      (i) => i.id == idea.id,
    );
    ideas[index] = idea;
    await _localStorageService.writeIdeasList(ideas);
  }

  removeIdeas({required int index}) async {
    ideas.removeAt(index);
    await _localStorageService.writeIdeasList(ideas);
  }

  @override
  void onInit() async {
    ideas.value = await _localStorageService.readIdeasList();
    super.onInit();
  }
}
