// // import 'package:attendance_system/services/api/api.dart';
// // import 'package:attendance_system/services/api_service/api_helper.dart';
// // import 'package:flutter/material.dart';
// // import '../model/attendance_model.dart';
// // import '../model/work_session_model.dart';
// //
// // enum AttendanceStatus {
// //   firstCheckIn,
// //   firstCheckOut,
// //   secondCheckIn,
// //   secondCheckOut,
// //   completed
// // }
// //
// // class WorkProvider extends ChangeNotifier {
// //   // DateTime? _checkInTime;
// //   final List<WorkSession> _sessions = [];
// //
// //   // DateTime? get checkInTime => _checkInTime;
// //
// //   List<WorkSession> get sessions => _sessions;
// //   AttendanceModel? attendance;
// //
// //   DateTime? get firstCheckIn => attendance?.checkIn;
// //   DateTime? get firstCheckOut => attendance?.checkOut;
// //   DateTime? get secondCheckIn => attendance?.checkIn2;
// //   DateTime? get secondCheckOut => attendance?.checkOut2;
// //
// //   /// CHECK IN
// //   Future<void> checkIn() async {
// //     try {
// //
// //       final response = await ApiHelper.apiHelper.post(Api.checkIn, {});
// //
// //       attendance = AttendanceModel.fromJson(response['attendance']);
// //
// //       notifyListeners();
// //
// //     } catch (e) {
// //       print("CheckIn Error $e");
// //     }
// //   }
// //
// //   /// CHECK OUT
// //   Future<void> checkOut() async {
// //     try {
// //
// //       final response = await ApiHelper.apiHelper.post(Api.checkOut, {});
// //
// //       attendance = AttendanceModel.fromJson(response['attendance']);
// //
// //       notifyListeners();
// //
// //     } catch (e) {
// //       print("CheckOut Error $e");
// //     }
// //   }
// //
// //   AttendanceStatus getStatus(String userId) {
// //     final fIn  = firstCheckIn[userId];
// //     final fOut = firstCheckOut[userId];
// //     final sIn  = secondCheckIn[userId];
// //     final sOut = secondCheckOut[userId];
// //
// //     if (fIn == null) {
// //       return AttendanceStatus.firstCheckIn;
// //     }
// //     if (fIn != null && fOut == null) {
// //       return AttendanceStatus.firstCheckOut;
// //     }
// //     if (fOut != null && sIn == null) {
// //       return AttendanceStatus.secondCheckIn;
// //     }
// //     if (sIn != null && sOut == null) {
// //       return AttendanceStatus.secondCheckOut;
// //     }
// //     return AttendanceStatus.completed;
// //   }
// //   /// TOTAL HOURS
// //   Duration get totalDuration {
// //     return _sessions.fold(
// //         Duration.zero,
// //             (previousValue, element) =>
// //         previousValue + element.duration);
// //   }
// //
// //   /// DAYS WORKED
// //   int get daysWorked => _sessions.length;
// //
// //   /// AVG DAILY HOURS
// //   Duration get avgDaily {
// //     if (_sessions.isEmpty) return Duration.zero;
// //
// //     return Duration(
// //         minutes: totalDuration.inMinutes ~/ _sessions.length);
// //   }
// //
// // }
// import 'package:attendance_system/services/api/api.dart';
// import 'package:attendance_system/services/api_service/api_helper.dart';
// import 'package:flutter/material.dart';
// import '../model/attendance_model.dart';
// import '../model/work_session_model.dart';
//
// enum AttendanceStatus {
//   firstCheckIn,
//   firstCheckOut,
//   secondCheckIn,
//   secondCheckOut,
//   completed
// }
//
// class WorkProvider extends ChangeNotifier {
//
//   final List<WorkSession> _sessions = [];
//
//   List<WorkSession> get sessions => _sessions;
//
//   // AttendanceModel? attendance;
//   //
//   // DateTime? firstCheckIn;
//   // DateTime? firstCheckOut;
//   // DateTime? secondCheckIn;
//   // DateTime? secondCheckOut;
//   //
//   // AttendanceStatus status = AttendanceStatus.firstCheckIn;
//   //
//   // String buttonText = "CHECK IN";
//   //
//   // /// Load today attendance
//   // // Future<void> loadTodayAttendance() async {
//   // //
//   // //   final response =
//   // //   await ApiHelper.apiHelper.get(Api.todayAttendance);
//   // //
//   // //   print("response loadAttendance===============${response.toString()}");
//   // //
//   // //   attendance = AttendanceModel.fromJson(response);
//   // //
//   // //   firstCheckIn = attendance?.checkIn;
//   // //   firstCheckOut = attendance?.checkOut;
//   // //   secondCheckIn = attendance?.checkIn2;
//   // //   secondCheckOut = attendance?.checkOut2;
//   // //
//   // //   updateStatus();
//   // //
//   // //   notifyListeners();
//   // // }
//   //
//   // Future<void> loadTodayAttendance() async {
//   //
//   //   final res = await ApiHelper.apiHelper.get(Api.todayAttendance);
//   //
//   //   firstCheckIn = res["checkIn"] != null
//   //       ? DateTime.parse(res["checkIn"])
//   //       : null;
//   //
//   //   firstCheckOut = res["checkOut"] != null
//   //       ? DateTime.parse(res["checkOut"])
//   //       : null;
//   //
//   //   secondCheckIn = res["checkIn2"] != null
//   //       ? DateTime.parse(res["checkIn2"])
//   //       : null;
//   //
//   //
//   //   secondCheckOut = res["checkOut2"] != null
//   //       ? DateTime.parse(res["checkOut2"])
//   //       : null;
//   //
//   //   print("TODAY ATTENDANCE API RESPONSE: ${res}");
//   //
//   //   updateStatus();
//   //
//   //   notifyListeners();
//   // }
//   //
//   // /// Decide button state
//   // // void updateStatus(){
//   // //
//   // //   if(firstCheckIn == null){
//   // //     status = AttendanceStatus.firstCheckIn;
//   // //     buttonText = "CHECK IN";
//   // //   }
//   // //   else if(firstCheckOut == null){
//   // //     status = AttendanceStatus.firstCheckOut;
//   // //     buttonText = "CHECK OUT";
//   // //   }
//   // //   else if(secondCheckIn == null){
//   // //     status = AttendanceStatus.secondCheckIn;
//   // //     buttonText = "SECOND CHECK IN";
//   // //   }
//   // //   else if(secondCheckOut == null){
//   // //     status = AttendanceStatus.secondCheckOut;
//   // //     buttonText = "SECOND CHECK OUT";
//   // //   }
//   // //   else{
//   // //     status = AttendanceStatus.completed;
//   // //     buttonText = "DAY COMPLETED";
//   // //   }
//   // // }
//   //
//   // void updateStatus(){
//   //
//   //   if(firstCheckIn == null){
//   //     status = AttendanceStatus.firstCheckIn;
//   //   }
//   //
//   //   else if(firstCheckOut == null){
//   //     status = AttendanceStatus.firstCheckOut;
//   //   }
//   //
//   //   else if(secondCheckIn == null){
//   //     status = AttendanceStatus.secondCheckIn;
//   //   }
//   //
//   //   else if(secondCheckOut == null){
//   //     status = AttendanceStatus.secondCheckOut;
//   //   }
//   //
//   //   else{
//   //     status = AttendanceStatus.completed;
//   //   }
//   //
//   // }
//   //
//   // /// Button click handler
//   // Future<void> handleAttendance() async {
//   //   try{
//   //     if(status == AttendanceStatus.firstCheckIn ||
//   //         status == AttendanceStatus.secondCheckIn){
//   //       await ApiHelper.apiHelper.post(Api.checkIn,{});
//   //     } else{
//   //       await ApiHelper.apiHelper.post(Api.checkOut,{});
//   //     }
//   //     await loadTodayAttendance();
//   //   }catch(e){
//   //     print(e);
//   //   }
//   // }
//   // Future<void> checkIn() async {
//   //
//   //   await ApiHelper.apiHelper.post(Api.checkIn,{});
//   //
//   //   await loadTodayAttendance();
//   // }
//   // Future<void> checkOut() async {
//   //
//   //   await ApiHelper.apiHelper.post(Api.checkOut,{});
//   //
//   //   await loadTodayAttendance();
//   // }
//
//   DateTime? firstCheckIn;
//   DateTime? firstCheckOut;
//   DateTime? secondCheckIn;
//   DateTime? secondCheckOut;
//
//   AttendanceStatus status = AttendanceStatus.firstCheckIn;
//
//   String get buttonText {
//     switch(status){
//       case AttendanceStatus.firstCheckIn:
//         return "CHECK IN";
//
//       case AttendanceStatus.firstCheckOut:
//         return "CHECK OUT";
//
//       case AttendanceStatus.secondCheckIn:
//         return "SECOND CHECK IN";
//
//       case AttendanceStatus.secondCheckOut:
//         return "SECOND CHECK OUT";
//
//       case AttendanceStatus.completed:
//         return "DAY COMPLETED";
//     }
//   }
//
//   /// Load today attendance
//   Future<void> loadTodayAttendance() async {
//
//     final res = await ApiHelper.apiHelper.get(Api.todayAttendance);
//
//     print("TODAY ATTENDANCE API RESPONSE: $res");
//
//     AttendanceModel attendance = AttendanceModel.fromJson(res);
//
//     firstCheckIn = attendance.checkIn;
//     firstCheckOut = attendance.checkOut;
//     secondCheckIn = attendance.checkIn2;
//     secondCheckOut = attendance.checkOut2;
//
//     _updateStatus();
//
//     notifyListeners();
//   }
//
//   /// Update button state
//   void _updateStatus(){
//
//     if(firstCheckIn == null){
//       status = AttendanceStatus.firstCheckIn;
//
//     } else if(firstCheckOut == null){
//       status = AttendanceStatus.firstCheckOut;
//
//     } else if(secondCheckIn == null){
//       status = AttendanceStatus.secondCheckIn;
//
//     } else if(secondCheckOut == null){
//       status = AttendanceStatus.secondCheckOut;
//
//     } else {
//       status = AttendanceStatus.completed;
//     }
//   }
//
//   /// Handle button press
//   Future<void> handleAttendance() async {
//     try {
//
//       if(status == AttendanceStatus.firstCheckIn ||
//           status == AttendanceStatus.secondCheckIn){
//
//         await ApiHelper.apiHelper.post(Api.checkIn,{});
//
//       } else {
//
//         await ApiHelper.apiHelper.post(Api.checkOut,{});
//
//       }
//
//       /// Refresh data after action
//       await loadTodayAttendance();
//
//     } catch(e){
//
//       print("Attendance error: $e");
//
//       /// Agar backend bole already completed
//       await loadTodayAttendance();
//     }
//   }
//
//   // Future<void> checkIn() async {
//   //   try {
//   //
//   //     final response = await ApiHelper.apiHelper.post(Api.checkIn, {});
//   //
//   //     attendance = AttendanceModel.fromJson(response['attendance']);
//   //
//   //     notifyListeners();
//   //
//   //   } catch (e) {
//   //     print("CheckIn Error $e");
//   //   }
//   // }
//   //
//   // /// CHECK OUT API
//   // Future<void> checkOut() async {
//   //   try {
//   //
//   //     final response = await ApiHelper.apiHelper.post(Api.checkOut, {});
//   //
//   //     attendance = AttendanceModel.fromJson(response['attendance']);
//   //
//   //     notifyListeners();
//   //
//   //   } catch (e) {
//   //     print("CheckOut Error $e");
//   //   }
//   // }
//   //
//   // /// STATUS LOGIC
//   // AttendanceStatus get status {
//   //
//   //   if (attendance?.checkIn == null) {
//   //     return AttendanceStatus.firstCheckIn;
//   //   }
//   //
//   //   if (attendance?.checkIn != null && attendance?.checkOut == null) {
//   //     return AttendanceStatus.firstCheckOut;
//   //   }
//   //
//   //   if (attendance?.checkOut != null && attendance?.checkIn2 == null) {
//   //     return AttendanceStatus.secondCheckIn;
//   //   }
//   //
//   //   if (attendance?.checkIn2 != null && attendance?.checkOut2 == null) {
//   //     return AttendanceStatus.secondCheckOut;
//   //   }
//   //
//   //   return AttendanceStatus.completed;
//   // }
//   //
//   // /// BUTTON TEXT
//   // String get buttonText {
//   //
//   //   switch (status) {
//   //     case AttendanceStatus.firstCheckIn:
//   //       return "CHECK IN (FIRST HALF)";
//   //
//   //     case AttendanceStatus.firstCheckOut:
//   //       return "CHECK OUT (FIRST HALF)";
//   //
//   //     case AttendanceStatus.secondCheckIn:
//   //       return "CHECK IN (SECOND HALF)";
//   //
//   //     case AttendanceStatus.secondCheckOut:
//   //       return "CHECK OUT (SECOND HALF)";
//   //
//   //     case AttendanceStatus.completed:
//   //       return "DAY COMPLETED";
//   //   }
//   // }
//   //
//   // /// BUTTON ACTION
//   // Future<void> handleAttendance() async {
//   //
//   //   if (status == AttendanceStatus.firstCheckIn ||
//   //       status == AttendanceStatus.secondCheckIn) {
//   //
//   //     await checkIn();
//   //
//   //   } else if (status == AttendanceStatus.firstCheckOut ||
//   //       status == AttendanceStatus.secondCheckOut) {
//   //
//   //     await checkOut();
//   //   }
//   // }
//   //
//   // /// LOAD TODAY ATTENDANCE
//   // Future<void> loadTodayAttendance() async {
//   //   try {
//   //     final response = await ApiHelper.apiHelper.get(Api.todayAttendance);
//   //
//   //     print("Attendance Response==========$response");
//   //
//   //     attendance = AttendanceModel.fromJson(response);
//   //
//   //     print("attendance: ${attendance?.checkIn}");
//   //     print("attendance: ${attendance?.checkOut}");
//   //     print("attendance: ${attendance?.checkIn2}");
//   //     print("attendance: ${attendance?.checkOut2}");
//   //
//   //     notifyListeners();
//   //
//   //   } catch (e) {
//   //     print("Today Attendance Error: $e");
//   //   }
//   // }
//
//   /// TOTAL HOURS
//   Duration get totalDuration {
//     return _sessions.fold(
//         Duration.zero, (previousValue, element) => previousValue + element.duration);
//   }
//
//   /// DAYS WORKED
//   int get daysWorked => _sessions.length;
//
//   /// AVG DAILY HOURS
//   Duration get avgDaily {
//
//     if (_sessions.isEmpty) return Duration.zero;
//
//     return Duration(
//         minutes: totalDuration.inMinutes ~/ _sessions.length);
//   }
//
// }
import 'package:attendance_system/model/attendance_model.dart';
import 'package:attendance_system/model/work_session_model.dart';
import 'package:attendance_system/services/api/api.dart';
import 'package:attendance_system/services/api_service/api_helper.dart';
import 'package:flutter/material.dart';

