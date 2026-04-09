import 'package:attendance_system/provider/attendance_provider.dart';
import 'package:attendance_system/provider/dashboard_provider.dart';
import 'package:attendance_system/provider/user_provider.dart';
import 'package:attendance_system/provider/work_provider.dart';
import 'package:attendance_system/screen/add_user_screen.dart';
import 'package:attendance_system/screen/change_password.dart';
import 'package:attendance_system/screen/history_screen.dart';
import 'package:attendance_system/screen/login_screen.dart';
import 'package:attendance_system/screen/dashboard_screen.dart';
import 'package:attendance_system/screen/home_screen.dart';
import 'package:attendance_system/screen/profile_screen.dart';
import 'package:attendance_system/screen/show_user_list_screen.dart';
import 'package:attendance_system/screen/status_screen.dart';
import 'package:attendance_system/screen/total_users_detail_screens.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_)=> WorkProvider()),
      ChangeNotifierProvider(create: (_)=> AttendanceProvider()),
      ChangeNotifierProvider(create: (_)=> UserProvider()),
      ChangeNotifierProvider(create: (_)=> DashboardProvider()),
    ],
      child: const MyApp())
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        "/": (context) => LoginScreen(),
        "change_password": (context) => ChangePassword(),
        "/home": (context) => HomeScreen(),
        "dashboard": (context) => const DashboardScreen(),
        "status": (context) => const StatusScreen(),
        "profile": (context) => const ProfileScreen(),
        "history": (context) =>  HistoryScreen(),
        "add_user": (context) => const AddUserScreen(),
        "show_user": (context) => const ShowUserListScreen(),
        "total_users": (context) => const TotalUsersDetailScreens(),
      },
    );
  }
}
