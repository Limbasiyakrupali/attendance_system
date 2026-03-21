import 'package:flutter/material.dart';
import '../constant/app_color.dart';
import '../constant/app_string.dart';
import '../constant/app_typography.dart';

class CommonWidget {

 static Widget commonAppBarWidget({required BuildContext context, required String title}){
    return Container(
      height: 135,
      width: MediaQuery.of(context).size.width,
      color: AppColors.primary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 10,left: 12,right: 12),
            child: Row(
              children: [
                Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        image: DecorationImage(image: AssetImage("assets/image/uptech_new_logo.jpeg"),fit: BoxFit.cover))
                ),
                SizedBox(width: 10,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(AppString.companyNameTitle, style: AppTypography.getTextTheme(context).titleLarge?.copyWith(color: AppColors.white,fontWeight: FontWeight.w700,fontSize: 20.5,overflow: TextOverflow.ellipsis),maxLines: 1,),
                      SizedBox(height: 5,),
                      Text(title, style: AppTypography.getTextTheme(context).titleSmall?.copyWith(color: AppColors.white,fontWeight: FontWeight.w600,overflow: TextOverflow.ellipsis),maxLines: 1,),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget personalDetailContainer({required BuildContext context,required double height, required double width, required String titleText, required String subTitleText,required IconData icon}){
   return Container(
     margin: EdgeInsets.only(left: 5,right: 10,top: 14),
     height: height,
     width: width,
     decoration: BoxDecoration(
         color: AppColors.primary.withOpacity(0.1),
         borderRadius: BorderRadius.all(Radius.circular(8)),
         border: Border.all(color: AppColors.primary)
     ),
     child: Row(
       children: [
         Container(
           margin: EdgeInsets.only(left: 10),
           height: 40,
           width: 40,
           decoration: BoxDecoration(
               borderRadius: BorderRadius.all(Radius.circular(8)),
               border: Border.all(color: AppColors.primary)
           ),
           child: Icon(icon,color: AppColors.primary,),
         ),
         SizedBox(width: 12),
         Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           mainAxisAlignment: MainAxisAlignment.center,
           children: [
             Text(titleText,style: AppTypography.getTextTheme(context).titleSmall?.copyWith(color: AppColors.primary,fontSize: 15),),
             SizedBox(height: 3),
             Text(subTitleText,style: AppTypography.getTextTheme(context).bodyLarge?.copyWith(color: AppColors.grey,fontSize: 14.5,)),
           ],
         )
       ],
     ),
   );
  }

  static Widget commonStatusButton({required BuildContext context, required double height, required double width, required Color color, IconData? icon, required Color iconColor, required Color borderColor, required String buttonTitle, required Color stringTextColor, double? iconSize}){
   return  Container(
     margin: EdgeInsets.only(right: 10, bottom: 12,left: 5),
     height: height,
     width: width,
     decoration: BoxDecoration(
       color: color,
       borderRadius: BorderRadius.all(Radius.circular(8)),
       border: Border.all(color: borderColor),
     ),
     child: Row(
       mainAxisAlignment: MainAxisAlignment.center,
       children: [
         Icon(icon,color: iconColor,size: iconSize,),
         SizedBox(width: 5,),
         Text(buttonTitle,style: AppTypography.getTextTheme(context).titleSmall?.copyWith(color: stringTextColor),),
       ],
     ),
   );
  }

  // static Widget commonRotateBoxContainer({required BuildContext context, required EdgeInsetsGeometry margin , double? height, required double width, double? rotateBoxHeight, required Widget child}){
  //  return Container(
  //    margin: margin,
  //    height: height,
  //    width: width,
  //    decoration: BoxDecoration(
  //        color: AppColors.white,
  //        borderRadius: BorderRadius.all(Radius.circular(8)),
  //        boxShadow: [
  //          BoxShadow(
  //            color: Colors.grey.withOpacity(0.2),
  //            blurRadius: 10,
  //            spreadRadius: 2,
  //            offset: Offset(0, 0),
  //          ),
  //        ]
  //    ),
  //    child: Column(
  //      crossAxisAlignment: CrossAxisAlignment.start,
  //      children: [
  //        Padding(
  //          padding: EdgeInsets.only(left: 8,top: 14),
  //          child: Row(
  //            crossAxisAlignment: CrossAxisAlignment.start,
  //            children: [
  //              RotatedBox(
  //                quarterTurns: -2,
  //                child: Container(
  //                  width: 3.5,
  //                  height: rotateBoxHeight,
  //                  decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.all(Radius.circular(10))),
  //                ),
  //              ),
  //              SizedBox(width: 6,),
  //              Expanded(
  //                child: child
  //              )
  //            ],
  //          ),
  //        ),
  //      ],
  //    ),
  //  );
  // }

 static Widget commonRotateBoxContainer({
   required BuildContext context,
   required EdgeInsetsGeometry margin,
   required Widget child,
   EdgeInsetsGeometry? padding,
 }) {
   return Container(
     margin: margin,
     width: double.infinity,
     padding: padding,
     decoration: BoxDecoration(
       color: AppColors.white,
       borderRadius: BorderRadius.circular(8),
       boxShadow: [
         BoxShadow(
           color: Colors.grey.withOpacity(0.2),
           blurRadius: 10,
           spreadRadius: 2,
         ),
       ],
     ),
     child: IntrinsicHeight( // ✅ MAGIC HERE
       child: Row(
         crossAxisAlignment: CrossAxisAlignment.stretch,
         children: [
           /// ✅ LEFT ROTATE LINE (AUTO HEIGHT)
           Container(
             margin: EdgeInsets.only(top: 10,left: 10,bottom: 10),
             width: 4,
             decoration: BoxDecoration(
               color: AppColors.primary,
               borderRadius: BorderRadius.circular(10),
             ),
           ),

           // SizedBox(width: 10),

           /// ✅ CONTENT (AUTO HEIGHT)
           Expanded(
             child: Padding(
               padding: EdgeInsets.symmetric(vertical: 14, horizontal: 8),
               child: child,
             ),
           ),
         ],
       ),
     ),
   );
 }

static Future<dynamic> commonAlertDialogBox({
 required BuildContext context,
  required String title,
  required String message,
  String confirmText = "OK",
  String cancelText = "Cancel",
  VoidCallback? onConfirm,
})async{

   return showDialog(
     context: context,
     barrierDismissible: false,
     builder: (context) {
       return AlertDialog(
         backgroundColor: AppColors.white,
         shape: RoundedRectangleBorder(
           borderRadius: BorderRadius.circular(12),
         ),
         title: Text(title,style: AppTypography.getTextTheme(context).bodyLarge?.copyWith(fontSize: 21),),
         content: Text(message,style: AppTypography.getTextTheme(context).bodyLarge?.copyWith(fontSize: 15.5),),
         actions: [
           Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children: [
               Expanded(
                   child: GestureDetector(
                     onTap: (){
                       Navigator.pop(context);
                     },
                     child: Container(margin:EdgeInsets.only(right: 5), height: 45, width: MediaQuery.of(context).size.width/2, decoration: BoxDecoration(color: Colors.red.shade100,border: Border.all(color: Colors.red),borderRadius: BorderRadius.all(Radius.circular(5))), child: Center(child: Text(cancelText,style: AppTypography.getTextTheme(context).bodyLarge?.copyWith(fontSize: 17,color: Colors.red),)),),
                   )),
               Expanded(
                   child: GestureDetector(
                     onTap: (){
                       Navigator.pop(context);
                       if (onConfirm != null) {
                         onConfirm();
                       }
                     },
                     child: Container(margin:EdgeInsets.only(left: 5), height: 45, width: MediaQuery.of(context).size.width/2, decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1),
                       border: Border.all(color: AppColors.primary),
                       borderRadius: BorderRadius.all(Radius.circular(5))),
                                      child: Center(child: Text(confirmText,style: AppTypography.getTextTheme(context).bodyLarge?.copyWith(fontSize: 17,color: AppColors.primary),)),),
                   )),
             ],
           ),
           SizedBox(height: 8,)
         ],
       );
     },
   );
}

}