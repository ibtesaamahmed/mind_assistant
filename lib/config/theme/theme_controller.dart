import 'package:get/get.dart';
import 'package:mind_assistant/config/theme/theme.dart';
import 'package:mind_assistant/services/local%20storage/local_storage_service.dart';

class ThemeController extends GetxController {
  final _localStorageService = LocalStorageService.instance;
  static ThemeController instance = Get.find<ThemeController>();
  RxBool isDarkTheme = false.obs;

  onToggle() async {
    isDarkTheme.value = !isDarkTheme.value;
    isDarkTheme.value
        ? Get.changeTheme(darkTheme)
        : Get.changeTheme(lightTheme);
    await _localStorageService.writeTheme(isDarkTheme.value);
  }

  checkTheme() async {
    isDarkTheme.value = await _localStorageService.readTheme();
    isDarkTheme.value
        ? Get.changeTheme(darkTheme)
        : Get.changeTheme(lightTheme);
  }

  @override
  void onInit() async {
    super.onInit();
    await checkTheme();
  }
}
