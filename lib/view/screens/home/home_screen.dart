import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:razinsoft_task_management/configs/res/text_styles.dart';
import 'package:razinsoft_task_management/configs/responsive/responsive_ui.dart';
import 'package:razinsoft_task_management/configs/services/database_services/database_services.dart';
import 'package:razinsoft_task_management/model/taskmodel.dart';
import 'package:razinsoft_task_management/provider/DarkAndLightTheme/theme_provider.dart';
import 'package:razinsoft_task_management/view/screens/home/details_screen.dart';

import '../../../configs/res/color.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final DatabaseService _databaseService = DatabaseService.instance;
  bool isActiveWorkerSelected = true;
  String greeting = "";
  String currentDate = "";

  @override
  void initState() {
    super.initState();
    _setGreeting();
    _getCurrentDate();
  }

  void _getCurrentDate() {
    currentDate = DateFormat('dd MMMM yyyy').format(DateTime.now());
  }

  void _setGreeting() {
    DateTime now = DateTime.now();
    int hour = now.hour;

    if (hour >= 5 && hour < 12) {
      greeting = "Good Morning";
    } else if (hour >= 12 && hour < 17) {
      greeting = "Good Afternoon";
    } else if (hour >= 17 && hour < 21) {
      greeting = "Good Evening";
    } else {
      greeting = "Good Night";
    }
  }
  String formattedDate(String date) {
    try {
      DateTime parsedDate = DateFormat('dd/MM/yyyy').parse(date);
      return DateFormat('MMMM dd, yyyy').format(parsedDate);
    } catch (e) {
      return date; // Return original in case of error
    }
  }

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

          return Center(
            child: Container(
              width:screenWidth*0.9 ,

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [


                  ///Gretting Section
                  SizedBox(height: screenHeight *0.02,),
               Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: [
                   Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Text('$greeting Liam !', style: AppTextStyles.poppins12Regular),
                       Text('$currentDate', style: AppTextStyles.poppins16Medium),
                     ],
                   ),
                   Icon(Icons.notifications)
                 ],
               ),
                  SizedBox(height: screenHeight *0.02,),


                  ///Summary Section
                  Text('Summary', style: AppTextStyles.poppins20Medium),
                  SizedBox(height: screenHeight *0.01,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: screenWidth*0.435,
                        height: screenHeight *0.115,
                        decoration: BoxDecoration(
                          color: Color(0xffEEEFFF),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            width: 1,
                            color: AppColors.blueViolet
                          )
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Assigned tasks', style: AppTextStyles.poppins14Medium),
                              Text('$assignedTask', style: AppTextStyles.poppins24WithColor(color: AppColors.blueViolet)),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: screenWidth*0.435,
                        height: screenHeight *0.115,
                        decoration: BoxDecoration(
                            color: Color(0xffDEFFE8),
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                                width: 1,
                                color: AppColors.junglegreen
                            )
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Completed tasks', style: AppTextStyles.poppins14Medium),
                              Text('$completedTask', style: AppTextStyles.poppins24WithColor(color: AppColors.junglegreen)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight *0.02,),


                  ///All Task
                  Text('Today tasks', style: AppTextStyles.poppins20Medium),
                  SizedBox(height: screenHeight *0.01,),
                  Container(
                    width: screenWidth,
                    height: screenHeight*0.055,
                    decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        width: 1,
                        color: Color(0xffDCE1EF),
                      )

                    ),

                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildWorkerSection(
                            context,
                            "All tasks",
                            isActiveWorkerSelected,
                                () {
                              setState(() {
                                isActiveWorkerSelected = true;
                              });
                            },
                          ),
                          _buildWorkerSection(
                            context,
                            "Completed",
                            !isActiveWorkerSelected,
                                () {
                              setState(() {
                                isActiveWorkerSelected = false;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: screenHeight *0.01,),
                  /// Content Section
                  Expanded(
                    child: Container(
                      width: screenWidth,
                      decoration: BoxDecoration(
                        // color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: isActiveWorkerSelected
                          ? ListView.builder(
                        itemCount: snapshot.data!.length + 1,  // Increase item count by 1
                        itemBuilder: (context, index) {
                          if (index == snapshot.data!.length) {
                            // Extra space after the last item
                            return SizedBox(height: screenHeight *0.1);
                          }

                          TaskModel task = snapshot.data![index];
                          return Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => TaskDetailsScreen(task: task),
                                    ),
                                  );
                                },
                                child: Container(
                                  width: screenWidth,
                                  height: screenHeight * 0.18,
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: AppColors.whiteColor,
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                      width: 1,
                                      color: Color(0xffDCE1EF),
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        children: [
                                          Container(
                                            width: screenWidth,
                                            child: Text(
                                              task.title,
                                              style: AppTextStyles.poppins16Medium,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          SizedBox(height: screenHeight * 0.005),
                                          Container(
                                            width: screenWidth,
                                            child: Text(
                                              task.description,
                                              style: AppTextStyles.poppins12Regular,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(Icons.timer_sharp),
                                              SizedBox(width: screenWidth * 0.02),
                                              Text(
                                                formattedDate(task.endTime),
                                                style: AppTextStyles.poppins12Regular,
                                              ),
                                            ],
                                          ),
                                          Container(
                                            height: screenHeight * 0.045,
                                            width: task.status == 1
                                                ? screenWidth * 0.32
                                                : screenWidth * 0.2,
                                            decoration: BoxDecoration(
                                              color: task.status == 1
                                                  ? Color(0xffEEFFE0)
                                                  : Color(0xffF0EDFD),
                                              borderRadius: BorderRadius.circular(25),
                                            ),
                                            child: Center(
                                              child: Text(
                                                task.status == 1 ? "Completed" : "Todo",
                                                style: AppTextStyles.poppins16WithColor(
                                                  color: task.status == 1
                                                      ? AppColors.junglegreen
                                                      : AppColors.blueViolet,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.01),
                            ],
                          );
                        },
                      )
                          : Center(
                          child: Text("Completed Tasks", style: TextStyle(fontSize: 20))),

                    ),
                  ),

                ],
              ),
            ),
          );
        },
      ),
    );
  }
  Widget _buildWorkerSection(BuildContext context, String title, bool isSelected, VoidCallback onTap) {
    final screenHeight = MediaQuery.of(context).size.height * 1;
    final screenWidth = MediaQuery.of(context).size.width * 1;
    return GestureDetector(
      onTap: onTap,
      child: Expanded(
        child: Container(
          width: screenWidth* 0.43,
          height: screenHeight,
          decoration: BoxDecoration(
            color: isSelected ? AppColors.blueViolet : Colors.white,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Center(
            child: Text(title,
              style: AppTextStyles.poppins16WithColor(
                  color: isSelected ? AppColors.whiteColor: AppColors.textgreyColor
              ),
            ),
          ),
        ),
      ),
    );
  }
}


