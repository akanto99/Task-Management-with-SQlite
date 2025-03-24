import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:razinsoft_task_management/configs/responsive/responsive_ui.dart';
import 'package:razinsoft_task_management/provider/DarkAndLightTheme/theme_provider.dart';

import '../../../configs/res/color.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          // backgroundColor: Colors.white,
          body: ResPonsiveUi(
        mobile: body(),
        desktop: body(),
        tablet: body(),
      )),
    );
  }

  Widget body() {
    final screenHeight = MediaQuery.of(context).size.height * 1;
    final screenWidth = MediaQuery.of(context).size.width * 1;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Container(
        width: screenWidth,
        decoration: BoxDecoration(
          gradient:LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFFFFFFF),
                    Color(0xFFDFE4F1),
                  ],
                ),
        ),
        child: Column(
          children: [
            SizedBox(
              height: screenHeight * 0.02,
            ),

            TitleContainer("Trending items"),


            SizedBox(height: screenHeight * 0.02,),

          ],
        ));
  }

  Widget TitleContainer(String title){
    final screenHeight = MediaQuery.of(context).size.height * 1;
    final screenWidth = MediaQuery.of(context).size.width * 1;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    return Container(
      width: screenWidth * 0.90,
      child: Text(
          title,
          style: GoogleFonts.urbanist(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: isDarkMode ? AppColors.whiteColor : AppColors.blackColor,
            letterSpacing: 0.8,
          )),
    );
  }
}
