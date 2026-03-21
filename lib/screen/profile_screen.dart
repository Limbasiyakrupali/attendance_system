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
    final Map<String,dynamic> user = ModalRoute.of(context)!.settings.arguments as Map<String,dynamic>;
    return Container(
      color: AppColors.primary,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.white,
          body: SingleChildScrollView(
            child: Consumer<UserProvider>(
              builder: (context,provider,_){
                return  Column(
                  children: [
                    CommonWidget.commonAppBarWidget(context: context, title: "${AppString.loginUserText} ${user['user']['name']} (${user['user']['role']})"),
                    Container(
                      margin: EdgeInsets.all(12),
                      height: 130,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(left: 10,right: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(radius: 50, backgroundImage: AssetImage("assets/image/krupali_Limbasiya.jpeg"),),
                                SizedBox(width: 15),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("${user['user']['name']}",style: AppTypography.getTextTheme(context).titleSmall?.copyWith(fontSize: 18,color: Colors.white)),
                                    Text("(${user['user']['role']})",style: AppTypography.getTextTheme(context).titleSmall?.copyWith(color: Colors.white)),
                                  ],
                                ),
                              ],
                            ),
                            Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(color: Colors.white38, borderRadius: BorderRadius.all(Radius.circular(8))),
                              child: Icon(FeatherIcons.edit,color: Colors.white,size: 25,),
                            )
                          ],
                        ),
                      ),
                    ),
                    CommonWidget.commonRotateBoxContainer(
                      context: context,
                      margin: EdgeInsets.only(left: 12,right: 12,bottom: 12),
                      // height: 600,
                      // width: MediaQuery.of(context).size.width,
                      // rotateBoxHeight: 570,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(AppString.personalInformationText,style: AppTypography.getTextTheme(context).titleMedium?.copyWith(fontSize: 18),),
                          CommonWidget.personalDetailContainer(context: context, height: 80, width: MediaQuery.of(context).size.width, icon: Icons.mail_outline_outlined, titleText: "Email", subTitleText: "${user['user']['email']}"),
                          CommonWidget.personalDetailContainer(context: context, height: 80, width: MediaQuery.of(context).size.width, icon: FeatherIcons.user, titleText: "Employee ID", subTitleText: "EMP01"),
                          CommonWidget.personalDetailContainer(context: context, height: 80, width: MediaQuery.of(context).size.width, icon: FeatherIcons.briefcase, titleText: "Department", subTitleText: "Flutter Developer & Trainer"),
                          CommonWidget.personalDetailContainer(context: context, height: 80, width: MediaQuery.of(context).size.width, icon: Icons.calendar_today, titleText: "Join Date", subTitleText: "Feb 2, 2026"),
                          CommonWidget.personalDetailContainer(context: context, height: 80, width: MediaQuery.of(context).size.width, icon: Icons.password_outlined, titleText: "Change Password", subTitleText: "123456"),
                          SizedBox(height: 20,),
                          GestureDetector(
                              onTap: ()async{
                                CommonWidget.commonAlertDialogBox(
                                  context: context,
                                  title: "Logout",
                                  message: "Are you sure you want to logout?",
                                  confirmText: "Yes",
                                  cancelText: "No",
                                  onConfirm: () async{
                                    try{
                                      await ApiHelper.apiHelper.logOut(Api.logout);

                                      Navigator.pushReplacementNamed(context, '/');

                                      ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text("Logged out successfully..."),backgroundColor: Colors.green,behavior: SnackBarBehavior.floating,)
                                      );
                                    }catch(e){
                                      ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text("$e"))
                                      );
                                    }
                                  },
                                );
                              },
                              child: CommonWidget.commonStatusButton(context: context, height: 50, width: MediaQuery.of(context).size.width, color: Colors.red.shade50, icon: FeatherIcons.logOut, iconColor: Colors.red, borderColor:  Colors.red, buttonTitle: AppString.logoutText, stringTextColor: Colors.red, iconSize: 19))
                        ],
                      ),
                    )
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
