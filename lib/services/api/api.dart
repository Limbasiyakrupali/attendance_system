import 'package:flutter/material.dart';

class Api {

  /// ==================baseUrl=================
  static String baseUrl = "https://uptech-login.vercel.app/api/v1";

  /// ==================end point===============
  static String login = "$baseUrl/auth/login";
  static String logout = "$baseUrl/auth/logout";
  static String changePassword = "$baseUrl/profile/change-password";
  static String checkIn = "$baseUrl/attendance/check-in";
  static String checkOut = "$baseUrl/attendance/check-out";
  static String todayAttendance = "$baseUrl/attendance/today";
  static String totalUserDetailAttendance = "$baseUrl/users/details";

  static String userAttendance(String userId){
    return "/api/v1/users/$userId/attendance";
  }
}