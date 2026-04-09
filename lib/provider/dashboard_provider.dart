
import 'dart:developer';

import 'package:attendance_system/services/api/api.dart';
import 'package:attendance_system/services/api_service/api_helper.dart';
import 'package:flutter/cupertino.dart';

class DashboardProvider extends ChangeNotifier{

  List<Map<String,dynamic>> userDetailList = [];
  bool isLoading = false;


  Future<void> getTotalUserDetail()async{
    isLoading = true;
    notifyListeners();

    try{
      final response = await ApiHelper.apiHelper.get(Api.totalUserDetailAttendance);
      // log(response.toString(),name: "==========userDetailList response===============");
      userDetailList = List<Map<String,dynamic>>.from(response);

      // log(userDetailList.toString(),name: "==========userDetailList===============");
    }catch(e){
      print("User Detail Error: $e");
    }
    isLoading = false;
    notifyListeners();
  }
  List<Map<String, dynamic>> filteredList = [];
  String selectedCategory = "All";

  void initializeData() {
    filteredList = userDetailList;
    notifyListeners();
  }

  void searchUser(String query) {
    if (query.isEmpty) {
      filteredList = _applyCategory(userDetailList);
    } else {
      filteredList = _applyCategory(userDetailList).where((user) {
        final name = user["fullName"]?.toLowerCase() ?? "";
        return name.contains(query.toLowerCase());
      }).toList();
    }
    notifyListeners();
  }

  void filterCategory(String category) {
    selectedCategory = category;
    filteredList = _applyCategory(userDetailList);
    notifyListeners();
  }

  List<Map<String, dynamic>> _applyCategory(List<Map<String, dynamic>> list) {
    if (selectedCategory == "All") return list;

    return list.where((user) {
      return user["department"] == selectedCategory;
    }).toList();
  }
  List<String> get categories {
    final deptList = userDetailList
        .map((e) => e["department"].toString())
        .toSet()
        .toList();

    return ["All", ...deptList];
  }
}