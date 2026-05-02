import 'package:flutter/material.dart';

enum ScreenSize { mobile, tablet, desktop }

class ResponsiveBreakpoints {
  static const double mobileMaxWidth = 600;
  static const double tabletMaxWidth = 1024;

  static ScreenSize getScreenSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return getScreenSizeForWidth(width);
  }

  static ScreenSize getScreenSizeForWidth(double width) {
    if (width < mobileMaxWidth) {
      return ScreenSize.mobile;
    } else if (width < tabletMaxWidth) {
      return ScreenSize.tablet;
    } else {
      return ScreenSize.desktop;
    }
  }

  static bool isMobile(BuildContext context) =>
      getScreenSize(context) == ScreenSize.mobile;

  static bool isTablet(BuildContext context) =>
      getScreenSize(context) == ScreenSize.tablet;

  static bool isDesktop(BuildContext context) =>
      getScreenSize(context) == ScreenSize.desktop;

  static bool isLandscape(BuildContext context) =>
      MediaQuery.of(context).orientation == Orientation.landscape;

  static bool isPortrait(BuildContext context) =>
      MediaQuery.of(context).orientation == Orientation.portrait;

  static int getGridColumns(BuildContext context) {
    final screenSize = getScreenSize(context);
    final isLandscape = ResponsiveBreakpoints.isLandscape(context);

    switch (screenSize) {
      case ScreenSize.mobile:
        return isLandscape ? 4 : 3;
      case ScreenSize.tablet:
        return isLandscape ? 5 : 4;
      case ScreenSize.desktop:
        return 5;
    }
  }

  static double getContentMaxWidth(BuildContext context) {
    final screenSize = getScreenSize(context);

    switch (screenSize) {
      case ScreenSize.mobile:
        return double.infinity;
      case ScreenSize.tablet:
        return 900;
      case ScreenSize.desktop:
        return 1200;
    }
  }

  static EdgeInsets getScreenPadding(BuildContext context) {
    final screenSize = getScreenSize(context);

    switch (screenSize) {
      case ScreenSize.mobile:
        return const EdgeInsets.all(16);
      case ScreenSize.tablet:
        return const EdgeInsets.all(24);
      case ScreenSize.desktop:
        return const EdgeInsets.all(32);
    }
  }
}
