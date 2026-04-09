import 'package:attendance_system/core/constant/app_color.dart';
import 'package:attendance_system/core/constant/app_typography.dart';
import 'package:attendance_system/core/widget/common_widget.dart';
import 'package:attendance_system/core/widget/custom_button.dart';
import 'package:attendance_system/provider/attendance_provider.dart';
import 'package:attendance_system/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constant/app_string.dart';
import '../model/attendance_model.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late List<Attendance> filteredAttendance;
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
      context.read<AttendanceProvider>().fetchAttendance();
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final orientation = MediaQuery.of(context).orientation;
    final isLandscape = orientation == Orientation.landscape;
    final isTablet = size.width >= 600;

    return Container(
      color: AppColors.primary,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.white,
          body: isTablet
              ? _buildTabletLayout(isLandscape)
              : _buildMobileLayout(isLandscape),
        ),
      ),
    );
  }
  Widget _buildMobileLayout(bool isLandscape) {
    return Column(
      children: [
        _appBar(),
        if (!isLandscape) _monthSelector(),
        IntrinsicHeight(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(top: 10,left: 10,bottom: 10),
                                    width: 4,
                                    decoration: BoxDecoration(
                                      color: AppColors.primary,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(vertical: 14, horizontal: 8),
                                      child: Text(AppString.historyTitle, style: AppTypography.getTextTheme(context).titleMedium?.copyWith(fontSize: 17),),
                                    ),
                                  ),
                                ],
                              ),
                            ),
        Expanded(
          child: isLandscape
              ? Row(
            children: [
              Container(
                width: 140,
                child: _monthSelector(),
              ),
              Expanded(child: _attendanceList()),
            ],
          )
              : _attendanceList(),
        ),
      ],
    );
  }
  Widget _buildTabletLayout(bool isLandscape) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ///  APP BAR
          _appBar(),
          SizedBox(height: 8),
          /// MONTH SELECTOR
          SizedBox(height: 75,
            child: _monthSelector(),
          ),
          SizedBox(height: 10),
          /// TITLE
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                Container(
                  width: 4,
                  height: 22,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                SizedBox(width: 8),
                Text(AppString.historyTitle, style: AppTypography.getTextTheme(context).titleMedium?.copyWith(fontSize: 17),),
              ],
            ),
          ),
          SizedBox(height: 10),
          /// ATTENDANCE LIST (IMPORTANT CHANGE)
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 10),
            itemCount:
            context.read<AttendanceProvider>().attendanceList.length,
            itemBuilder: (context, index) {
              final attendance = context.read<AttendanceProvider>().attendanceList[index];
              return _attendanceCard(attendance);
            },
          ),
        ],
      ),
    );
  }
  Widget _appBar() {
    final userProvider = context.read<UserProvider>();

    return CommonWidget.commonAppBarWidget(
      context: context,
      title:
      "${AppString.loginUserText} ${userProvider.name} (${userProvider.role})",
    );
  }
  Widget _monthSelector() {
    final provider = context.read<AttendanceProvider>();

    return  Container(
      margin: EdgeInsets.only(left: 5,right: 10,top: 15,bottom: 10),
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
                  color: isSelected ? AppColors.primary : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Colors.grey.shade300)
              ),
              child: Center(
                child: Text(
                    month["name"],
                    style: AppTypography.getTextTheme(context).titleSmall?.copyWith( color: isSelected ? Colors.white : AppColors.black,fontSize: 14.5)
                ),
              ),
            ),
          );
        },
      ),
    );
  }
  Widget _attendanceList() {
    return Consumer<AttendanceProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return Center(child: CircularProgressIndicator(color: AppColors.primary,));
        }
        if (provider.attendanceList.isEmpty) {
          return Center(child: Text("No Attendance records available",style: AppTypography.getTextTheme(context).bodyLarge?.copyWith(color: AppColors.grey),));
        }
        final isTablet = MediaQuery.of(context).size.width >= 600;

        return isTablet
            ? GridView.builder(
          padding: EdgeInsets.all(10),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            childAspectRatio: 2.5,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: provider.attendanceList.length,
          itemBuilder: (context, index) {
            return _attendanceCard(provider.attendanceList[index]);
          },
        )
            : ListView.builder(
          padding: EdgeInsets.all(10),
          itemCount: provider.attendanceList.length,
          itemBuilder: (context, index) {
            return _attendanceCard(provider.attendanceList[index]);
          },
        );
      },
    );
  }
  Widget _attendanceCard(attendance) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(5),
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
                  margin: EdgeInsets.only(top: 10),
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    borderRadius:
                    BorderRadius.circular(5),
                    border: Border.all(color: AppColors.primary),
                  ),
                  child: Icon(Icons.calendar_today, color: AppColors.primary),
                ),
                SizedBox(width: 10),
                Text(
                  '${attendance.date.day}/${attendance.date.month}/${attendance.date.year}',
                  style: AppTypography.getTextTheme(context).titleMedium?.copyWith(color: AppColors.black),),
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
                  Icon(Icons.access_time_outlined, color: Colors.white),
                  SizedBox(width: 3),
                  Text(attendance.totalHours, style: AppTypography.getTextTheme(context).titleSmall?.copyWith(color: Colors.white),),
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
  }
}

