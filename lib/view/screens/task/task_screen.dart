import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:razinsoft_task_management/configs/responsive/responsive_ui.dart';

import '../../../provider/DarkAndLightTheme/theme_provider.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
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



            SizedBox(height: screenHeight * 0.02,),

          ],
        ));
  }
}
