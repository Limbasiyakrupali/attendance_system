import 'package:flutter/material.dart';
import '../responsive/responsive_extension.dart';

class AppSpacing {

  static double pagePadding(BuildContext context) => context.responsiveValue(mobile: 20, tablet: 32);

  static double cardPadding(BuildContext context) =>
      context.responsiveValue(mobile: 12, tablet: 20);

  static double sectionSpacing(BuildContext context) =>
      context.responsiveValue(mobile: 16, tablet: 28);
}
