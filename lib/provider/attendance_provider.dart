import 'dart:developer';

import 'package:flutter/cupertino.dart';
import '../model/attendance_model.dart';
import '../services/api_service/api_helper.dart';

class AttendanceProvider extends ChangeNotifier{
  bool isLoading = false;
  List<Attendance> attendanceList = [];
  List<Attendance> filteredAttendance = [];
  int selectedMonth = DateTime.now().month;

  Future<void> fetchAttendance() async {
   isLoading = true;
    notifyListeners();

    try {
      String month =
          "${DateTime.now().year}-${selectedMonth.toString().padLeft(2, '0')}";

      print("Calling API for month: $month");

      final response = await ApiHelper.apiHelper.get(
        "https://uptech-login.vercel.app/api/v1/attendance?month=$month",
      );

     log(response.toString(),name: "API RESPONSE:");

     attendanceList = (response as List)
          .map((e) => Attendance.fromJson(e))
          .toList();

    } catch (e, stackTrace) {
      print("ERROR: $e");
      print("STACK: $stackTrace");
    }

   isLoading = false;
    notifyListeners();
  }

  void filterAttendance() {
    filteredAttendance = attendanceList
        .where((a) => a.date.month == selectedMonth)
        .toList();
  }


}