enum AttendanceStatus{
  firstCheckIn,
  firstCheckOut,
  secondCheckIn,
  secondCheckOut,
  completed,
}

enum AttendanceBtnStatus {
  notCheckedIn,
  firstCheckIn,
  firstCheckOut,
  secondCheckIn,
  secondCheckOut,
}

class WorkProvider extends ChangeNotifier{
  final List<WorkSession> _sessions = [];

  List<WorkSession> get sessions => _sessions;

  AttendanceStatus status = AttendanceStatus.firstCheckIn;

  String get buttonText{
    switch(status){
      case AttendanceStatus.firstCheckIn:
      return "CHECK IN";

      case AttendanceStatus.firstCheckOut:
        return "CHECK OUT";

      case AttendanceStatus.secondCheckIn:
        return "SECOND CHECK IN";

      case AttendanceStatus.secondCheckOut:
        return "SECOND CHECK OUT";

      case AttendanceStatus.completed:
        return "DAY COMPLETE";
    }
}

AttendanceBtnStatus btnStatus = AttendanceBtnStatus.notCheckedIn;

// String get attendanceStatus{
//     switch(btnStatus){
//       case AttendanceBtnStatus.firstCheckIn:
//         return "CHECKED IN (FIRST HALF)";
//
//       case AttendanceBtnStatus.firstCheckOut:
//         return "CHECKED OUT (FIRST HALF)";
//
//       case AttendanceBtnStatus.secondCheckIn:
//         return "CHECKED IN (SECOND HALF)";
//
//       case AttendanceBtnStatus.secondCheckOut:
//         return "DAY COMPLETED";
//     }
// }
  String get attendanceStatus {
    switch (btnStatus) {
      case AttendanceBtnStatus.notCheckedIn:
        return "NOT CHECKED IN";

      case AttendanceBtnStatus.firstCheckIn:
        return "CHECKED IN (FIRST HALF)";

      case AttendanceBtnStatus.firstCheckOut:
        return "CHECKED OUT (FIRST HALF)";

      case AttendanceBtnStatus.secondCheckIn:
        return "CHECKED IN (SECOND HALF)";

      case AttendanceBtnStatus.secondCheckOut:
        return "DAY COMPLETED";
    }
  }

