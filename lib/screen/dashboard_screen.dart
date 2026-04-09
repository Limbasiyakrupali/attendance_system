import 'dart:async';
import 'dart:developer';
import 'package:attendance_system/core/constant/app_color.dart';
import 'package:attendance_system/core/constant/app_string.dart';
import 'package:attendance_system/core/widget/common_widget.dart';
import 'package:attendance_system/provider/user_provider.dart';
import 'package:attendance_system/provider/work_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../core/constant/app_typography.dart';
import '../core/widget/custom_button.dart';
import 'package:feather_icons/feather_icons.dart';

import '../provider/attendance_provider.dart';
import '../provider/dashboard_provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  DateTime now = DateTime.now();
  Timer? timer;
  String selectedRole = "All Roles";
  String selectedEmployee = "All Employees";
  String selectedMonth = "All Months";

  List<Map<String, dynamic>> getFilteredData(List<Map<String, dynamic>> data) {
    return data.where((item) {
      /// ROLE FILTER
      final roleMatch = selectedRole == "All Roles" ||
          item['role'] == selectedRole;

      /// EMPLOYEE FILTER
      final employeeMatch = selectedEmployee == "All Employees" ||
          item['employee'] == selectedEmployee;

      /// MONTH FILTER
      bool monthMatch = true;

      if (selectedMonth != "All Months") {
        try {
          DateTime date = DateTime.parse(item['date']);

          int selectedMonthIndex = [
            "January","February","March","April","May","June",
            "July","August","September","October","November","December"
          ].indexOf(selectedMonth) + 1;

          monthMatch = date.month == selectedMonthIndex;
        } catch (e) {
          monthMatch = false;
        }
      }

      return roleMatch && employeeMatch && monthMatch;

    }).toList();
  }

  Map<String, int> getRoleCounts(List<Map<String, dynamic>> data) {
    Set<String> employeeSet = {};
    Set<String> traineeSet = {};
    Set<String> hrSet = {};
    Set<String> freelancerSet = {};
    Set<String> partnerSet = {}; // ✅ New role
    Set<String> totalUsersSet = {};

    for (var e in data) {
      String role = (e['role'] ?? "").toString().toLowerCase().trim();
      String name = (e['employee'] ?? "").toString();

      // ❌ Skip admin
      if (role == "admin") continue;

      // ✅ Total users (without admin)
      totalUsersSet.add(name);

      if (role == "employee") {
        employeeSet.add(name);
      } else if (role == "trainee") {
        traineeSet.add(name);
      } else if (role == "hr") {
        hrSet.add(name);
      } else if (role == "freelance") {
        freelancerSet.add(name);
      } else if (role == "partner") { // ✅ Count partners
        partnerSet.add(name);
      }
    }

    return {
      "total": totalUsersSet.length,
      "employee": employeeSet.length,
      "trainee": traineeSet.length,
      "hr": hrSet.length,
      "freelancer": freelancerSet.length,
      "partner": partnerSet.length, // ✅ Include in result
    };
  }

  @override
  void initState() {
    super.initState();
    /// Live clock update every second
    Future.microtask((){
      context.read<DashboardProvider>().getTotalUserDetail();
      context.read<AttendanceProvider>().getAttendance();
      Provider.of<AttendanceProvider>(context, listen: false)
          .mergeData(context);
    });
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        now = DateTime.now();
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final orientation = MediaQuery.of(context).orientation;
    final isLandscape = orientation == Orientation.landscape;
    final isTablet = size.width >= 600;
    final workProvider = context.read<WorkProvider>();
    final userProvider = context.read<UserProvider>();
    final attendanceProvider = context.read<AttendanceProvider>();
    final Map<String,dynamic> user = ModalRoute.of(context)!.settings.arguments as Map<String,dynamic>;
    return Container(
      color: AppColors.primary,
      child: SafeArea(
        bottom: false,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            children: [
              /// App Bar
              CommonWidget.commonAppBarWidget(context: context, title: "${AppString.loginUserText} ${userProvider.name} (${userProvider.role})"),
              SizedBox(height: isTablet ? 16 : 8),
              /// BODY
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isTablet ? 20 : 12,
                  ),
                  child: user['user']['role'] != "ADMIN"
                      ? _employeeView(context, attendanceProvider, isTablet)
                      : _adminView(context, isTablet),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  String formatTime(String? time) {
    if (time == null || time.isEmpty) return "--";

    try {
      final utcTime = DateTime.parse(time);
      final localTime = utcTime.toLocal(); // 🔥 IMPORTANT
      return DateFormat("hh:mm a").format(localTime);
    } catch (e) {
      return "--";
    }
  }
  Widget buildStatusTag(String status) {
    final provider = Provider.of<AttendanceProvider>(context);
    final color = provider.getStatusColor(status);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color),
      ),

      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [

          /// 🔵 Blinking Dot
          if (status == "Working") ...[
            BlinkingDot(color: color, size: 8),
            SizedBox(width: 6),
          ],

          Text(
            status,
            style: AppTypography.getTextTheme(context).bodyLarge?.copyWith(color: color,fontSize: 14)
          ),
        ],
      ),
    );
  }

