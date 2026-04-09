import 'dart:convert';
import 'dart:developer';

import 'package:attendance_system/core/constant/app_color.dart';
import 'package:attendance_system/core/constant/app_string.dart';
import 'package:attendance_system/core/constant/app_typography.dart';
import 'package:attendance_system/core/widget/custom_button.dart';
import 'package:attendance_system/services/api/api.dart';
import 'package:attendance_system/services/api_service/api_helper.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../core/responsive/breakpoints.dart';
import '../core/responsive/responsive_extension.dart';
import '../core/widget/custom_textfield.dart';
import '../provider/attendance_provider.dart';
import '../provider/user_provider.dart';
import '../services/api_service/token_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool showPassword = true;
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
                  SizedBox(
                      height: context.responsiveValue(mobile: 0, tablet: 0)),
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
                        const SizedBox(height: 18),
                        /// PASSWORD
                        CommonTextField(
                          title: "Password",
                          obscureText: showPassword,
                          controller: passwordController,
                          hint: "Enter your password",
                          suffixIcon: showPassword ? Icons.visibility_off : Icons.visibility,
                          onSuffixTap: () {
                            setState(() {
                              showPassword = !showPassword;
                            });
                          },
                        ),
                        const SizedBox(height: 14),
                        /// OPTIONS ROW (RESPONSIVE)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            /// REMEMBER ME
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Checkbox(
                                  checkColor: AppColors.white,
                                  activeColor: AppColors.primary,
                                  materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                                  visualDensity:
                                  const VisualDensity(horizontal: -4),
                                  value: checkBoxValue,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      checkBoxValue = value!;
                                    });
                                  },
                                ),
                                SizedBox(width: 5,),
                                Text(
                                  AppString.rememberText,
                                  style: AppTypography.getTextTheme(context).bodyLarge?.copyWith(fontSize: 15)
                                ),
                              ],
                            ),
                            /// CHANGE PASSWORD
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, 'change_password');
                              },
                              child: Text(
                                AppString.changePasswordText,
                                style: AppTypography.getTextTheme(context).titleSmall?.copyWith(
                                  color: AppColors.primary,
                                  decoration: TextDecoration.underline,
                                  decorationColor: AppColors.primary
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: context.responsiveValue(mobile: 26, tablet: 36)),
                        /// BUTTON
                        CustomButton(
                          text: "LOGIN",
                            width: double.infinity,
                            onPressed: () async {
                              try {
                                var response = await ApiHelper.apiHelper.post(
                                  Api.login,
                                  {
                                    "email": emailController.text,
                                    "password": passwordController.text,
                                  },
                                );
                                if (response['token'] != null) {
                                  String token = response['token'];
                                  String role = response['user']['role'];
                                  String userId = response['user']['id'];

                                  await TokenService.saveToken(token, role,userId);
                                  context.read<UserProvider>().setUserData(response);
                                  // log(response.toString(), name: "==========Login Api Response==========");
                                  // log(role, name: "==========User Role==========");
                                  // print("Iddddddddddd-----------${response['user']['id']}");
                                  Navigator.pushReplacementNamed(
                                    context,
                                    '/home',
                                    arguments: response,
                                  );
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
                          },
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