import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mind_assistant/bindings/bindings.dart';
import 'package:mind_assistant/config/routes/routes.dart';
import 'package:mind_assistant/config/theme/theme.dart';
import 'package:mind_assistant/services/notification/notification_service.dart';

@pragma(
    'vm:entry-point') //for getting background notifications in release mode also
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.instance.initializeNotifications();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      debugShowMaterialGrid: false,
      title: 'Mind Assistant',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.light,
      initialRoute: AppLinks.splashScreen,
      getPages: AppRoutes.pages,
      initialBinding: InitialBindings(),
    );
  }
}
