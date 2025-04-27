import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:roadside_assistance/common/app_color/app_colors.dart';


class GoogleFontStyles {
  static TextStyle h1({
    Color? color,
    FontWeight? fontWeight,
    String? family,
    double? letterSpacing,
    double? fontSize,
  }) {
    return GoogleFonts.poppins(
      fontWeight: fontWeight ?? FontWeight.w400,
      fontSize: fontSize ?? 24.sp,
      color: color,
      letterSpacing: letterSpacing,
    );
  }

  static TextStyle h2({
    Color? color,
    FontWeight? fontWeight,
    String? family,
    double? letterSpacing,
    double? height,
  }) {
    return GoogleFonts.poppins(
      fontWeight: fontWeight ?? FontWeight.w400,
      fontSize: 20.sp,
      color: color,
      letterSpacing: letterSpacing,
      height: height,
    );
  }

  static TextStyle h3({
    Color? color,
    String? family,
    FontWeight? fontWeight,
    double? letterSpacing,
  }) {
    return GoogleFonts.poppins(
      fontWeight: fontWeight ?? FontWeight.w400,
      fontSize: 18.sp,
      color: color,
      letterSpacing: letterSpacing,
    );
  }

  static TextStyle h4({
    Color? color,
    FontWeight? fontWeight,
    double? letterSpacing,
    String? family,
    double? height,
  }) {
    return GoogleFonts.poppins(
      fontWeight: fontWeight ?? FontWeight.w500,
      fontSize: 16.sp,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
    );
  }

  static TextStyle h5({
    Color? color,
    FontWeight? fontWeight,
    double? letterSpacing,
    String? family,
    double? fontSize,
    double? height,
  }) {
    return GoogleFonts.poppins(
      fontWeight: fontWeight ?? FontWeight.w400,
      fontSize: fontSize ?? 14.sp,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
    );
  }

  static TextStyle h6({
    Color? color,
    FontWeight? fontWeight,
    double? letterSpacing,
    String? family,
    double? height,
  }) {
    return GoogleFonts.poppins(
      fontWeight: fontWeight ?? FontWeight.w400,
      fontSize: 12.sp,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
    );
  }

  static TextStyle customSize({
    Color? color,
    required double size,
    String? family,
    double? letterSpacing,
    double? height,
    Color? underlineColor,
    TextDecoration? underline,
    FontWeight? fontWeight,
  }) {
    return GoogleFonts.poppins(
      fontWeight: fontWeight ?? FontWeight.w400,
      color: color,
      fontSize: size,
      decoration: underline ?? TextDecoration.none,
      decorationColor: underlineColor ?? Colors.transparent,
      height: height,
      letterSpacing: letterSpacing,
    );
  }

  static BoxShadow boxShadow = BoxShadow(
    blurRadius: 12,
    offset: const Offset(0, 0),
    color: AppColors.primaryColor.withValues(alpha: 0.2),
    spreadRadius: 0,
  );
}