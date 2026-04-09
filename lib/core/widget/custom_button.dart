import 'package:flutter/material.dart';
import '../constant/app_color.dart';
import '../constant/app_typography.dart';

enum ButtonType { primary, secondary, danger, ghost }

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final ButtonType type;
  final double? width;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.type = ButtonType.primary,
    this.width,
  });

  Color _getColor() {
    switch (type) {
      case ButtonType.secondary:
        return AppColors.secondary;
      case ButtonType.danger:
        return AppColors.error;
      case ButtonType.ghost:
        return Colors.transparent;
      default:
        return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getColor();

    return SizedBox(
      width: width,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: type == ButtonType.ghost ? 0 : 5,
          backgroundColor: color,
          shadowColor: color.withOpacity(0.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: type == ButtonType.ghost ? BorderSide(color: AppColors.primary) : BorderSide.none
          ),
        ),
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? const CircularProgressIndicator(
          strokeWidth: 2, color: Colors.white,
        )
            : Text(
          text,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: type == ButtonType.ghost ? AppColors.primary : AppColors.white,
            fontSize: 16.5,
            fontWeight: FontWeight.w700
          ),
        ),
      ),
    );
  }
}

Widget commonContainer(
    {EdgeInsetsGeometry? padding, EdgeInsetsGeometry? margin, required double height, required double width, BorderRadius? borderRadius, Border? border, required Color color, List<
        BoxShadow>? boxShadow, required Widget child}) {
  return Container(
    padding: padding,
    margin: margin,
    height: height,
    width: width,
    decoration: BoxDecoration(
      color: color,
      borderRadius: borderRadius,
      border: border,
      boxShadow: boxShadow
    ),
    child: child,
  );
}

Widget dashboardCardContent({
  required BuildContext context,
  required String title,
  required String value,
  required double progress,
  required TextStyle textStyle,
  required Color valueColor,
  required Color progressColor,
  required Color progressBgColor,
}) {
  return Padding(
    padding: const EdgeInsets.all(12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Title
        Text(
          title,
          style: textStyle,
        ),
        SizedBox(height: 22),
        /// Value
        Text(
          value,
          style: AppTypography.getTextTheme(context)
              .bodyLarge
              ?.copyWith(
            color: AppColors.grey,
            fontWeight: FontWeight.w600,
            fontSize: 18
          ),
        ),
        Spacer(),

        /// Progress Bar
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: progress.clamp(0.0, 1.0),
            backgroundColor: progressBgColor,
            valueColor: AlwaysStoppedAnimation(progressColor),
            minHeight: 6,
          ),
        )
      ],
    ),
  );
}

