import 'package:attendance_system/core/constant/app_string.dart';
import 'package:attendance_system/core/constant/app_typography.dart';
import 'package:attendance_system/provider/user_provider.dart';
import 'package:attendance_system/services/api/api.dart';
import 'package:attendance_system/services/api_service/api_helper.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constant/app_color.dart';
import '../core/widget/common_widget.dart';
import '../core/widget/custom_button.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask((){
      Provider.of<UserProvider>(context,listen: false).getUsers();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primary,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.white,
          body: SingleChildScrollView(
            child: Consumer<UserProvider>(
                builder: (context, provider, _) {
                  final size = MediaQuery.of(context).size;
                  final orientation = MediaQuery.of(context).orientation;
                  final isLandscape = orientation == Orientation.landscape;
                  final isTablet = size.width >= 600;
                  return Center(
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: isTablet ?  double.infinity : double.infinity,
                      ),
                      child: Column(
                        children: [
                          /// APP BAR
                          CommonWidget.commonAppBarWidget(context: context, title: "${AppString.loginUserText} ${provider.name} (${provider.role})",
                          ),
                          /// PROFILE CARD
                          Container(
                            margin: EdgeInsets.all(isTablet ? 20 : 12),
                            height: isTablet ? 160 : 130,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              child: isLandscape
                                  ? Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  profileInfo(provider, isTablet),
                                  // editButton(),
                                ],
                              )
                                  : Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(child: profileInfo(provider, isTablet)),
                                  // editButton(),
                                ],
                              ),
                            ),
                          ),
                          /// DETAILS CARD
                          Container(
                            margin: EdgeInsets.all(isTablet ? 20 : 10),
                            padding: EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(6),
                              boxShadow: [
                                BoxShadow(offset: Offset(0, 4), blurRadius: 5, spreadRadius: 2, color: Colors.grey.shade300,)
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 10),
                                /// TITLE
                                titleRow(context),
                                /// DETAILS LIST
                                personalItem(context, Icons.mail_outline_outlined, "Email", provider.userEmail, isTablet),

                                personalItem(context, FeatherIcons.user, "Employee ID", "EMP01", isTablet),

                                personalItem(context, FeatherIcons.briefcase, "Department", "Flutter Developer & Trainer", isTablet),

                                personalItem(context, Icons.calendar_today, "Join Date", "Feb 2, 2026", isTablet),

                                SizedBox(height: 20),
                                /// BUTTON
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 6),
                                  child: CustomButton(
                                    text: "CHANGE PASSWORD",
                                    width: double.infinity,
                                    onPressed: () {
                                      Navigator.pushNamed(context, 'change_password');
                                    },
                                  ),
                                ),
                                SizedBox(height: 5),
                                /// LOGOUT
                                logoutButton(context, isTablet),
                                SizedBox(height: 5),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
            ),
          ),
        ),
      ),
    );
  }
  Widget profileInfo(UserProvider provider, bool isTablet) {
    return Row(
      children: [
        CircleAvatar(
          radius: isTablet ? 60 : 50,
          backgroundImage: AssetImage("assets/image/uptech_new_logo.jpeg"),
        ),
        SizedBox(width: 12),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              provider.name,
              style: AppTypography.getTextTheme(context).titleSmall?.copyWith(fontSize: isTablet ? 20 : 18, color: Colors.white,),
            ),
            Text(
              "(${provider.role})",
              style: AppTypography.getTextTheme(context).titleSmall?.copyWith(color: Colors.white,fontSize: 16),
            ),
          ],
        ),
      ],
    );
  }
  Widget editButton() {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        color: Colors.white38,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        FeatherIcons.edit,
        color: Colors.white,
        size: 22,
      ),
    );
  }
  Widget titleRow(BuildContext context) {
    return IntrinsicHeight(
      child: Padding(
        padding: EdgeInsets.only(left: 10),
        child: Row(
          children: [
            Container(
              width: 4,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                AppString.personalInformationText,
                style: AppTypography.getTextTheme(context)
                    .titleMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget personalItem(BuildContext context, IconData icon,
      String title, String value, bool isTablet) {return CommonWidget.personalDetailContainer(
      context: context,
      height: isTablet ? 90 : 75,
      width: double.infinity,
      icon: icon,
      titleText: title,
      subTitleText: value,
    );}
  Widget logoutButton(BuildContext context, bool isTablet) {
    return GestureDetector(
      onTap: () async {
        CommonWidget.commonAlertDialogBox(
          context: context,
          title: "Logout",
          message: "Are you sure you want to logout?",
          confirmText: "Yes",
          cancelText: "No",
          onConfirm: () async {
            await ApiHelper.apiHelper.logOut(Api.logout);
            Navigator.pushReplacementNamed(context, '/');
          },
        );
      },
      child: CommonWidget.commonStatusButton(
        context: context,
        margin: EdgeInsets.symmetric(horizontal: 6, vertical: 8),
        height: isTablet ? 60 : 50,
        width: double.infinity,
        color: Colors.red.shade400,
        icon: FeatherIcons.logOut,
        iconColor: Colors.white,
        borderColor: Colors.red,
        buttonTitle: AppString.logoutText,
        stringTextColor: Colors.white,
        iconSize: 21,
      ),
    );
  }
}
