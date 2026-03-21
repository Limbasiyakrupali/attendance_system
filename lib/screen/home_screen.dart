import 'package:attendance_system/core/constant/app_color.dart';
import 'package:attendance_system/core/constant/app_typography.dart';
import 'package:attendance_system/provider/attendance_provider.dart';
import 'package:attendance_system/screen/add_user_screen.dart';
import 'package:attendance_system/screen/dashboard_screen.dart';
import 'package:attendance_system/screen/history_screen.dart';
import 'package:attendance_system/screen/show_user_list_screen.dart';
import 'package:attendance_system/screen/status_screen.dart';
import 'package:attendance_system/services/api_service/token_service.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/work_provider.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PageController pageController = PageController();
  int currentIndex = 0;
  String role = "";
  List<Widget> pages = [];
  List<BottomNavigationBarItem> navItems = [];

  @override
  void initState() {
    print("=============================");
    // TODO: implement initState
    super.initState();
    loadRole();
    Future.microtask(() {
      Provider.of<WorkProvider>(context, listen: false)
          .loadTodayAttendance();
      // Provider.of<AttendanceProvider>(context,listen: false).filterAttendance();
    });
  }

  Future<void> loadRole()async{
   role =  await TokenService.getRole() ?? '';
   setUpNavigation();
   setState(() {});
  }

  void setUpNavigation(){

    pages = [
      DashboardScreen(),
      StatusScreen(),
      ProfileScreen(),
      HistoryScreen(),
    ];

    navItems = [
      BottomNavigationBarItem(
          label: "Home",
          icon: buildIcon(FeatherIcons.home,0)
      ),
      BottomNavigationBarItem(
          label: "Status",
          icon: buildIcon(FeatherIcons.barChart,1)
      ),
      BottomNavigationBarItem(
          label: "Profile",
          icon: buildIcon(FeatherIcons.user,2)
      ),
      BottomNavigationBarItem(
          label: "History",
          icon: buildIcon(Icons.history,3)
      ),
    ];

    /// ADMIN ke liye extra tab
    if(role == 'ADMIN' || role == 'HR'){

      // pages.add(AddUserScreen());
      pages.add(ShowUserListScreen());

      navItems.add(
        BottomNavigationBarItem(
          label: "User",
          icon: buildIcon(FeatherIcons.userPlus,4),
        ),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    if(navItems.isEmpty){
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      backgroundColor: AppColors.white,
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashFactory: NoSplash.splashFactory,
          highlightColor: Colors.transparent,),
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          elevation: 0,
          currentIndex: currentIndex,
          onTap: (index) {
            setState(() {
              currentIndex = index;
              pageController.jumpToPage(index);
            });
          },
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppColors.primary,
          unselectedItemColor:AppColors.primary,
          unselectedFontSize: 15,
          iconSize: 25,
          selectedLabelStyle: AppTypography.getTextTheme(context).titleSmall?.copyWith(fontSize: 13),
          unselectedLabelStyle: AppTypography.getTextTheme(context).titleSmall?.copyWith(fontSize: 13),
          items: [

            BottomNavigationBarItem(
              label: "Home",
              icon: buildIcon(FeatherIcons.home,0),
            ),

            BottomNavigationBarItem(
              label: "Status",
              icon: buildIcon(FeatherIcons.barChart,1),
            ),

            BottomNavigationBarItem(
              label: "Profile",
              icon: buildIcon(FeatherIcons.user,2),
            ),

            BottomNavigationBarItem(
              label: "History",
              icon: buildIcon(Icons.history,3),
            ),

            if(role == "ADMIN" || role == 'HR')
              BottomNavigationBarItem(
                label: "User",
                icon: buildIcon(FeatherIcons.userPlus,4),
              ),
          ],
        ),
      ),
      body: PageView(
        controller: pageController,
        onPageChanged: (int index){
          setState(() {
            currentIndex = index;
          });
        },
        children: pages,
      ),
    );
  }
  Widget buildIcon(IconData icon,int index){

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: currentIndex == index
            ? AppColors.primary
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        icon,
        color: currentIndex == index
            ? Colors.white
            : AppColors.primary,
      ),
    );
  }

}
