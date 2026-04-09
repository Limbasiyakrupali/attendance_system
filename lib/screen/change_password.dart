import 'dart:developer';

import 'package:attendance_system/core/constant/app_color.dart';
import 'package:flutter/material.dart';
import '../core/constant/app_string.dart';
import '../core/constant/app_typography.dart';
import '../core/responsive/breakpoints.dart';
import '../core/responsive/responsive_extension.dart';
import '../core/widget/custom_button.dart';
import '../core/widget/custom_textfield.dart';
import '../services/api/api.dart';
import '../services/api_service/api_helper.dart';
import '../services/api_service/token_service.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController currentPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();

  bool showPassword = true;
  bool showConfirmPassword = true;
  bool checkBoxValue = false;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final orientation = MediaQuery.of(context).orientation;
    final isLandscape = orientation == Orientation.landscape;
    final isTablet = size.width >= AppBreakpoints.mobile;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: isTablet ? 420 : double.infinity,
              ),
              padding: EdgeInsets.symmetric(
                horizontal: context.responsiveValue(mobile: 18, tablet: 0),
                vertical: context.responsiveValue(mobile: 25, tablet: 0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /// LOGO
                  Image.asset(
                    "assets/image/uptech_new_logo.jpeg",
                    height: context.responsiveValue(
                      mobile: isLandscape ? 150 : 250,
                      tablet: 250,
                    ),
                  ),
                  SizedBox(height: context.responsiveValue(mobile: 0, tablet: 0)),
                  /// LOGIN CARD
                  Container(
                    padding: EdgeInsets.only(top: context.responsiveValue(mobile: 22, tablet: 26),bottom: context.responsiveValue(mobile: 22, tablet: 26),left: context.responsiveValue(mobile: 18, tablet: 26),right: context.responsiveValue(mobile: 18, tablet: 26)),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all( color: AppColors.primary, width: 1.5),
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(.05),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        )
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// TITLE
                        Text(
                            AppString.informationTitle,
                            style: AppTypography.getTextTheme(context).titleSmall?.copyWith(color: AppColors.primary,fontWeight: FontWeight.w700,fontSize: 16)
                        ),
                        SizedBox(height: isLandscape ? 22 : 34),
                        /// EMAIL
                        CommonTextField(
                          title: "Email address",
                          controller: emailController,
                          hint: "Enter your email",
                          prefixIcon: Icons.email,
                        ),
                        const SizedBox(height: 14),
                        /// PASSWORD
                        CommonTextField(
                          title: "Current password",
                          obscureText: showPassword,
                          controller: currentPasswordController,
                          hint: "Enter your current password",
                          suffixIcon: showPassword ? Icons.visibility_off : Icons.visibility,
                          onSuffixTap: () {
                            setState(() {
                              showPassword = !showPassword;
                            });
                          },
                        ),
                        const SizedBox(height: 14),
                        CommonTextField(
                          title: "New password",
                          obscureText: showConfirmPassword,
                          controller: newPasswordController,
                          hint: "Enter your new password",
                          suffixIcon: showConfirmPassword ? Icons.visibility_off : Icons.visibility,
                          onSuffixTap: () {
                            setState(() {
                              showConfirmPassword = !showConfirmPassword;
                            });
                          },
                        ),
                        const SizedBox(height: 14),
                        /// OPTIONS ROW (RESPONSIVE)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            /// CHANGE PASSWORD
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, '/');
                              },
                              child: Text(
                                AppString.loginBackText,
                                style: AppTypography.getTextTheme(context).titleSmall?.copyWith(
                                    color: AppColors.primary,
                                    decoration: TextDecoration.underline,
                                    decorationColor: AppColors.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                        /// OPTIONS ROW (RESPONSIVE)
                        SizedBox(height: context.responsiveValue(mobile: 26, tablet: 36)),
                        /// UPDATE PASSWORD BUTTON
                        CustomButton(
                          text: AppString.updatePasswordText,
                          width: MediaQuery.of(context).size.width,
                          onPressed: () async {
                              try {
                                var response = await ApiHelper.apiHelper.put(
                                  Api.changePassword,
                                  {
                                    "currentPassword": currentPasswordController.text,
                                    "newPassword": newPasswordController.text,
                                  },
                                );
                                // log(response.toString(),name: "password responseeee");
                                await TokenService.getToken();
                                if (response['success'] == true) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text("Password changed successfully"), backgroundColor: Colors.green, behavior: SnackBarBehavior.floating,),);
                                  Navigator.pop(context);
                                }
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("$e"),
                                    backgroundColor: Colors.red,
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              }
                          }
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
