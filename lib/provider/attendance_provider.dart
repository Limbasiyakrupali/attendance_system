import 'dart:async';
import 'dart:developer';

import 'package:attendance_system/core/constant/app_color.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../model/attendance_model.dart';
import '../services/api/api.dart';
import '../services/api_service/api_helper.dart';
import 'dashboard_provider.dart';

class AttendanceProvider extends ChangeNotifier{
  bool isLoading = false;
  List<Attendance> attendanceList = [];
  List<AttendanceModel> rawAttendanceList = [];
  List<Attendance> filteredAttendance = [];
  int selectedMonth = DateTime.now().month;
  int selectedYear = 2026;
  int presentDays = 0;
  int absentDays = 0;
  Duration totalDuration = Duration.zero;
  double avgHours = 0;

  void calculateStats() {
    presentDays = 0;
    totalDuration = Duration.zero;

    for (var item in rawAttendanceList) {

      /// FILTER (IMPORTANT)
      if (item.checkIn != null &&
          item.checkIn!.year == selectedYear &&
          item.checkIn!.month == selectedMonth) {

        presentDays++;

        /// SESSION 1
        if (item.checkIn != null && item.checkOut != null) {
          totalDuration += item.checkOut!.difference(item.checkIn!);
        }

        /// SESSION 2
        if (item.secondCheckIn != null &&
            item.secondCheckOut != null) {
          totalDuration += item.secondCheckOut!.difference(item.secondCheckIn!);
        }
      }
    }

    int daysInMonth =
    DateUtils.getDaysInMonth(selectedYear, selectedMonth);

    absentDays = daysInMonth - presentDays;

    /// EXACT AVG (NO ROUNDING ISSUE)
    avgHours = presentDays > 0
        ? totalDuration.inSeconds / presentDays / 3600
        : 0;

    notifyListeners();
  }


  Future<void> fetchAttendance() async {
   isLoading = true;
    notifyListeners();

    try {
      String month = "${DateTime.now().year}-${selectedMonth.toString().padLeft(2, '0')}";

      print("Calling API for month: $month");

      final response = await ApiHelper.apiHelper.get(
         "https://uptech-login.vercel.app/api/v1/attendance?month=$month",
      );

     // log(response.toString(),name: "API RESPONSE:");

     attendanceList = (response as List).map((e) => Attendance.fromJson(e)).toList();

     rawAttendanceList = (response).map((e) => AttendanceModel.fromJson(e)).toList();

      calculateStats();

    } catch (e, stackTrace) {
      print("ERROR: $e");
      print("STACK: $stackTrace");
    }

   isLoading = false;
    notifyListeners();
  }

  List<Map<String, dynamic>> attendanceListt = [];
  int totalEmployees = 0;
  int totalFreelancers = 0;
  int totalTrainees = 0;

  Future<void> getAttendance() async {
    isLoading = true;
    notifyListeners();

    try {
      final response = await ApiHelper.apiHelper.get(
        "https://uptech-login.vercel.app/api/v1/attendance/all",
      );

      attendanceListt = List<Map<String, dynamic>>.from(response);

      // log("attendanceListtattendanceListt:$attendanceListt");

    } catch (e) {
      // debugPrint("Attendance Error: $e");
    }

    isLoading = false;
    notifyListeners();
  }

  List<UserAttendanceModel> finalList = [];

  Timer? timer;

  Future<void> mergeData(BuildContext context) async {
    isLoading = true;
    notifyListeners();

    try {
      final dashboardProvider =
      Provider.of<DashboardProvider>(context, listen: false);

      final users = dashboardProvider.userDetailList;

      // Attendance API
      await getAttendance();

      finalList = dashboardProvider.userDetailList.map((user) {
        final match = attendanceListt.firstWhere(
              (att) => att['employee'] == user['fullName'],
          orElse: () => {},
        );

        return UserAttendanceModel(
          userId: user['userId'] ?? '',
          name: user['fullName'] ?? '',
          department: user['department'] ?? '',

          checkIn1: match['checkIn1']?.toString(),
          checkOut1: match['checkOut1']?.toString(),
          checkIn2: match['checkIn2']?.toString(),
          checkOut2: match['checkOut2']?.toString(),
        );
      }).toList();
    } catch (e) {
      print("Merge Error: $e");
    }

    isLoading = false;
    notifyListeners();
  }
  ///  Status Logic
  bool isToday(String? dateTime) {
    if (dateTime == null || dateTime.isEmpty) return false;

    try {
      final dt = DateTime.parse(dateTime).toLocal();
      final now = DateTime.now();

      return dt.year == now.year &&
          dt.month == now.month &&
          dt.day == now.day;
    } catch (e) {
      return false;
    }
  }
  // String getStatus(String? checkIn1) {
  //   if (checkIn1 == null || checkIn1.isEmpty) return "Absent";
  //
  //   try {
  //     final time = DateTime.parse(checkIn1).toLocal();
  //
  //     final lateTime = DateTime(
  //       time.year,
  //       time.month,
  //       time.day,
  //       9,
  //       15,
  //     );
  //
  //     return time.isAfter(lateTime) ? "Late" : "Present";
  //   } catch (e) {
  //     return "Absent";
  //   }
  // }
  String getStatus(String? checkIn1) {
    if (checkIn1 == null || checkIn1.isEmpty) return "Absent";

    return "Present";
  }

  String getCurrentStatus(UserAttendanceModel user) {
    final in1 = user.checkIn1;
    final out1 = user.checkOut1;
    final in2 = user.checkIn2;
    final out2 = user.checkOut2;

    if (!isToday(in1)) {
      return "Absent";
    }

    if (in1 != null && (out1 == null || out1.isEmpty)) {
      return "Working";
    }

    if (out1 != null && out1.isNotEmpty && (in2 == null || in2.isEmpty)) {
      return "Pause";
    }

    if (in2 != null && (out2 == null || out2.isEmpty)) {
      return "Working";
    }

    if (out2 != null && out2.isNotEmpty) {
      return "Complete";
    }

    return "Absent";
  }
  /// Status Color
  Color getStatusColor(String status) {
    switch (status) {
      case "Working":
        return AppColors.primary;
      case "Pause":
        return Colors.orange;
      case "Complete":
        return Colors.green;
      case "Absent":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

}