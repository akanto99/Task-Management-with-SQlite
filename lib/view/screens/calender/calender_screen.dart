import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:razinsoft_task_management/configs/res/color.dart';
import 'package:razinsoft_task_management/configs/res/text_styles.dart';
import 'package:razinsoft_task_management/configs/responsive/responsive_ui.dart';
import 'package:razinsoft_task_management/configs/services/database_services/database_services.dart';
import 'package:razinsoft_task_management/model/taskmodel.dart';
import 'package:razinsoft_task_management/view/navigation_bar.dart';
import 'package:razinsoft_task_management/view/screens/home/details_screen.dart';

class CalenderScreen extends StatefulWidget {
  const CalenderScreen({super.key});

  @override
  State<CalenderScreen> createState() => _CalenderScreenState();
}

class _CalenderScreenState extends State<CalenderScreen> {
  late int selectedIndex;
  late PageController _pageController;

  final DatabaseService _databaseService = DatabaseService.instance;

  @override
  void initState() {
    super.initState();
    List<Map<String, String>> monthDates = getCurrentMonthDates();

    // Get current date index
    DateTime now = DateTime.now();
    selectedIndex = now.day - 1; // Index starts from 0

    // Initialize PageController with initialPage set to selectedIndex
    _pageController = PageController(viewportFraction: 0.17, initialPage: selectedIndex);
  }

  // Generate all dates of the current month dynamically
  List<Map<String, String>> getCurrentMonthDates() {
    DateTime now = DateTime.now();
    DateTime firstDay = DateTime(now.year, now.month, 1);
    DateTime lastDay = DateTime(now.year, now.month + 1, 0);

    return List.generate(lastDay.day, (index) {
      DateTime date = firstDay.add(Duration(days: index));
      return {
        "day": DateFormat('E').format(date),
        "date": DateFormat('d').format(date),
      };
    });
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
        ),
      ),
    );
  }

  Widget body() {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    List<Map<String, String>> monthDates = getCurrentMonthDates();

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
      child: Column(
        children: [
          SizedBox(height: screenHeight * 0.04),
          Container(
            width: screenWidth * 0.9,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('All Task', style: AppTextStyles.poppins20Medium),
                GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>NavigationScreen(initialIndex: 1,)));
                  },
                  child: Container(
                    height: screenHeight * 0.045,
                    width: screenWidth * 0.3,
                    decoration: BoxDecoration(
                      color: Color(0xffEEEFFF),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        "Create New",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.blueViolet,

                          /// Medium
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: screenHeight * 0.04),

          Container(
            height: screenHeight*0.14,
            width: screenWidth,
            color: AppColors.whiteColor,
            child: Center(
              child: Container(
                height: screenHeight*0.09,

               child: PageView.builder(
                controller: _pageController,
                itemCount: monthDates.length,
                physics: BouncingScrollPhysics(),
                onPageChanged: (index) {
                  setState(() {
                    selectedIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  bool isSelected = index == selectedIndex;

                  return Center(
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      margin: EdgeInsets.symmetric(horizontal: 3),
                      height: isSelected ? screenHeight*0.08 : screenHeight*0.07,
                      width: isSelected ? screenWidth *0.16 : screenWidth *0.15,
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.blueViolet : Color(0xffEEEFFF),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: isSelected
                            ? [
                          BoxShadow(
                            color: Colors.blueAccent.withOpacity(0.3),
                            blurRadius: 10,
                            spreadRadius: 2,
                          )
                        ]
                            : [],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            monthDates[index]['day']!,
                            style: GoogleFonts.poppins(
                              fontSize: isSelected ? 13 : 12,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              color: isSelected ? AppColors.whiteColor : AppColors.blueViolet,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            monthDates[index]['date']!,
                            style: GoogleFonts.poppins(
                              fontSize: isSelected ? 18 : 15,
                              fontWeight: FontWeight.bold,
                              color: isSelected ? AppColors.whiteColor : AppColors.blueViolet,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                           ),

            ),
            ),
          ),

          SizedBox(height: screenHeight * 0.02),
          Expanded(
            child: Container(
              width: screenWidth*0.90,
              child:  FutureBuilder<List<TaskModel>>(
                future: _databaseService.getTasks(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text("No tasks available"));
                  }

                  /// Convert selectedIndex to DateTime
                  DateTime now = DateTime.now();
                  DateTime selectedDate = DateTime(now.year, now.month, selectedIndex + 1);

                  /// Filter
                  List<TaskModel> filteredTasks = snapshot.data!.where((task) {

                    /// Parse start and end dates
                    DateTime startDate = DateFormat('dd/MM/yyyy').parse(task.startTime);
                    DateTime endDate = DateFormat('dd/MM/yyyy').parse(task.endTime);
                    return selectedDate.isAfter(startDate.subtract(Duration(days: 1))) &&
                        selectedDate.isBefore(endDate.add(Duration(days: 1)));
                  }).toList();

                  return ListView.builder(
                    itemCount:filteredTasks.length + 1,
                    itemBuilder: (context, index) {
                      if (index == filteredTasks.length) {
                        /// Extra space after the last item
                        return SizedBox(height: screenHeight *0.1);
                      }

                      TaskModel task = filteredTasks[index];
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
                  );
                },
              ),

            ),
          ),

        ],
      ),
    );
  }
}

