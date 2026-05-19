import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mingda_app/core/theme/app_colors.dart';

class AppTextStyles {
  static TextStyle interMedium16 = GoogleFonts.inter(
    fontSize: 16.sp,
    height: 22 / 16,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  static TextStyle interMedium14 = GoogleFonts.inter(
    fontSize: 14.sp,
    height: 22 / 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  static TextStyle interRegular16 = GoogleFonts.inter(
    fontSize: 16.sp,
    height: 22 / 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );

  static TextStyle interRegular14 = GoogleFonts.inter(
    fontSize: 14.sp,
    height: 22 / 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );

  static TextStyle interMedium8 = GoogleFonts.inter(
    fontSize: 8.sp,
    height: 22 / 8,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );

  static TextStyle interRegular96 = GoogleFonts.inter(
    fontSize: 9.6.sp,
    height: 22 / 9.6,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  static TextStyle interRegular128 = GoogleFonts.inter(
    fontSize: 12.8.sp,
    height: 22 / 12.8,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  static TextStyle interRegular11 = GoogleFonts.inter(
    fontSize: 11.sp,
    height: 22 / 11,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );
}
