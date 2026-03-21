import 'package:flutter/material.dart';
import 'breakpoints.dart';
import 'device_type.dart';

class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, DeviceType deviceType) builder;

  const ResponsiveBuilder({super.key, required this.builder});

  DeviceType _getDeviceType(double width) {
    if (width < AppBreakpoints.mobile) {
      return DeviceType.mobile;
    } else {
      return DeviceType.tablet;
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final deviceType = _getDeviceType(constraints.maxWidth);
        return builder(context, deviceType);
      },
    );
  }
}
