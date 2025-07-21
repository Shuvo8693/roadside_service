import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:roadside_assistance/common/app_color/app_colors.dart';
import 'package:roadside_assistance/common/app_text_style/google_app_style.dart';
import 'package:roadside_assistance/common/widgets/custom_text_field.dart';

class InfoField extends StatelessWidget {
  final String label;
  final TextEditingController textEditingController;
  final String? suffixText;
  final int? maxLine;
  final VoidCallback? suffixOnTap;
  final bool readOnly;

  const InfoField({
    super.key,
    required this.label,
    this.suffixText,
    this.suffixOnTap,
    this.maxLine,
    required this.textEditingController,
    required this.readOnly,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 5),
        CustomTextField(
          controller: textEditingController,
          contentPaddingVertical: 15.h,
          maxLine: maxLine??1,
          readOnly: readOnly,
          suffixIcon: Padding(
            padding:  EdgeInsets.all(15.0.sp),
            child: InkWell(
                onTap: suffixOnTap,
                child: Text(suffixText??'',style: GoogleFontStyles.h5(color: AppColors.primaryColor),)
            ),
          ),
        )
      ],
    );
  }
}