/// ================= EMPLOYEE VIEW =================
  Widget _employeeView(
      BuildContext context, AttendanceProvider attendanceProvider, bool isTablet) {

    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    Widget content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 8),
                width: 4,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                  child: Text(
                    AppString.dashBoardTitle,
                    style: AppTypography.getTextTheme(context)
                        .titleMedium
                        ?.copyWith(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),

        /// ✅ DROPDOWN KO NICHE LE AO
        SizedBox(height: 25),

        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<int>(
                value: attendanceProvider.selectedYear,
                isExpanded: true,
                decoration: InputDecoration(
                  labelText: "Filter by year",
                  labelStyle: AppTypography.getTextTheme(context).bodySmall,
                  contentPadding: EdgeInsets.symmetric(horizontal: 5, vertical: 15),
                  border: OutlineInputBorder(),
                ),
                  items: List.generate(100, (index) {
                    int year = 2026 + index;
                    return DropdownMenuItem(
                      value: year,
                      child: Text(year.toString()),
                    );
                  }),
                onChanged: (value) async{
                  attendanceProvider.selectedYear = value!;
                  await attendanceProvider.fetchAttendance();
                  attendanceProvider.calculateStats();
                },


              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: DropdownButtonFormField(
                  value: attendanceProvider.selectedMonth,
                  isExpanded: true,
                  decoration: InputDecoration(
                    labelText: "Filter by month",
                    labelStyle: AppTypography.getTextTheme(context).bodySmall,
                    contentPadding: EdgeInsets.symmetric(horizontal: 5, vertical: 15),
                    border: OutlineInputBorder(),
                  ),
                    items: List.generate(12, (index) {
                    return DropdownMenuItem(
                    value: index + 1,
                    child: Text(_getMonthName(index + 1)),
                    );
                    }),
                onChanged: (value) async{
                attendanceProvider.selectedMonth = value!;
                await attendanceProvider.fetchAttendance();
                attendanceProvider.calculateStats();
                },
              ),
            ),
          ],
        ),
        SizedBox(height: 18),

        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          childAspectRatio: isTablet ? 2.4 : 1.2,
          crossAxisSpacing: 10,
          children: [

            /// ✅ Present Days
            _buildCard(
              context: context,
              title: "Present Days",
              value: attendanceProvider.presentDays.toString(),
              progress: attendanceProvider.presentDays / 30,
              isTablet: isTablet,
            ),

            /// ❌ Absent Days
            _buildCard(
              context: context,
              title: "Absent Days",
              value: attendanceProvider.absentDays.toString(),
              progress: attendanceProvider.absentDays / 30,
              isTablet: isTablet,
            ),

            /// ⏱ Total Hours
            _buildCard(
              context: context,
              title: "Total Hours",
              value: _formatDuration(attendanceProvider.totalDuration),
              progress: attendanceProvider.totalDuration.inHours / 160,
              isTablet: isTablet,
            ),

            /// 📊 Avg Hours
            _buildCard(
              context: context,
              title: "Avg Hours",
              value: "${attendanceProvider.avgHours.toStringAsFixed(1)} h",
              progress: attendanceProvider.avgHours / 8,
              isTablet: isTablet,
            ),
          ],
        ),
        SizedBox(height: 15),

        Text(
          "Today's Status",
          style: AppTypography.getTextTheme(context)
              .titleSmall
              ?.copyWith(fontSize: isTablet ? 18 : 16),
        ),

        SizedBox(height: 12),

        Consumer<WorkProvider>(
          builder: (context, provider, _) {
            return CommonWidget.commonStatusButton(
              context: context,
              height: isTablet ? 60 : 50,
              width: double.infinity,
              color: Colors.green.shade50,
              icon: FeatherIcons.clock,
              iconColor: Colors.green,
              borderColor: Colors.green,
              buttonTitle: provider.attendanceStatus,
              stringTextColor: Colors.green,
              iconSize: isTablet ? 22 : 18,
            );
          },
        ),
      ],
    );

    /// ✅ FINAL RETURN (WITHOUT CONTAINER)
    return isLandscape
        ? SizedBox(
      height: MediaQuery.of(context).size.height * 0.8,
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: content,
      ),
    )
        : SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: content,
    );
  }
  String _formatDuration(Duration d) {
    int totalMinutes = (d.inSeconds / 60).round(); // 🔥 ROUND

    int h = totalMinutes ~/ 60;
    int m = totalMinutes % 60;

    return "${h}h ${m}m";
  }
  String _getMonthName(int month) {
    const months = [
      "January","February","March","April","May","June",
      "July","August","September","October","November","December"
    ];
    return months[month - 1];
  }
