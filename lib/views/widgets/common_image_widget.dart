import 'dart:io';

import 'package:flutter/material.dart';

class CommonImageView extends StatelessWidget {
  final String? imagePath;
  final File? file;
  final double? height;
  final double? width;
  final double? radius;
  final BoxFit fit;
  final Color? imageColor;

  const CommonImageView({
    super.key,
    this.imagePath,
    this.file,
    this.height,
    this.width,
    this.radius = 0.0,
    this.fit = BoxFit.cover,
    this.imageColor,
  });

  @override
  Widget build(BuildContext context) {
    return _buildImageView();
  }

  Widget _buildImageView() {
    if (file != null && file!.path.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(radius!),
        child: Image.file(
          file!,
          height: height,
          width: width,
          fit: fit,
        ),
      );
    } else if (imagePath != null && imagePath!.isNotEmpty) {
      return Image.asset(
        imagePath!,
        height: height,
        width: width,
        fit: fit,
        color: imageColor,
      );
    }
    return const SizedBox();
  }
}
