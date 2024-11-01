import 'package:flutter/material.dart';

enum FontSizeMode { small, medium, large }

class ScreenUtils {
  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  static FontSizeMode fontSizeMode = FontSizeMode.medium;

  static void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
  }

  static double getResponsiveFontSize(double baseFontSize) {
    double scaleFactor;
    switch (fontSizeMode) {
      case FontSizeMode.small:
        scaleFactor = 0.8;
        break;
      case FontSizeMode.medium:
        scaleFactor = 1.0;
        break;
      case FontSizeMode.large:
        scaleFactor = 1.2;
        break;
    }
    return baseFontSize * scaleFactor;
  }

  static double getResponsiveSize(double size) {
    return (size / 375.0) * screenWidth;
  }
}

extension ContextExtension on BuildContext {
  double getResponsiveFontSize(double baseFontSize) => ScreenUtils.getResponsiveFontSize(baseFontSize);
  double getResponsiveSize(double size) => ScreenUtils.getResponsiveSize(size);
}