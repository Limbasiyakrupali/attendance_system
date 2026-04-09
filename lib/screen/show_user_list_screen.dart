import 'package:attendance_system/core/constant/app_color.dart';
import 'package:attendance_system/core/constant/app_typography.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';

import '../core/constant/app_string.dart';
import '../core/widget/common_widget.dart';
import '../core/widget/custom_button.dart';
import '../provider/attendance_provider.dart';
import '../provider/user_provider.dart';
import 'package:excel/excel.dart' hide Border;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;

class ShowUserListScreen extends StatefulWidget {
  const ShowUserListScreen({super.key});

  @override
  State<ShowUserListScreen> createState() => _ShowUserListScreenState();
}

class _ShowUserListScreenState extends State<ShowUserListScreen> {
  String selectedRole = "All Roles";
  String selectedEmployee = "All Employees";
  String selectedMonth = "All Months";
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<AttendanceProvider>().getAttendance();
    });
  }

  List<Map<String, dynamic>> getFilteredData(List<Map<String, dynamic>> data) {
    return data.where((item) {
      /// SEARCH FILTER
      final searchText = searchController.text.toLowerCase();
      final searchMatch = searchText.isEmpty || (item['employee']?? "").toString().toLowerCase().contains(searchText);
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

      return searchMatch && roleMatch && employeeMatch && monthMatch;

    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final provider = context.watch<AttendanceProvider>();

    final filtered = getFilteredData(provider.attendanceListt);

    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    return Container(
      color: AppColors.primary,
      child: SafeArea(
        bottom: false,
        child: Scaffold(
          backgroundColor: AppColors.white,
          floatingActionButton: Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  exportToExcel(filtered, context);
                },
                child: Text("Export Excel"),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () => exportToPDF(filtered),
                child: Text("Export PDF"),
              ),
            ],
          ),
          body: provider.isLoading
              ? const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          )
              : isLandscape
              ? _buildLandscapeLayout(userProvider, provider, filtered)
              : _buildPortraitLayout(userProvider, provider, filtered),
        ),
      ),
    );
  }
  Future<String> getDownloadPath() async {
    Directory? dir = await getExternalStorageDirectory();

    String newPath = "";
    List<String> folders = dir!.path.split("/");

    for (int i = 1; i < folders.length; i++) {
      String folder = folders[i];
      if (folder != "Android") {
        newPath += "/$folder";
      } else {
        break;
      }
    }

    newPath = "$newPath/Download";

    return newPath;
  }
  Future<void> saveExcelToDownloads(List<int> bytes) async {
    final path = await getDownloadPath();

    final file = File("$path/attendance.xlsx");

    await file.writeAsBytes(bytes);

    print("Saved at: $path");
  }
  Future<void> exportToExcel(List data, BuildContext context) async {
    var excel = Excel.createExcel();
    Sheet sheet = excel['Sheet1'];

    /// Header
    sheet.appendRow([
      TextCellValue('Date'),
      TextCellValue('Employee'),
      TextCellValue('Role'),
      TextCellValue('CheckIn1'),
      TextCellValue('CheckOut1'),
      TextCellValue('CheckIn2'),
      TextCellValue('CheckOut2'),
      TextCellValue('Working Hours'),
    ]);

    /// Data
    for (var e in data) {
      sheet.appendRow([
        TextCellValue(formatDate(e['date'])),
        TextCellValue(e['employee'] ?? ""),
        TextCellValue(e['role'] ?? ""),
        TextCellValue(formatToIST(e['checkIn1'])),
        TextCellValue(formatToIST(e['checkOut1'])),
        TextCellValue(formatToIST(e['checkIn2'])),
        TextCellValue(formatToIST(e['checkOut2'])),
        TextCellValue(
          totalWorkingHours(
            parseTime(e['checkIn1']),
            parseTime(e['checkOut1']),
            parseTime(e['checkIn2']),
            parseTime(e['checkOut2']),
          ),
        ),
      ]);
    }

    final bytes = excel.encode()!;
    await saveExcelToDownloads(bytes);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("File saved in Downloads ✅")),
    );
  }

  /// Download pdf

  Future<void> savePDFToDownloads(List<int> bytes) async {
    final path = await getDownloadPath();
    final file = File("$path/attendance.pdf");

    await file.writeAsBytes(bytes);
  }

  Future<void> exportToPDF(List data) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        build: (context) => [
          pw.Text(
            "Attendance Report",
            style: pw.TextStyle(fontSize: 18),
          ),

          pw.SizedBox(height: 10),

          pw.Table.fromTextArray(
            headers: [
              'Date','Employee','Role','CheckIn 1','CheckOut 1','CheckIn 2','CheckOut 2','Hours'
            ],
            data: data.map((e) => [
              formatDate(e['date']),
              e['employee'] ?? "",
              e['role'] ?? "",
              formatToIST(e['checkIn1']),
              formatToIST(e['checkOut1']),
              formatToIST(e['checkIn2']),
              formatToIST(e['checkOut2']),
              totalWorkingHours(
                parseTime(e['checkIn1']),
                parseTime(e['checkOut1']),
                parseTime(e['checkIn2']),
                parseTime(e['checkOut2']),
              ),
            ]).toList(),
          ),
        ],
      ),
    );

    /// ✅ THIS OPENS PREVIEW
    await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
    );
  }

  Widget _buildPortraitLayout(userProvider, provider, filtered) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ///  FIXED APP BAR
        CommonWidget.commonAppBarWidget(
          context: context,
          title:
          "${AppString.loginUserText} ${userProvider.name} (${userProvider.role})",
        ),
        Container(
          margin: EdgeInsets.only(top: 10,left: 10,right: 8),
          height: 180,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            border: Border.all(color: Colors.grey.shade300),
            boxShadow: [
              BoxShadow(
                offset: Offset(0, 2),
                spreadRadius: 2,
                blurRadius: 2,
                color: Colors.grey.shade300
              )
            ]
          ),
          child: Column(
            children: [
             Row(
               children: [
                 Container(
                   height: 50,
                   width: 50,
                   decoration: BoxDecoration(
                     color: AppColors.primary.withOpacity(0.1),
                     borderRadius: BorderRadius.circular(8),
                   ),
                   child: Icon(FeatherIcons.edit,color: AppColors.primary,size: 22,),
                 )
               ],
             )
          ],
          ),
        ),
        /// SCROLLABLE PART ONLY
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                buildFilters(provider.attendanceListt),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.only(left: 10,right: 10),
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Search...",
                      prefixIcon: Icon(FeatherIcons.search,size: 22,),
                    ),
                    onChanged: (value){
                      setState(() {});
                    },
                    style: AppTypography.getTextTheme(context).bodyMedium,
                  ),
                ),
                const SizedBox(height: 15),
                /// TITLE
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      Container(
                        width: 4,
                        height: 22,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        AppString.fullHistoryTitle,
                        style: AppTypography.getTextTheme(context)
                            .titleMedium
                            ?.copyWith(fontSize: 17),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                /// LIST
                buildAttendanceList(filtered),
              ],
            ),
          ),
        ),
      ],
    );
  }
  Widget _buildLandscapeLayout(userProvider, provider, filtered) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonWidget.commonAppBarWidget(
            context: context,
            title:
            "${AppString.loginUserText} ${userProvider.name} (${userProvider.role})",
          ),
          const SizedBox(height: 20),
          buildFilters(provider.attendanceListt),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Container(
                  width: 4,
                  height: 22,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  AppString.fullHistoryTitle,
                  style: AppTypography.getTextTheme(context).titleMedium?.copyWith(fontSize: 17),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          buildAttendanceList(filtered),
        ],
      ),
    );
  }
  Widget buildAttendanceList(List data) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: data.length,
      itemBuilder: (context, index) {
        final e = data[index];
        return Container(
          margin: const EdgeInsets.only(left: 12,right: 12,top: 10,bottom: 5),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color:Colors.grey.shade200,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// TOP ROW
              Padding(
                padding: const EdgeInsets.only(top: 3),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          // margin: EdgeInsets.only(top: 10),
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            borderRadius:
                            BorderRadius.circular(5),
                            border: Border.all(
                                color: AppColors.primary),
                          ),
                          child: Icon(Icons.calendar_today,
                              color: AppColors.primary),
                        ),
                        SizedBox(width: 10),
                        Text(
                          formatDate(e['date']),
                          style: AppTypography.getTextTheme(context).titleSmall?.copyWith(fontSize: 16,),
                        ),
                      ],
                    ),
                    /// WORKING HOURS
                    Align(
                      alignment: Alignment.centerRight,
                      child:  Container(
                        height: 40,
                        width: 105,
                        decoration: BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(5),
                          color: AppColors.primary,
                        ),
                        child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment.center,
                          children: [
                            Icon(Icons.access_time_outlined, color: Colors.white),
                            SizedBox(width: 3),
                            Text(
                                totalWorkingHours(
                                  parseTime(e['checkIn1']),
                                  parseTime(e['checkOut1']),
                                  parseTime(e['checkIn2']),
                                  parseTime(e['checkOut2']),
                                ),
                                style: AppTypography.getTextTheme(context).titleSmall?.copyWith(color: AppColors.white)
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              /// EMPLOYEE
             Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
                 Text(
                   e['employee'] ?? "",
                   style: AppTypography.getTextTheme(context).titleSmall?.copyWith(fontSize: 16),
                 ),
                 Text(
                   e['role'] ?? "",
                   style: AppTypography.getTextTheme(context).titleSmall?.copyWith(),
                 ),
               ],
             ),
              const Divider(),
              SizedBox(height: 5),
              /// TIME ROWS
              attendanceHistoryCheckInCardContent(
                context: context,
                checkInTime1: formatToIST(e['checkIn1']),
                checkInTime2: formatToIST(e['checkOut1']),
                checkInText1: "Check-In 1",
                checkOutText1: "Check-Out 1",
              ),
              SizedBox(height: 10),
              attendanceHistoryCheckInCardContent(
                context: context,
                checkInTime1: formatToIST(e['checkIn2']),
                checkInTime2: formatToIST(e['checkOut2']),
                checkInText1: "Check-In 2",
                checkOutText1: "Check-Out 2",
              ),
              const SizedBox(height: 3),
              // Divider(height: 8,)
            ],
          ),
        );
      },
    );
  }
  Widget buildTimeColumn(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 5),
        Text(
          title,
          style: AppTypography.getTextTheme(context).titleSmall?.copyWith(color: Colors.grey,fontSize: 16),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: AppTypography.getTextTheme(context).titleSmall?.copyWith(fontSize: 16),
        ),
      ],
    );
  }

  String formatToIST(String? time) {
    try {
      if (time == null || time.isEmpty) return "--:--";

      /// If already formatted (AM/PM), return directly
      if (time.contains("AM") || time.contains("PM")) {
        return time;
      }

      DateTime utcTime = DateTime.parse(time);
      DateTime istTime = utcTime.toLocal();

      return "${istTime.hour % 12 == 0 ? 12 : istTime.hour % 12}:"
          "${istTime.minute.toString().padLeft(2, '0')} "
          "${istTime.hour >= 12 ? "PM" : "AM"}";

    } catch (e) {
      return "-";
    }
  }

 static String totalWorkingHours(
     DateTime? in1,
     DateTime? out1,
     DateTime? in2,
     DateTime? out2
     ){
    Duration total = Duration.zero;

    if(in1 != null && out1 != null && out1.isAfter(in1)){
        total += out1.difference(in1);
    }
    if(in2 != null && out2 != null && out2.isAfter(in2)){
      total += out2.difference(in2);
    }
    int hours = total.inHours;
    int minutes = total.inMinutes % 60;

    return "${hours}h ${minutes}m";
 }

  DateTime? parseTime(String? time) {
    try {
      if (time == null || time.isEmpty) return null;

      return DateTime.parse(time).toLocal(); // IST
    } catch (e) {
      return null;
    }
  }
  String formatDate(String? date){
    try{
      if(date == null || date.isEmpty)return "-";
      DateTime parseDate = DateTime.parse(date);
      return DateFormat("dd/MM/yyyy").format(parseDate);
    }catch(e){
      return "-";
    }
  }

  Widget buildFilters(List data) {
    List<String> roles = ["All Roles"];
    List<String> employees = ["All Employees"];
    List<String> months = [
      "All Months",
      "January","February","March","April","May","June",
      "July","August","September","October","November","December"
    ];

    for (var e in data) {
      if (e['role'] != null && !roles.contains(e['role'])) {
        roles.add(e['role']);
      }
      if (e['employee'] != null && !employees.contains(e['employee'])) {
        employees.add(e['employee']);
      }
    }

    /// ✅ RETURN WIDGET
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          /// ROLE
          Expanded(
            child: DropdownButtonFormField<String>(
              value: selectedRole,
              isExpanded: true,
              decoration: InputDecoration(
                labelText: "Filter by Role",
                labelStyle: AppTypography.getTextTheme(context).bodySmall,
                contentPadding: EdgeInsets.symmetric(horizontal: 5, vertical: 15),
                border: OutlineInputBorder(),
              ),
              items: roles.map((r) {
                return DropdownMenuItem(
                    value: r, child: Text(r,style: AppTypography.getTextTheme(context).bodyLarge?.copyWith(fontSize: 14),overflow: TextOverflow.ellipsis,maxLines: 1,));
              }).toList(),
              onChanged: (val) {
                setState(() {
                  selectedRole = val!;
                });
              },
            ),
          ),

          SizedBox(width: 10),

          /// EMPLOYEE
          Expanded(
            child: DropdownButtonFormField<String>(
              value: selectedEmployee,
              isExpanded: true,
              decoration: InputDecoration(
                labelText: "Filter by Employee",
                labelStyle: AppTypography.getTextTheme(context).bodySmall,
                contentPadding: EdgeInsets.symmetric(horizontal: 5, vertical: 15),
                border: OutlineInputBorder(),
              ),
              items: employees.map((e) {
                return DropdownMenuItem(value: e, child: Text(e,style: AppTypography.getTextTheme(context).bodyLarge?.copyWith(fontSize: 14),overflow: TextOverflow.ellipsis,maxLines: 1,));
              }).toList(),
              onChanged: (val) {
                setState(() {
                  selectedEmployee = val!;
                });
              },
            ),
          ),

          SizedBox(width: 10),

          /// MONTH
          Expanded(
            child: DropdownButtonFormField<String>(
              value: selectedMonth,
              isExpanded: true,
              decoration: InputDecoration(
                labelText: "Filter by Month",
                labelStyle: AppTypography.getTextTheme(context).bodySmall,
                contentPadding: EdgeInsets.symmetric(horizontal: 5, vertical: 15),
                border: OutlineInputBorder(),
              ),
              items: months.map((m) {
                return DropdownMenuItem(value: m, child: Text(m,style: AppTypography.getTextTheme(context).bodyLarge?.copyWith(fontSize: 14),overflow: TextOverflow.ellipsis,maxLines: 1,));
              }).toList(),
              onChanged: (val) {
                setState(() {
                  selectedMonth = val!;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
