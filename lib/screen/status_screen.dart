import 'dart:async';

import 'package:attendance_system/core/constant/app_color.dart';
import 'package:attendance_system/core/constant/app_string.dart';
import 'package:attendance_system/core/constant/app_typography.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
      Provider.of<WorkProvider>(context, listen: false)
          .loadTodayAttendance();
    });
  }
  @override
  Widget build(BuildContext context) {
    String formattedTime = DateFormat("hh : mm a").format(now);
    String formattedDate = DateFormat("EEEE, MMMM d, yyyy").format(now);
    // final provider = context.watch<WorkProvider>();
    final Map<String,dynamic> user = ModalRoute.of(context)!.settings.arguments as Map<String,dynamic>;

    String userId = user['user']['id'].toString();
    return Container(
      color: AppColors.primary,
      child: SafeArea(
        bottom: false,
        child: Scaffold(
          backgroundColor: AppColors.white,
          body: Column(
            children: [
              CommonWidget.commonAppBarWidget(context: context, title: "${AppString.loginUserText} ${user['user']['name']} (${user['user']['role']})"),
              SizedBox(height: 20,),
              Expanded(
                child: Consumer<WorkProvider>(
                  builder: (context,provider,_){
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CommonWidget.commonRotateBoxContainer(
                          context: context,
                          margin: EdgeInsets.all(14),
                          padding: EdgeInsets.only(bottom: 10,top: 10),
                          // height: 550,
                          // width: MediaQuery.of(context).size.width,
                          // rotateBoxHeight: 520,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(AppString.todayStatusText,style: AppTypography.getTextTheme(context).titleMedium?.copyWith(fontSize: 18),),
                              SizedBox(height: 25,),
                              Padding(padding: EdgeInsets.only(left: 8), child: Text("FIRST HALF",style: AppTypography.getTextTheme(context).titleSmall?.copyWith(fontSize: 16),),),
                              SizedBox(height: 10,),
                              commonContainer(margin: EdgeInsets.only(right: 10, bottom: 12,left: 5), height: 120, width: MediaQuery.of(context).size.width,  border: Border.all(color: AppColors.primary),color:AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.all(Radius.circular(8)),
                                  child: attendanceCardContent(context,
                                    provider.firstCheckIn != null
                                        ? DateFormat('hh:mm a').format(provider.firstCheckIn!)
                                        : '--:--',
                                    provider.firstCheckOut != null
                                        ? DateFormat('hh:mm a').format(provider.firstCheckOut!)
                                        : '--:--',
                                  )),
                              SizedBox(height: 4),
                              /// Avg Daily Hours
                              Padding(padding: EdgeInsets.only(left: 8), child: Text("SECOND HALF",style: AppTypography.getTextTheme(context).titleSmall?.copyWith(fontSize: 16),),),
                              SizedBox(height: 10,),
                              commonContainer(margin: EdgeInsets.only(right: 10, bottom: 12,left: 5), height: 120, width: MediaQuery.of(context).size.width, color:AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.all(Radius.circular(8)), border: Border.all(color: AppColors.primary),
                                  child: attendanceCardContent(context,
                                    provider.secondCheckIn != null
                                        ? DateFormat("hh:mm a").format(provider.secondCheckIn!)
                                        : "--:--",
                                    provider.secondCheckOut != null
                                        ? DateFormat("hh:mm a").format(provider.secondCheckOut!)
                                        : "--:--",
                                  )),
                              SizedBox(height: 4),
                              Padding(
                                  padding: EdgeInsets.only(left: 3, right: 10, top: 8),
                                  child:
                                  // CustomButton(
                                  //   text: provider.getStatus(userId) == AttendanceStatus.firstCheckIn ||
                                  //       provider.getStatus(userId) == AttendanceStatus.secondCheckIn
                                  //       ? "CHECK IN (FIRST HALF)"
                                  //       : provider.getStatus(userId) == AttendanceStatus.completed
                                  //       ? "Day Completed"
                                  //       : "CHECK OUT (SECOND HALF)",
                                  //     onPressed: provider.getStatus(userId) == AttendanceStatus.completed
                                  //         ? null
                                  //         : () async {
                                  //       if (provider.getStatus(userId) == AttendanceStatus.firstCheckIn ||
                                  //           provider.getStatus(userId) == AttendanceStatus.secondCheckIn) {
                                  //         await provider.checkIn(userId);
                                  //       } else {
                                  //         await provider.checkOut(userId);
                                  //       }
                                  //   },
                                  // ),
                                  CustomButton(
                                    text: provider.buttonText,
                                    onPressed: provider.status == AttendanceStatus.completed
                                        ? null
                                        : () async {
                                      await provider.handleAttendance();
                                    },
                                  )
                              ),
                            ],
                          ),
                        )
                      ],
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  String formatDuration(Duration d) {
    return "${d.inHours}h ${d.inMinutes.remainder(60)}m";
  }
}
