import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:mind_assistant/views/screens/splash_screen.dart';

class AppRoutes {
  static final List<GetPage> pages = [
    GetPage(
      name: AppLinks.splashScreen,
      page: () => const SplashScreen(),
    ),
  ];
}

class AppLinks {
  static const splashScreen = '/splash_screen';
}
