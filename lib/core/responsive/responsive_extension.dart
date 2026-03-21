import 'package:flutter/material.dart';
import 'breakpoints.dart';

extension ResponsiveExtension on BuildContext {

  bool get isMobile => MediaQuery.of(this).size.width < AppBreakpoints.mobile;

  bool get isTablet => MediaQuery.of(this).size.width >= AppBreakpoints.mobile;

  double responsiveValue({
    required double mobile,
    required double tablet,
  }) {
    return isMobile ? mobile : tablet;
  }
}
