import 'package:flutter/material.dart';

import '../constant/app_color.dart';
import '../constant/app_typography.dart';

class CommonTextField extends StatelessWidget {
  final String? title;
  final TextEditingController controller;
  final String hint;
  final bool obscureText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixTap;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChange;
  final TextInputType keyboardType;
  final int maxLines;
  final bool enabled;

  const CommonTextField({
    super.key,
    this.title,
    required this.controller,
    required this.hint,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixTap,
    this.validator,
    this.onChange,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(title!, style: AppTypography.getTextTheme(context).bodyLarge?.copyWith(fontSize: 15)),
          ),
        Container(
          decoration: BoxDecoration(
           border: Border.all(color: AppColors.primary),

            borderRadius: BorderRadius.all(Radius.circular(8))
          ),
          child: TextFormField(
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            maxLines: maxLines,
            // enabled: enabled,
            onChanged: onChange,
            style: AppTypography.getTextTheme(context).labelMedium?.copyWith(fontWeight: FontWeight.w600,fontSize: 13),
            cursorColor: AppColors.primary,
            validator: validator,
            decoration: InputDecoration(
              hintText: hint,
              border: UnderlineInputBorder(borderSide: BorderSide.none),
              hintStyle: AppTypography.getTextTheme(context).labelMedium?.copyWith(fontWeight: FontWeight.w600,fontSize: 13),
              prefixIcon: prefixIcon != null
                  ? Icon(prefixIcon, color: AppColors.primary,size: 22,)
                  : null,
              suffixIcon: suffixIcon != null
                  ? IconButton(
                padding: EdgeInsets.zero,
                icon: Icon(suffixIcon, color: AppColors.primary,size: 23),
                onPressed: onSuffixTap,
              )
                  : null,
              contentPadding: const EdgeInsets.all(14),

            ),
          ),
        ),
      ],
    );
  }

}
