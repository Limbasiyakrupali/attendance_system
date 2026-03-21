import 'dart:developer';

import 'package:attendance_system/services/api_service/api_helper.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {


  bool isLoading = false;
  Map<String, dynamic>? currentUser;

  Future<bool> createUser(Map<String, dynamic> body) async {
    isLoading = true;
    notifyListeners();

    try {
      await ApiHelper.apiHelper.post(
        "https://uptech-login.vercel.app/api/v1/users",
        body,
      );

      currentUser = body;
      log(currentUser.toString(),name: "======currentUser======");

      isLoading = false;
      notifyListeners();

      return true;

    } catch (e) {
      isLoading = false;
      notifyListeners();

      debugPrint("Create User Error: $e");
      return false;
    }
  }

  List<Map<String, dynamic>> userList = [];

  Future<void> getUsers() async {
    isLoading = true;
    notifyListeners();

    try {
      final response = await ApiHelper.apiHelper.get(
        "https://uptech-login.vercel.app/api/v1/users/details",
      );
      userList = List<Map<String, dynamic>>.from(response);

     log(userList.toString(),name: "======UserListtttt======");

    } catch (e) {
      debugPrint("Get Users Error: $e");
    }

    isLoading = false;
    notifyListeners();
  }
}