Widget dashboardAdminCardContent({
  required BuildContext context,
  required String title,
  required String value,
  required TextStyle textStyle,
}) {
  return Padding(
    padding: const EdgeInsets.all(12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Title
        Text(
          title,
          style: textStyle,
        ),
        SizedBox(height: 20),
        /// Value
        Text(
          value,
          style: AppTypography.getTextTheme(context)
              .bodyLarge
              ?.copyWith(
              color: AppColors.grey,
              fontWeight: FontWeight.w800,
              fontSize: 18
          ),
        ),
        Spacer(),

        /// Progress Bar
       RotatedBox(quarterTurns: 2,
       child: Container(
                width: MediaQuery.of(context).size.width,
                height: 3,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.all(Radius.circular(8))
                ),
              ),)
      ],
    ),
  );
}
// Widget attendanceCardContent({
//   required BuildContext context,
//   String? checkInTime = "6:00 PM",
//   String? checkOutTime = ""
//       "",
//   required TextStyle textStyle,
//   required Color timeColor,
//   String? statusText,
//   Color? checkColor,
// }) {
//   return Padding(
//     padding: const EdgeInsets.all(12),
//     child: Row(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//
//         /// ✅ CHECK IN
//         if (checkInTime != null)
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     Image.asset(
//                       "assets/image/check in.png",
//                       height: 25,
//                       color: AppColors.primary,
//                     ),
//                     const SizedBox(width: 5),
//                     Text(
//                       "Check In",
//                       style: AppTypography.getTextTheme(context)
//                           .titleSmall
//                           ?.copyWith(
//                         color: checkColor,
//                         fontSize: 17,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 10),
//                 Row(
//                   children: [
//                     const Icon(
//                       FeatherIcons.clock,
//                       size: 20,
//                       color: AppColors.primary,
//                     ),
//                     const SizedBox(width: 5),
//                     Text(
//                       checkInTime,
//                       style: AppTypography.getTextTheme(context)
//                           .titleMedium
//                           ?.copyWith(
//                         color: timeColor,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 18,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//
//         /// ✅ CENTER VERTICAL LINE
//         if (checkInTime != null && checkOutTime != null)
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 12),
//             child: RotatedBox(
//               quarterTurns: 1,
//               child: Container(
//                 width: 40,
//                 height: 1.5,
//                 color: Colors.grey.shade300,
//               ),
//             ),
//           ),
//
//         /// ✅ CHECK OUT
//         if (checkOutTime != null)
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     Image.asset(
//                       "assets/image/check out.png",
//                       height: 25,
//                       color: AppColors.primary,
//                     ),
//                     const SizedBox(width: 5),
//                     Text(
//                       "Check Out",
//                       style: AppTypography.getTextTheme(context)
//                           .titleSmall
//                           ?.copyWith(
//                         color: checkColor,
//                         fontSize: 17,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 10),
//                 Row(
//                   children: [
//                     const Icon(
//                       FeatherIcons.clock,
//                       size: 20,
//                       color: AppColors.primary,
//                     ),
//                     const SizedBox(width: 5),
//                     Text(
//                       checkOutTime,
//                       style: AppTypography.getTextTheme(context)
//                           .titleMedium
//                           ?.copyWith(
//                         color: timeColor,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 18,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//       ],
//     ),
//   );
// }

Widget attendanceCardContent(BuildContext context,String checkInTime, String checkOutTime) {
  /// 🔹 Static Time
  // const String checkInTime = "09:00 AM";
  // const String checkOutTime = "06:00 PM";
  return Padding(
    padding: const EdgeInsets.all(16),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        /// ✅ CHECK IN
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.login, color: AppColors.grey, size: 25,),
                  SizedBox(width: 8),
                  Text(
                    "Check In", style:AppTypography.getTextTheme(context).titleSmall?.copyWith(fontSize: 16, fontWeight: FontWeight.w600,color: AppColors.grey),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 5),
                    child: Icon(Icons.access_time, size: 21.5, color: AppColors.black),
                  ),
                  SizedBox(width: 6),
                  Text(
                    checkInTime,
                      style: AppTypography.getTextTheme(context).bodyLarge?.copyWith(fontSize: 17, fontWeight: FontWeight.w500,color: AppColors.black)
                  ),
                ],
              ),
            ],
          ),
        ),
        /// ✅ CENTER VERTICAL LINE
        Container(
          height: 70,
          width: 2,
          color: AppColors.primary,
        ),
        SizedBox(width: 10),
        /// ✅ CHECK OUT
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 12),
                child: Row(
                  children: [
                    Icon(Icons.logout, color: AppColors.grey, size: 23,),
                    SizedBox(width: 6),
                    Text(
                      "Check Out",
                        style:AppTypography.getTextTheme(context).titleSmall?.copyWith(fontSize: 16, fontWeight: FontWeight.w600,color: AppColors.grey)
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.only(left: 12),
                child: Row(
                  children: [
                    Icon(Icons.access_time, size: 21.5, color: AppColors.black),
                    SizedBox(width: 6),
                    Text(
                      checkOutTime,
                        style: AppTypography.getTextTheme(context).bodyLarge?.copyWith(fontSize: 17, fontWeight: FontWeight.w500,color: AppColors.black)
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget attendanceHistoryCheckInCardContent({required BuildContext context,required String checkInTime1,required String checkInTime2, required String checkInText1, required String checkOutText1}) {
  return Row(
    children: [
      Expanded(
        child: Container(
          margin: EdgeInsets.only(right: 5),
          height: 100,
          width: MediaQuery.of(context).size.width/2,
          decoration: BoxDecoration(
              color: AppColors.white,
              // border: Border.all(color: AppColors.primary),
              borderRadius: BorderRadius.all(Radius.circular(5))
          ),
          child: Padding(
            padding: EdgeInsets.only(left: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Icon(Icons.login, color: AppColors.grey, size: 22,),
                    SizedBox(width: 8),
                    Text(
                        checkInText1, style:AppTypography.getTextTheme(context).titleSmall?.copyWith(fontSize: 16, fontWeight: FontWeight.w600,color: AppColors.grey)),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 5),
                      child: Icon(Icons.access_time, size: 20.5, color: AppColors.black),
                    ),
                    SizedBox(width: 6),
                    Text(
                        checkInTime1,
                        style:AppTypography.getTextTheme(context).bodyLarge?.copyWith(fontSize: 16, fontWeight: FontWeight.w600,color: AppColors.black)
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      Expanded(
        child: Container(
          margin: EdgeInsets.only(left: 5),
          height: 100,
          width: MediaQuery.of(context).size.width/2,
          decoration: BoxDecoration(
              color: AppColors.white,
              // border: Border.all(color: AppColors.primary),
              borderRadius: BorderRadius.all(Radius.circular(8))
          ),
          child: Padding(
            padding: EdgeInsets.only(left: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Icon(Icons.login, color: AppColors.grey, size: 22,),
                    SizedBox(width: 8),
                    Text(
                        checkOutText1, style:AppTypography.getTextTheme(context).titleSmall?.copyWith(fontSize: 16, fontWeight: FontWeight.w600,color: AppColors.grey)),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 5),
                      child: Icon(Icons.access_time, size: 20.5, color: AppColors.black),
                    ),
                    SizedBox(width: 6),
                    Text(
                        checkInTime2,
                        style:AppTypography.getTextTheme(context).bodyLarge?.copyWith(fontSize: 16, fontWeight: FontWeight.w600,color: AppColors.black)
                    ),

                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ],
  );
}