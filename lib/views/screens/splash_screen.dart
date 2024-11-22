import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mind_assistant/constants/app_images.dart';
import 'package:mind_assistant/views/widgets/bottom_nav_bar_widget.dart';
import 'package:mind_assistant/views/widgets/common_image_widget.dart';
import 'package:mind_assistant/views/widgets/my_text_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2)).then(
      (_) {
        Get.offAll(() => BottomNavBarWidget());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CommonImageView(
          imagePath: Assets.imagesLogo,
          height: 250,
          width: 250,
        ),
      ),
    );
  }
}