/// ================= ADMIN VIEW =================

  Widget _adminView(BuildContext context, bool isTablet) {
    final attendanceProvider = context.read<AttendanceProvider>();

    final filtered = getFilteredData(attendanceProvider.attendanceListt);
    final counts = getRoleCounts(filtered);

    final total = counts['total'] ?? 0;
    final employee = counts['employee'] ?? 0;
    final freelancer = counts['freelancer'] ?? 0;
    final trainee = counts['trainee'] ?? 0;
    final partner = counts['partner'] ?? 0;
    final hr = counts['hr'] ?? 0;

    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// TITLE
          IntrinsicHeight(
            child: Padding(
              padding: EdgeInsets.only(left: 5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    width: 4,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 8,
                      ),
                      child: Text(
                        AppString.dashBoardTitle,
                        style: AppTypography.getTextTheme(context)
                            .titleMedium
                            ?.copyWith(
                          fontSize: isTablet ? 20 : 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // SizedBox(height: 5),

          /// GRID CARDS (WITH PROGRESS)
          GridView.count(
            crossAxisCount: isTablet ? 2 : 2,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            childAspectRatio: isTablet ? 2.2 : 1.3,
            // crossAxisSpacing: 5,
            // mainAxisSpacing: 5,
            children: [

              GestureDetector(
                onTap: (){
                  Navigator.pushNamed(context, 'total_users');
                },
                child: _buildAdminCard(
                  context,
                  "Total Users",
                  "$total",
                  total == 0 ? 0 : total / 100,
                  isTablet,
                ),
              ),

              _buildAdminCard(
                context,
                "Employee",
                "$employee",
                total == 0 ? 0 : employee / total,
                isTablet,
              ),

              _buildAdminCard(
                context,
                "Freelancer",
                "$freelancer",
                total == 0 ? 0 : freelancer / total,
                isTablet,
              ),

              _buildAdminCard(
                context,
                "Trainee",
                "$trainee",
                total == 0 ? 0 : trainee / total,
                isTablet,
              ),

              _buildAdminCard(
                context,
                "Partners",
                "$partner",
                total == 0 ? 0 : partner / total,
                isTablet,
              ),

              _buildAdminCard(
                context,
                "HR",
                "$hr",
                total == 0 ? 0 : hr / total,
                isTablet,
              ),
              _buildAddUserCard(
                context,
                "$total",
                total == 0 ? 0 : total / 100,
                isTablet,
              ),
            ],
          ),

          SizedBox(height: 8),
          IntrinsicHeight(
            child: Padding(
              padding: EdgeInsets.only(left: 5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    width: 4,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 8,
                      ),
                      child: Text(
                        AppString.toDaysAttendanceTitle,
                        style: AppTypography.getTextTheme(context)
                            .titleMedium
                            ?.copyWith(
                          fontSize: isTablet ? 20 : 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          /// TODAY STATUS
          attendanceProvider.isLoading
              ? Center(child: CircularProgressIndicator(color: AppColors.primary,),)
              : ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
                itemCount: attendanceProvider.finalList.length,
                itemBuilder: (context, index) {
                  final user = attendanceProvider.finalList[index];

                  final status = attendanceProvider.getCurrentStatus(user);
                  final color = attendanceProvider.getStatusColor(status);

                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                    padding: EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.04),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: color.withOpacity(0.3)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                        /// LEFT
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                user.name,
                                style: AppTypography.getTextTheme(context).titleSmall
                            ),
                            SizedBox(height: 4),
                            Text(
                                user.department,
                                style: AppTypography.getTextTheme(context).bodyLarge?.copyWith(color: Colors.grey,fontSize: 14)
                            ),
                          ],
                        ),

                        /// RIGHT
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            buildStatusTag(status),
                            SizedBox(height: 8),
                            Text(
                              status == "Absent" ? "--" : formatTime(user.checkIn1),
                              style: AppTypography.getTextTheme(context).bodyLarge?.copyWith(color: Colors.black, fontSize: 14),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),

          SizedBox(height: 20),
        ],
      ),
    );
  }

/// ================= USER CARD =================
  Widget _buildCard({
    required BuildContext context,
    required String title,
    required String value,
    required double progress,
    required bool isTablet,
  }) {

    Color borderColor;
    Color bgColor;
    Color textColor;

    switch (title) {
      case "Present Days":
        borderColor = Colors.green;
        bgColor = Colors.green.withOpacity(0.1);
        textColor = Colors.green;
        break;

      case "Absent Days":
        borderColor = Colors.red;
        bgColor = Colors.red.withOpacity(0.1);
        textColor = Colors.red;
        break;

      case "Total Hours":
        borderColor = Colors.blue;
        bgColor = Colors.blue.withOpacity(0.1);
        textColor = Colors.blue;
        break;

      case "Avg Hours":
        borderColor = Colors.orange;
        bgColor = Colors.orange.withOpacity(0.1);
        textColor = Colors.orange;
        break;

      default:
        borderColor = AppColors.primary;
        bgColor = AppColors.primary.withOpacity(0.1);
        textColor = AppColors.primary;
    }

    return Container(
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: bgColor,
        border: Border.all(color: borderColor, width: 1.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: dashboardCardContent(
        context: context,
        title: title,
        value: value,
        progress: progress,
        textStyle: GoogleFonts.poppins(
          fontWeight: FontWeight.w600,
          color: textColor,
          fontSize: isTablet ? 18 : 16,
        ),
        valueColor: textColor,
        progressColor: borderColor,
        progressBgColor: Colors.transparent,
      ),
    );
  }

/// ================= ADMIN CARD =================
  Widget _buildAdminCard(
      BuildContext context,
      String title,
      String value,
      double progress,   // ✅ NEW
      bool isTablet,
      ) {

    Color borderColor;
    Color bgColor;
    Color textColor;

    switch (title) {
      case "Total Users":
        borderColor = Colors.purple;
        bgColor = Colors.purple.withOpacity(0.1);
        textColor = Colors.purple;
        break;

      case "Employee":
        borderColor = Colors.blue;
        bgColor = Colors.blue.withOpacity(0.1);
        textColor = Colors.blue;
        break;

      case "Freelancer":
        borderColor = Colors.teal;
        bgColor = Colors.teal.withOpacity(0.1);
        textColor = Colors.teal;
        break;

      case "Trainee":
        borderColor = Colors.orange;
        bgColor = Colors.orange.withOpacity(0.1);
        textColor = Colors.orange;
        break;

      case "HR":
        borderColor = Colors.indigo;
        bgColor = Colors.indigo.withOpacity(0.1);
        textColor = Colors.indigo;
        break;

      default:
        borderColor = AppColors.primary;
        bgColor = AppColors.primary.withOpacity(0.1);
        textColor = AppColors.primary;
    }

    return Container(
      margin: EdgeInsets.all(6),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: bgColor,
        border: Border.all(color: borderColor, width: 1.5),
        borderRadius: BorderRadius.circular(12),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [

          /// TITLE
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: isTablet ? 16 : 16,
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
          ),

          SizedBox(height: 8),

          /// VALUE
          Text(
            value,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: isTablet ? 20 : 18,
              color: textColor,
            ),
          ),

          SizedBox(height: 10),

          /// ✅ PROGRESS BAR
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0), // safe
              minHeight: isTablet ? 8 : 6,
              backgroundColor: Colors.white,
              valueColor: AlwaysStoppedAnimation(borderColor),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildAddUserCard(
      BuildContext context,
      String value,
      double progress,   // ✅ NEW
      bool isTablet,
      ) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, 'add_user');
      },
      child: Container(
        margin: EdgeInsets.all(6),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.green.withOpacity(0.1),
          border: Border.all(color: Colors.green, width: 1.5),
          borderRadius: BorderRadius.circular(12),
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Add Users",
              style: GoogleFonts.poppins(
                fontSize: isTablet ? 16 : 16,
                fontWeight: FontWeight.w500,
                color: Colors.green,
              ),
            ),
            SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: isTablet ? 22 : 18,
                    color: Colors.green,
                  ),
                ),
                Icon(
                  Icons.add,
                  color: Colors.green,
                  size: isTablet ? 26 : 22,
                ),
              ],
            ),
            SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: progress.clamp(0.0, 1.0),
                minHeight: isTablet ? 8 : 6,
                backgroundColor: Colors.white,
                valueColor: AlwaysStoppedAnimation(Colors.green),
              ),
            ),
          ],
        ),
      ),
    );
  }
  String formatDuration(Duration d) {
    return "${d.inHours}h ${d.inMinutes.remainder(60)}m";
  }
}