  DateTime? firstCheckIn;
  DateTime? firstCheckOut;
  DateTime? secondCheckIn;
  DateTime? secondCheckOut;


    Future<void> loadTodayAttendance()async{
  final response = await ApiHelper.apiHelper.get(Api.todayAttendance);

  // log(response.toString(),name: "=============TODAY'S ATTENDANCE RESPONSE==========");

  AttendanceModel attendanceModel = AttendanceModel.fromJson(response);

  firstCheckIn = attendanceModel.checkIn;
  firstCheckOut = attendanceModel.checkOut;
  secondCheckIn = attendanceModel.secondCheckIn;
  secondCheckOut = attendanceModel.secondCheckOut;

  updateStatus();

  notifyListeners();

  }

  Future<void> updateStatus() async {

    /// NEW CONDITION
    if (firstCheckIn == null) {
      status = AttendanceStatus.firstCheckIn;
      btnStatus = AttendanceBtnStatus.notCheckedIn;
    }

    else if (firstCheckOut == null) {
      status = AttendanceStatus.firstCheckOut;
      btnStatus = AttendanceBtnStatus.firstCheckIn;
    }

    else if (secondCheckIn == null) {
      status = AttendanceStatus.secondCheckIn;
      btnStatus = AttendanceBtnStatus.firstCheckOut;
    }

    else if (secondCheckOut == null) {
      status = AttendanceStatus.secondCheckOut;
      btnStatus = AttendanceBtnStatus.secondCheckIn;
    }

    else {
      status = AttendanceStatus.completed;
      btnStatus = AttendanceBtnStatus.secondCheckOut;
    }
  }

  Future<void> handleAttendance()async{
   try{
     switch(status){
       case AttendanceStatus.firstCheckIn:
         await ApiHelper.apiHelper.post(Api.checkIn, {});
         btnStatus = AttendanceBtnStatus.firstCheckIn;

       case AttendanceStatus.firstCheckOut:
         await ApiHelper.apiHelper.post(Api.checkOut, {});
         btnStatus = AttendanceBtnStatus.firstCheckOut;

       case AttendanceStatus.secondCheckIn:
         await ApiHelper.apiHelper.post(Api.checkIn, {});
         btnStatus = AttendanceBtnStatus.secondCheckIn;

       case AttendanceStatus.secondCheckOut:
         btnStatus = AttendanceBtnStatus.secondCheckOut;

       case AttendanceStatus.completed:
          return;
     }
     await loadTodayAttendance();
     notifyListeners();
   } catch(e){
     throw Exception("ATTENDANCE ERROR: $e");
   }
  }

}