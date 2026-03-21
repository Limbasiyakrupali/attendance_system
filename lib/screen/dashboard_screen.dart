import 'dart:async';

import 'package:attendance_system/core/constant/app_color.dart';
import 'package:attendance_system/core/constant/app_string.dart';
import 'package:attendance_system/core/widget/common_widget.dart';
import 'package:attendance_system/provider/work_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../core/constant/app_typography.dart';
import '../core/widget/custom_button.dart';
import 'package:feather_icons/feather_icons.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
int _currentIndex = 0;
  DateTime now = DateTime.now();
  Timer? timer;

  @override
  void initState() {
    super.initState();

    /// Live clock update every second
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        now = DateTime.now();
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    String formattedTime = DateFormat("hh : mm a").format(now);
    String formattedDate = DateFormat("EEEE, MMMM d, yyyy").format(now);
    final workProvider = context.read<WorkProvider>();
    final Map<String,dynamic> user = ModalRoute.of(context)!.settings.arguments as Map<String,dynamic>;
    return Container(
      color: AppColors.primary,
      child: SafeArea(
        bottom: false,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Column(
              children: [
                CommonWidget.commonAppBarWidget(context: context, title: "${AppString.loginUserText} ${user['user']['name']} (${user['user']['role']})"),
                  SizedBox(height: 8),
                  user['user']['role'] != "ADMIN"
                      ?  Column(children: [
                      // Container(
                      //   width: double.infinity,
                      //   decoration: const BoxDecoration(
                      //     color: Colors.white,
                      //     borderRadius: BorderRadius.vertical(
                      //       top: Radius.circular(40),
                      //     ),
                      //   ),
                      //   child: Column(
                      //     children: [
                      //       /// Current Time
                      //       // Text(formattedTime, style: AppTypography.getTextTheme(context).displayLarge?.copyWith(fontWeight: FontWeight.w600,fontSize: 30)),
                      //       // const SizedBox(height: 5),
                      //       // Text(formattedDate, style: AppTypography.getTextTheme(context).titleSmall?.copyWith(color: AppColors.primary,fontWeight: FontWeight.w700)),
                      //       // const SizedBox(height: 20),
                      //       // /// Circular Check-in Button
                      //       // GestureDetector(
                      //       //   onTap: () {
                      //       //     print("Check In tapped");
                      //       //   },
                      //       //   child: Container(
                      //       //     height: 180,
                      //       //     width: 180,
                      //       //     decoration: BoxDecoration(
                      //       //       shape: BoxShape.circle,
                      //       //       border: Border.all(color: AppColors.primary.withOpacity(0.8), width: 8,),
                      //       //     ),
                      //       //     child: Center(
                      //       //       child: Container(
                      //       //         height: 140,
                      //       //         width: 140,
                      //       //         decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.primary.withOpacity(0.2),
                      //       //         ),
                      //       //         child: Column(
                      //       //           mainAxisAlignment: MainAxisAlignment.center,
                      //       //           children: [
                      //       //             Image(image: AssetImage("assets/image/checkin_icon.png"),color: AppColors.primary,),
                      //       //             SizedBox(height: 10),
                      //       //             Text(AppString.checkInText, style: AppTypography.getTextTheme(context).titleSmall?.copyWith(color: AppColors.primary,fontWeight: FontWeight.w700,fontSize: 16)
                      //       //             )
                      //       //           ],
                      //       //         ),
                      //       //       ),
                      //       //     ),
                      //       //   ),
                      //       // ),
                      //       // const SizedBox(height: 25),
                      //     ],
                      //   ),
                      // ),
                      /// Days Worked
                      // Row(
                      //   children: [
                      //     Expanded(
                      //       child: commonContainer(
                      //         margin: EdgeInsets.only(left: 10,right: 5, bottom: 12),
                      //         height: 140,
                      //         width: MediaQuery.of(context).size.width/2,
                      //         color: AppColors.primary.withOpacity(0.9),
                      //         borderRadius: BorderRadius.all(Radius.circular(8)),
                      //         child: dashboardCardContent(
                      //           context: context,
                      //           title: "Days Worked",
                      //           value: workProvider.daysWorked.toString(),
                      //           progress: workProvider.daysWorked / 30,
                      //           textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600,color: Colors.white,fontSize: 16),
                      //           valueColor: AppColors.white,
                      //           progressColor: AppColors.white,
                      //           progressBgColor: Colors.white24,
                      //         ),
                      //       ),
                      //     ),
                      //     Expanded(
                      //       child: commonContainer(
                      //         margin: EdgeInsets.only( left: 5,right: 10, bottom: 12),
                      //         height: 140,
                      //         width: MediaQuery.of(context).size.width/2,
                      //         color: AppColors.primary.withOpacity(0.2),
                      //         border: Border.all(color: AppColors.primary, width: 1.5),
                      //         borderRadius: BorderRadius.all(Radius.circular(8)),
                      //         child: dashboardCardContent(
                      //           context: context,
                      //           title: "Total Hours",
                      //           value: formatDuration(workProvider.totalDuration),
                      //           progress: workProvider.totalDuration.inHours / 160,
                      //           textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600,color: AppColors.primary,fontSize: 16),
                      //           valueColor: AppColors.primary,
                      //           progressColor: AppColors.primary,
                      //           progressBgColor: Colors.white,
                      //         ),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      CommonWidget.commonRotateBoxContainer(
                          context: context,
                          margin: EdgeInsets.only(left: 12,right: 12,top: 15,bottom: 12),
                          // width: MediaQuery.of(context).size.width,
                          // rotateBoxHeight: 550,
                          // height: 580,
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(AppString.dashBoardTitle, style: AppTypography.getTextTheme(context).titleMedium?.copyWith(fontSize: 18),),
                                SizedBox(height: 15),
                                /// For Employee / Trainee / Freelancer
                                  commonContainer(
                                    margin: EdgeInsets.only(left: 3, right: 12, bottom: 10),
                                    height: 130,
                                    width: MediaQuery.of(context).size.width,
                                    color: AppColors.primary.withOpacity(0.1),
                                    border: Border.all(color: AppColors.primary, width: 1.5),
                                    borderRadius: BorderRadius.all(Radius.circular(8)),
                                    child: dashboardCardContent(
                                      context: context,
                                      title: "Days Worked",
                                      value: workProvider.daysWorked.toString(),
                                      progress: workProvider.daysWorked / 30,
                                      textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: AppColors.primary, fontSize: 17),
                                      valueColor: AppColors.primary,
                                      progressColor: AppColors.primary,
                                      progressBgColor: Colors.white,
                                    ),
                                  ),
                                  commonContainer(
                                    margin: EdgeInsets.only(left: 3, right: 12, bottom: 10),
                                    height: 130,
                                    width: MediaQuery.of(context).size.width,
                                    color: AppColors.primary.withOpacity(0.1),
                                    border: Border.all(color: AppColors.primary, width: 1.5),
                                    borderRadius: BorderRadius.all(Radius.circular(8)),
                                    child: dashboardCardContent(
                                      context: context,
                                      title: "Total Hours",
                                      value: formatDuration(workProvider.totalDuration),
                                      progress: workProvider.totalDuration.inHours / 160,
                                      textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: AppColors.primary, fontSize: 17),
                                      valueColor: AppColors.primary,
                                      progressColor: AppColors.primary,
                                      progressBgColor: Colors.white,
                                    ),
                                  ),
                                  commonContainer(
                                    margin: EdgeInsets.only(left: 3, right: 12, bottom: 10),
                                    height: 130,
                                    width: MediaQuery.of(context).size.width,
                                    color: AppColors.primary.withOpacity(0.1), border: Border.all(color: AppColors.primary, width: 1.5),
                                    borderRadius: BorderRadius.all(Radius.circular(8)),
                                    child: dashboardCardContent(
                                      context: context,
                                      title: "Avg. Daily Hours",
                                      value: formatDuration(workProvider.totalDuration),
                                      progress: workProvider.totalDuration.inHours / 160,
                                      textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: AppColors.primary, fontSize: 17),
                                      valueColor: AppColors.primary,
                                      progressColor: AppColors.primary,
                                      progressBgColor: Colors.white,
                                    ),
                                  ),
                                /// Check-in Button (Sab ke liye)
                                SizedBox(height: 5),
                                Padding(
                                  padding: EdgeInsets.only(left: 3,bottom: 8),
                                  child: Row(
                                    children: [
                                      Text("Today's Status",style: AppTypography.getTextTheme(context).titleSmall?.copyWith(fontSize: 18),)
                                    ],
                                  ),
                                ),
                                Consumer<WorkProvider>(
                                  builder: (context, provider,_){
                                    return  CommonWidget.commonStatusButton(
                                        context: context,
                                        height: 50,
                                        width: MediaQuery.of(context).size.width,
                                        color: Colors.green.shade50,
                                        icon: FeatherIcons.clock,
                                        iconColor: Colors.green,
                                        borderColor:  Colors.green,
                                        buttonTitle: provider.attendanceStatus,
                                        stringTextColor: Colors.green,
                                        iconSize: 18
                                    );
                                  },
                                )
                              ],
                            ),
                          )
                      )
                    ])
                      :  Column(
                    children: [
                      CommonWidget.commonRotateBoxContainer(
                          context: context,
                      margin: EdgeInsets.only(left: 12,right: 12,top: 15,bottom: 12),
                      // width: MediaQuery.of(context).size.width,
                      // rotateBoxHeight: 635,
                      // height: 700,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppString.dashBoardTitle,
                              style: AppTypography.getTextTheme(context).titleMedium?.copyWith(fontSize: 18),
                            ),
                            SizedBox(height: 15),
                            /// For Admin Only
                              commonContainer(
                                margin: EdgeInsets.only(left: 3, right: 12, bottom: 8),
                                height: 125,
                                width: MediaQuery.of(context).size.width,
                                color: AppColors.primary.withOpacity(0.1),
                                border: Border.all(color: AppColors.primary, width: 1.5),
                                borderRadius: BorderRadius.all(Radius.circular(8)),
                                child: dashboardAdminCardContent(
                                  context: context,
                                  title: "Total Users",
                                  value: "16",
                                  textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: AppColors.primary, fontSize: 17),
                                ),
                              ),
                              commonContainer(
                                margin: EdgeInsets.only(left: 3, right: 12, bottom: 8),
                                height: 125,
                                width: MediaQuery.of(context).size.width,
                                color: AppColors.primary.withOpacity(0.1),
                                border: Border.all(color: AppColors.primary, width: 1.5),
                                borderRadius: BorderRadius.all(Radius.circular(8)),
                                child: dashboardAdminCardContent(
                                  context: context,
                                  title: "Total Employee",
                                  value: "3",
                                  textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: AppColors.primary, fontSize: 17),
                                ),
                              ),
                              commonContainer(
                                margin: EdgeInsets.only(left: 3, right: 12, bottom: 8),
                                height: 125,
                                width: MediaQuery.of(context).size.width,
                                color: AppColors.primary.withOpacity(0.1),
                                border: Border.all(color: AppColors.primary, width: 1.5),
                                borderRadius: BorderRadius.all(Radius.circular(8)),
                                child: dashboardAdminCardContent(
                                  context: context,
                                  title: "Total Freelancers",
                                  value: "2",
                                  textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: AppColors.primary, fontSize: 17),
                                ),
                              ),
                              commonContainer(
                                margin: EdgeInsets.only(left: 3, right: 12, bottom: 8),
                                height: 125,
                                width: MediaQuery.of(context).size.width,
                                color: AppColors.primary.withOpacity(0.1),
                                border: Border.all(color: AppColors.primary, width: 1.5),
                                borderRadius: BorderRadius.all(Radius.circular(8)),
                                child: dashboardAdminCardContent(
                                  context: context,
                                  title: "Total Trainee",
                                  value: "6",
                                  textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: AppColors.primary, fontSize: 17),
                                ),
                              ),
                            /// Check-in Button (Sab ke liye)
                            Padding(
                              padding: EdgeInsets.only(left: 3,bottom: 8),
                              child: Row(
                                children: [
                                  Text("Today's Status",style: AppTypography.getTextTheme(context).titleSmall?.copyWith(fontSize: 18),)
                                ],
                              ),
                            ),
                            Consumer<WorkProvider>(
                              builder: (context, provider,_){
                                return  CommonWidget.commonStatusButton(
                                    context: context,
                                    height: 50,
                                    width: MediaQuery.of(context).size.width,
                                    color: Colors.green.shade50,
                                    icon: FeatherIcons.clock,
                                    iconColor: Colors.green,
                                    borderColor:  Colors.green,
                                    buttonTitle: provider.attendanceStatus,
                                    stringTextColor: Colors.green,
                                    iconSize: 18
                                );
                              },
                            )
                          ],
                        ),
                      ))],)
              ],
            ),
          ),
        ),
      ),
    );
  }

  String formatDuration(Duration d) {
    return "${d.inHours}h ${d.inMinutes.remainder(60)}m";
  }
}
