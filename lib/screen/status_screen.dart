import 'dart:async';
import 'package:attendance_system/core/constant/app_color.dart';
import 'package:attendance_system/core/constant/app_string.dart';
import 'package:attendance_system/core/constant/app_typography.dart';
import 'package:attendance_system/provider/user_provider.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../core/widget/common_widget.dart';
import '../core/widget/custom_button.dart';
import '../provider/work_provider.dart';

class StatusScreen extends StatefulWidget {
  const StatusScreen({super.key});

  @override
  State<StatusScreen> createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  DateTime now = DateTime.now();
  Timer? timer;
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<WorkProvider>(context, listen: false).loadTodayAttendance();
    });
  }
  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final size = MediaQuery.of(context).size;
    final orientation = MediaQuery.of(context).orientation;
    final isLandscape = orientation == Orientation.landscape;
    final isTablet = size.width >= 600;
    return Container(
      color: AppColors.primary,
      child: SafeArea(
        bottom: false,
        child: Scaffold(
          backgroundColor: AppColors.white,
          body: Column(
            children: [
              ///Add today's time
              CommonWidget.commonAppBarWidget(context: context, title: "${AppString.loginUserText} ${userProvider.name} (${userProvider.role})"),
              SizedBox(height: 10),
              Expanded(
                child: Consumer<WorkProvider>(
                    builder: (context, provider, _) {
                      final size = MediaQuery.of(context).size;
                      final orientation = MediaQuery.of(context).orientation;
                      final isLandscape = orientation == Orientation.landscape;
                      final isTablet = size.width >= 600;
                      return Center(
                        child: SingleChildScrollView(
                          child: Container(
                            constraints: BoxConstraints(
                              maxWidth: isTablet ? 700 : double.infinity,
                            ),
                            margin: EdgeInsets.symmetric(
                              horizontal: isTablet ? 30 : 10,
                              vertical: 10,
                            ),
                            padding: EdgeInsets.all(isTablet ? 16 : 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  offset: Offset(0, 4),
                                  blurRadius: 5,
                                  spreadRadius: 2,
                                  color: Colors.grey.shade300,
                                )
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                /// TITLE
                                userProvider.role == 'ADMIN' || userProvider.role == 'HR'? SizedBox(height: 0): SizedBox(height: 10),
                                IntrinsicHeight(
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 10),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.symmetric(vertical: 8),
                                          width: 4,
                                          decoration: BoxDecoration(
                                            color: AppColors.primary,
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                              vertical: 12,
                                              horizontal: 8,
                                            ),
                                            child: Text(
                                              AppString.todayStatusText,
                                              style: AppTypography.getTextTheme(context).titleMedium?.copyWith(fontSize: isTablet ? 20 : 18,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                userProvider.role == 'ADMIN' || userProvider.role == 'HR'? SizedBox(height: 10): SizedBox(height: 20),
                                /// RESPONSIVE BODY (MAIN CHANGE)
                                isTablet || isLandscape
                                    ? Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(child: firstHalf(provider, isTablet)),
                                    SizedBox(width: 16),
                                    Expanded(child: secondHalf(provider, isTablet)),
                                  ],
                                )
                                    : Column(
                                  children: [
                                    firstHalf(provider, isTablet),
                                    userProvider.role == 'ADMIN' || userProvider.role == 'HR'? SizedBox(height: 15): SizedBox(height: 18),
                                    secondHalf(provider, isTablet),
                                  ],
                                ),
                                SizedBox(height: 20),
                                /// BUTTON
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: isTablet ? 10 : 4,
                                  ),
                                  child: CustomButton(
                                    text: provider.buttonText,
                                    width: double.infinity,
                                    onPressed: provider.status == AttendanceStatus.completed
                                        ? null
                                        : () async {
                                      await provider.handleAttendance();
                                    },
                                  ),
                                ),
                              if (userProvider.role == 'ADMIN' || userProvider.role == 'HR') ...[
                              SizedBox(height: 14),
                              Row(
                                children: [
                                  Text(
                                    "Today's Status",
                                    style: AppTypography.getTextTheme(context).titleSmall?.copyWith(fontSize: isTablet ? 18 : 16),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Consumer<WorkProvider>(
                                builder: (context, provider, _) {
                                  return CommonWidget.commonStatusButton(
                                    context: context,
                                    height: isTablet ? 60 : 50,
                                    width: double.infinity,
                                    color: Colors.green.shade50,
                                    icon: FeatherIcons.clock,
                                    iconColor: Colors.green,
                                    borderColor: Colors.green,
                                    buttonTitle: provider.attendanceStatus,
                                    stringTextColor: Colors.green,
                                    iconSize: isTablet ? 22 : 18,
                                  );
                                },
                              ),
                                SizedBox(height: 15),
                              ],
                            ]),
                          ),
                        ),
                      );
                    }
                ),
              ),
              ],
          ),
        ),
      ),
    );
  }

  String formatDuration(Duration d) {
    return "${d.inHours}h ${d.inMinutes.remainder(60)}m";
  }

  Widget firstHalf(WorkProvider provider, bool isTablet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 8),
          child: Text(
            "FIRST HALF",
            style: AppTypography.getTextTheme(context)
                .titleSmall
                ?.copyWith(fontSize: isTablet ? 18 : 16),
          ),
        ),
        SizedBox(height: 8),
        commonContainer(
          height: isTablet ? 150 : 120,
          width: double.infinity,
          margin: EdgeInsets.symmetric(horizontal: 5),
          border: Border.all(color: AppColors.primary),
          color: AppColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          child: attendanceCardContent(
            context,
            provider.firstCheckIn != null
                ? DateFormat('hh:mm a').format(provider.firstCheckIn!)
                : '--:--',
            provider.firstCheckOut != null
                ? DateFormat('hh:mm a').format(provider.firstCheckOut!)
                : '--:--',
          ),
        ),
      ],
    );
  }

  Widget secondHalf(WorkProvider provider, bool isTablet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 8),
          child: Text(
            "SECOND HALF",
            style: AppTypography.getTextTheme(context)
                .titleSmall
                ?.copyWith(fontSize: isTablet ? 18 : 16),
          ),
        ),
        SizedBox(height: 8),
        commonContainer(
          height: isTablet ? 150 : 120,
          width: double.infinity,
          margin: EdgeInsets.symmetric(horizontal: 5),
          border: Border.all(color: AppColors.primary),
          color: AppColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          child: attendanceCardContent(
            context,
            provider.secondCheckIn != null
                ? DateFormat("hh:mm a").format(provider.secondCheckIn!)
                : "--:--",
            provider.secondCheckOut != null
                ? DateFormat("hh:mm a").format(provider.secondCheckOut!)
                : "--:--",
          ),
        ),
      ],
    );
  }
}
