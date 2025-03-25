import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../provider/DarkAndLightTheme/theme_provider.dart';
import '../color.dart';

class RoundButton extends StatelessWidget {

  final String title ;
  final bool loading ;
  final VoidCallback onPress ;
  const RoundButton({Key? key ,
    required this.title,
    this.loading = false ,
     required this.onPress ,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height * 1;
    final screenWidth = MediaQuery.of(context).size.width * 1;

    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return InkWell(
      onTap: onPress,
      child: Container(
        height: screenHeight*0.06,
        width: screenWidth*0.45,
        decoration: BoxDecoration(
          color:AppColors.blueViolet,
          borderRadius: BorderRadius.circular(30)
        ),
        child: Center(
            child:loading ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(color: Colors.white,)) :  AutoSizeText(title ,
              style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: isDarkMode ? AppColors.whiteColor : AppColors.whiteColor,
              letterSpacing: 0.8,
            )
            )),
      ),
    );
  }
}
