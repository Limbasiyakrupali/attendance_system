import 'dart:convert';
import 'dart:developer';

import 'package:attendance_system/services/api_service/api_helper.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {


  bool isLoading = false;
  Map<String, dynamic>? currentUser;

  Map<String, dynamic>? _userData;
  Map<String,dynamic>? get userData => _userData;


  /// Getter for direct access
  String get name => _userData?['user']?['name'] ?? "";
  String get role => _userData?['user']?['role'] ?? "";
  String get userId => _userData?['user']?['id'] ?? "";
  String get userEmail => userData?['user']['email'] ?? "";

  /// Save full response
  void setUserData(Map<String, dynamic> data) {
    _userData = data;
    print("SETTING USER DATA ===== $data");

    notifyListeners();
  }

  /// Clear on logout
  void clearUser() {
    _userData = null;
    notifyListeners();
  }

  Future<bool> createUser(Map<String, dynamic> body) async {
    isLoading = true;
    notifyListeners();

    try {
      await ApiHelper.apiHelper.post(
        "https://uptech-login.vercel.app/api/v1/users",
        body,
      );

      currentUser = body;
      // log(currentUser.toString(),name: "======currentUser======");

      isLoading = false;
      notifyListeners();

      return true;

    } catch (e) {
      isLoading = false;
      notifyListeners();

      // debugPrint("Create User Error: $e");
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

     // log(userList.toString(),name: "======UserListtttt======");

    } catch (e) {
      // debugPrint("Get Users Error: $e");
    }

    isLoading = false;
    notifyListeners();
  }

  // Future<bool> updateUser(String userId, Map<String, dynamic> body) async {
  //   try {
  //     final res = await ApiHelper.apiHelper.put(
  //       "https://uptech-login.vercel.app/api/v1/users/$userId",
  //       body,
  //     );
  //     if (res["message"] == "User updated successfully") {
  //       return true;
  //     }
  //     return false;
  //   } catch (e) {
  //     print("Update Error: $e");
  //     return false;
  //   }
  // }

  // Update local user data (after API success)
  void updateLocalUser(Map<String, dynamic> updatedUser) {
    currentUser = updatedUser;
    notifyListeners();
  }

  Future<Map<String, dynamic>?> updateUser(String userId, Map<String, dynamic> body) async {
    try {
      final res = await ApiHelper.apiHelper.patch(
        "https://uptech-login.vercel.app/api/v1/users/$userId",
        body,
      );
      return res;
    } catch (e) {
      return null;
    }
  }
}