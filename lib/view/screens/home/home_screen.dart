import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:razinsoft_task_management/configs/responsive/responsive_ui.dart';
import 'package:razinsoft_task_management/configs/services/database_services/database_services.dart';
import 'package:razinsoft_task_management/model/taskmodel.dart';
import 'package:razinsoft_task_management/provider/DarkAndLightTheme/theme_provider.dart';

import '../../../configs/res/color.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final DatabaseService _databaseService = DatabaseService.instance;


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFFFFFFF),
            Color(0xFFDFE4F1),
          ],
        ),
      ),
      child: FutureBuilder<List<TaskModel>>(
        future: _databaseService.getTasks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator()); // Show loading indicator
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}")); // Show error message
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No tasks available")); // Handle empty data case
          }

          // ✅ Filter tasks based on status
          int assignedTask = snapshot.data!.where((task) => task.status == 0).length;
          int completedTask = snapshot.data!.where((task) => task.status == 1).length;

          return Column(
            children: [
              Text("Assigned Task : $assignedTask"),
              Text("Completed Task : $completedTask"),

              Expanded(
                child: ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    TaskModel task = snapshot.data![index];
                    return ListTile(
                      title: Text(task.title),
                      subtitle: Text(task.startTime),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TaskDetailScreen(task: task),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
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
