import 'dart:developer';

import 'package:attendance_system/core/constant/app_color.dart';
import 'package:attendance_system/core/constant/app_typography.dart';
import 'package:attendance_system/core/widget/common_widget.dart';
import 'package:attendance_system/core/widget/custom_button.dart';
import 'package:attendance_system/provider/attendance_provider.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constant/app_string.dart';
import '../model/attendance_model.dart';
import '../services/api_service/api_helper.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {


  late List<Attendance> filteredAttendance;
  // List<Attendance> attendanceList = [
  //   Attendance(
  //     DateTime(2026, 2, 20),
  //     "4h 1m",
  //     "09:00 AM",
  //     "01:01 PM",
  //     "02:00 PM",
  //     "06:01 PM",
  //   ),
  //   Attendance(
  //     DateTime(2026, 2, 19),
  //     "8h 0m",
  //     "09:00 AM",
  //     "01:00 PM",
  //     "02:00 PM",
  //     "06:00 PM",
  //   ),
  //   Attendance(
  //     DateTime(2026, 1, 15),
  //     "7h 20m",
  //     "09:15 AM",
  //     "01:00 PM",
  //     "02:00 PM",
  //     "05:35 PM",
  //   ),
  // ];
  List<Map<String, dynamic>> months = [
    {"name": "January", "value": 1},
    {"name": "February", "value": 2},
    {"name": "March", "value": 3},
    {"name": "April", "value": 4},
    {"name": "May", "value": 5},
    {"name": "June", "value": 6},
    {"name": "July", "value": 7},
    {"name": "August", "value": 8},
    {"name": "September", "value": 9},
    {"name": "October", "value": 10},
    {"name": "November", "value": 11},
    {"name": "December", "value": 12},
  ];

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      final provider = context.read<AttendanceProvider>();
      provider.fetchAttendance(); // ✅ API call on screen load
    });
  }

  @override
  Widget build(BuildContext context) {
    final Map<String,dynamic> user = ModalRoute.of(context)!.settings.arguments as Map<String,dynamic>;
    final provider = context.read<AttendanceProvider>();
    return Container(
      color: AppColors.primary,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.white,
          body: Column(
            children: [
              CommonWidget.commonAppBarWidget(context: context, title: "${AppString.loginUserText} ${user['user']['name']} (${user['user']['role']})"),
              SizedBox(height: 10,),
              /// MONTH SELECTOR
              Container(
                margin: EdgeInsets.only(left: 5,right: 8,top: 5),
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: months.length,
                  itemBuilder: (context, index) {
                    final month = months[index];
                    bool isSelected = month["value"] == provider.selectedMonth;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          provider.selectedMonth = month["value"];
                        });
                        provider.fetchAttendance();
                      },
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 250),
                        margin: EdgeInsets.symmetric(horizontal: 6),
                        padding: EdgeInsets.symmetric(horizontal: 17, vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primary : AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: AppColors.primary)
                        ),
                        child: Center(
                          child: Text(
                            month["name"],
                            style: AppTypography.getTextTheme(context).titleSmall?.copyWith( color: isSelected ? Colors.white : AppColors.primary,fontSize: 14.5)
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              SizedBox(height: 8),

              /// ATTENDANCE LIST
              // Expanded(
              //     child: Consumer<AttendanceProvider>(
              //       builder: (context,provider,_){
              //         if (provider.isLoading) {
              //           return Center(child: CircularProgressIndicator(color: AppColors.primary,));
              //         } else if (provider.attendanceList.isEmpty) {
              //           return Center(child: Text( "No records available for this month",style: AppTypography.getTextTheme(context).bodyMedium?.copyWith(fontSize: 17),));
              //         }
              //         return CommonWidget.commonRotateBoxContainer(
              //         context: context,
              //         margin: EdgeInsets.only(left: 10,right: 10,bottom: 15),
              //             height: MediaQuery.of(context).size.height, // full height
              //             width: MediaQuery.of(context).size.width,
              //             rotateBoxHeight: MediaQuery.of(context).size.height - 50,
              //         child: Column(
              //           crossAxisAlignment: CrossAxisAlignment.start,
              //           children: [
              //             Padding(
              //               padding: EdgeInsets.only(left: 4),
              //               child: Text(AppString.historyTitle,style: AppTypography.getTextTheme(context).titleMedium?.copyWith(fontSize: 17),),
              //             ),
              //             SizedBox(height: 10,),
              //             Expanded(
              //               child: ListView.builder(
              //                 padding: EdgeInsets.only(top: 10),
              //                 itemCount: provider.attendanceList.length,
              //                 itemBuilder: (context, index) {
              //                   final attendance = provider.attendanceList[index];
              //                   print("attendance $attendance");
              //                   return Container(
              //                     height: 290,
              //                     width: MediaQuery.of(context).size.width,
              //                     margin: EdgeInsets.only(right: 10,left: 4),
              //                     padding: EdgeInsets.only(left: 10,right: 10),
              //                     decoration: BoxDecoration(
              //                         color: AppColors.primary.withOpacity(0.1),
              //                         borderRadius: BorderRadius.all(Radius.circular(5)),
              //                         border: Border.all(color: AppColors.primary)
              //                     ),
              //                     child: Column(
              //                       crossAxisAlignment: CrossAxisAlignment.start,
              //                       children: [
              //                         Row(
              //                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //                           children: [
              //                             Row(
              //                               children: [
              //                                 Container(
              //                                   margin: EdgeInsets.only(top: 10),
              //                                   height: 40,
              //                                   width: 40,
              //                                   decoration: BoxDecoration(
              //                                       borderRadius: BorderRadius.all(Radius.circular(5)),
              //                                       border: Border.all(color: AppColors.primary)
              //                                   ),
              //                                   child: Icon(Icons.calendar_today,color: AppColors.primary,size: 23,),
              //                                 ),
              //                                 SizedBox(width: 10,),
              //                                 Padding(
              //                                   padding: EdgeInsets.only(top: 10),
              //                                   child: Text('${attendance.date.day}/${attendance.date.month}/${attendance.date.year}',style: AppTypography.getTextTheme(context).titleMedium?.copyWith(color: AppColors.primary),),
              //                                 ),
              //                               ],
              //                             ),
              //                             Container(
              //                               margin: EdgeInsets.only(left: 10,top: 10),
              //                               height: 40,
              //                               width: 105,
              //                               decoration: BoxDecoration(
              //                                   borderRadius: BorderRadius.all(Radius.circular(5)),
              //                                   color: AppColors.primary
              //                               ),
              //                               child: Row(
              //                                 mainAxisAlignment: MainAxisAlignment.center,
              //                                 children: [
              //                                   Icon(Icons.access_time_outlined,color: AppColors.white,size: 21),
              //                                   SizedBox(width: 3,),
              //                                   Text(
              //                                     attendance.totalHours,
              //                                     style: AppTypography.getTextTheme(context).titleSmall?.copyWith(color: Colors.white,fontSize: 16),
              //                                   ),
              //                                 ],
              //                               ),
              //                             ),
              //                           ],
              //                         ),
              //                         SizedBox(height: 10,),
              //                         attendanceHistoryCheckInCardContent(
              //                           context: context,
              //                           checkInTime1: attendance.checkIn1,
              //                           checkInTime2: attendance.checkOut1,
              //                           checkInText1: "Check-In 1",
              //                           checkOutText1: "Check-Out 1",
              //                         ),
              //
              //                         SizedBox(height: 10,),
              //                         attendanceHistoryCheckInCardContent(
              //                           context: context,
              //                           checkInTime1: attendance.checkIn2,
              //                           checkInTime2: attendance.checkOut2,
              //                           checkInText1: "Check-In 2",
              //                           checkOutText1: "Check-Out 2",
              //                         ),
              //
              //                       ],
              //                     ),
              //                   );
              //                 },
              //               ),
              //             ),
              //           ],
              //         )
              //                               );
              //       },
              //     )
              // )
              Expanded(
                child: Consumer<AttendanceProvider>(
                  builder: (context, provider, _) {
                    if (provider.isLoading) {
                      return Center(
                        child: CircularProgressIndicator(color: AppColors.primary),
                      );
                    } else if (provider.attendanceList.isEmpty) {
                      return Center(
                        child: Text(
                          "No records available for this month",
                          style: AppTypography.getTextTheme(context)
                              .bodyMedium
                              ?.copyWith(fontSize: 17),
                        ),
                      );
                    }

                    return CommonWidget.commonRotateBoxContainer(
                      context: context,
                      margin: EdgeInsets.only(left: 10, right: 10, bottom: 1),
                      // height: MediaQuery.of(context).size.height, // full height
                      // width: MediaQuery.of(context).size.width,
                      // rotateBoxHeight: MediaQuery.of(context).size.height - 50,

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// ✅ TITLE
                          Padding(
                            padding: EdgeInsets.only(left: 4),
                            child: Text(
                              AppString.historyTitle,
                              style: AppTypography.getTextTheme(context)
                                  .titleMedium
                                  ?.copyWith(fontSize: 17),
                            ),
                          ),

                          SizedBox(height: 10),

                          /// ✅ LIST INSIDE ROTATE BOX
                          Expanded(
                            child: ListView.builder(
                              shrinkWrap: true,
                              padding: EdgeInsets.only(top: 5),
                              itemCount: provider.attendanceList.length,
                              itemBuilder: (context, index) {
                                final attendance = provider.attendanceList[index];

                                return Container(
                                  margin: EdgeInsets.only(bottom: 12),
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(color: AppColors.primary),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      /// DATE + HOURS
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                // margin: EdgeInsets.only(top: 10),
                                                height: 40,
                                                width: 40,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                  BorderRadius.circular(5),
                                                  border: Border.all(
                                                      color: AppColors.primary),
                                                ),
                                                child: Icon(Icons.calendar_today,
                                                    color: AppColors.primary),
                                              ),
                                              SizedBox(width: 10),
                                              Text(
                                                '${attendance.date.day}/${attendance.date.month}/${attendance.date.year}',
                                                style: AppTypography
                                                    .getTextTheme(context)
                                                    .titleMedium
                                                    ?.copyWith(
                                                    color:
                                                    AppColors.primary),
                                              ),
                                            ],
                                          ),

                                          Container(
                                            height: 40,
                                            width: 105,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                              BorderRadius.circular(5),
                                              color: AppColors.primary,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              children: [
                                                Icon(Icons.access_time_outlined,
                                                    color: Colors.white),
                                                SizedBox(width: 3),
                                                Text(
                                                  attendance.totalHours,
                                                  style: AppTypography
                                                      .getTextTheme(context)
                                                      .titleSmall
                                                      ?.copyWith(
                                                      color: Colors.white),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),

                                      SizedBox(height: 10),

                                      attendanceHistoryCheckInCardContent(
                                        context: context,
                                        checkInTime1: attendance.checkIn1,
                                        checkInTime2: attendance.checkOut1,
                                        checkInText1: "Check-In 1",
                                        checkOutText1: "Check-Out 1",
                                      ),

                                      SizedBox(height: 10),

                                      attendanceHistoryCheckInCardContent(
                                        context: context,
                                        checkInTime1: attendance.checkIn2,
                                        checkInTime2: attendance.checkOut2,
                                        checkInText1: "Check-In 2",
                                        checkOutText1: "Check-Out 2",
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
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
}

