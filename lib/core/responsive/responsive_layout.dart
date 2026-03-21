import 'package:flutter/material.dart';
import 'responsive_builder.dart';
import 'device_type.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget tablet;

  const ResponsiveLayout({
    super.key,
    required this.mobile,
    required this.tablet,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, deviceType) {
        switch (deviceType) {
          case DeviceType.tablet:
            return tablet;
          case DeviceType.mobile:
          default:
            return mobile;
        }
      },
    );
  }
}
