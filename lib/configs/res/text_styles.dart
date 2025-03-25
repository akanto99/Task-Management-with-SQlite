import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:razinsoft_task_management/configs/res/color.dart';

class AppTextStyles {
  static final TextStyle poppins12Regular = GoogleFonts.poppins(
      fontSize: 13,
      fontWeight: FontWeight.w400,
      color: AppColors.textgreyColor

    /// Regular
  );
  static final TextStyle poppins12RegularColor = GoogleFonts.poppins(
    fontSize: 13,
    fontWeight: FontWeight.w400,

    /// Regular
  );

  static final TextStyle poppins14Regular = GoogleFonts.poppins(
      fontSize: 15,
      fontWeight: FontWeight.w400,

      color: AppColors.blackColor.withOpacity(0.8),
    /// Medium
  );
  static final TextStyle poppins14Medium = GoogleFonts.poppins(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: AppColors.textblackColor
    /// Medium
  );

  // Custom method to allow manual color customization
  static TextStyle poppins16WithColor({ required Color color}) {
    return GoogleFonts.poppins(
      fontSize: 15,
      fontWeight: FontWeight.w500,
      color: color,/// Medium
    );
  }



  static final TextStyle poppins16Medium = GoogleFonts.poppins(
      fontSize: 17,
      fontWeight: FontWeight.w500,
      color: AppColors.textblackColor

    /// Medium
  );

  static final TextStyle poppins18Medium = GoogleFonts.poppins(
      fontSize: 19,
      fontWeight: FontWeight.w500,
      color: AppColors.textblackColor

    /// Medium
  );


  static final TextStyle poppins20Medium = GoogleFonts.poppins(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: AppColors.textblackColor

    /// Medium
  );


  // Custom method to allow manual color customization
  static TextStyle poppins24WithColor({ required Color color}) {
    return GoogleFonts.poppins(
      fontSize: 25,
      fontWeight: FontWeight.w600,
      color: color,

      /// Medium
    );
  }
}