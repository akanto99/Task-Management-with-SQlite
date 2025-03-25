import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:razinsoft_task_management/configs/responsive/responsive_ui.dart';
import 'package:razinsoft_task_management/configs/services/database_services/database_services.dart';
import 'package:razinsoft_task_management/model/taskmodel.dart';
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
          SizedBox(height: screenHeight * 0.02),

          Center(
            child: Container(
              height: 80,
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
                    height: isSelected ? 65 : 50,
                    width: isSelected ? 80 : 50,
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.blue : Colors.grey.shade300,
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
                          style: TextStyle(
                            fontSize: isSelected ? 12 : 10,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          monthDates[index]['date']!,
                          style: TextStyle(
                            fontSize: isSelected ? 18 : 14,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.white : Colors.black,
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

          SizedBox(height: screenHeight * 0.02),
          Expanded(
            child: Container(
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

                  // ✅ Convert selectedIndex to DateTime
                  DateTime now = DateTime.now();
                  DateTime selectedDate = DateTime(now.year, now.month, selectedIndex + 1);

                  // ✅ Filter tasks based on selected date
                  List<TaskModel> filteredTasks = snapshot.data!.where((task) {
                    // Parse start and end dates
                    DateTime startDate = DateFormat('dd/MM/yyyy').parse(task.startTime);
                    DateTime endDate = DateFormat('dd/MM/yyyy').parse(task.endTime);

                    // Check if selectedDate falls within the range
                    return selectedDate.isAfter(startDate.subtract(Duration(days: 1))) &&
                        selectedDate.isBefore(endDate.add(Duration(days: 1)));
                  }).toList();

                  // ✅ Count assigned and completed tasks
                  int assignedTask = filteredTasks.where((task) => task.status == 0).length;
                  int completedTask = filteredTasks.where((task) => task.status == 1).length;

                  return Column(
                    children: [
                      Text("Assigned Task : $assignedTask"),
                      Text("Completed Task : $completedTask"),
                      Expanded(
                        child: ListView.builder(
                          itemCount: filteredTasks.length,
                          itemBuilder: (context, index) {
                            TaskModel task = filteredTasks[index];
                            return ListTile(
                              title: Text(task.title),
                              subtitle: Text(task.startTime),
                              trailing: Text(task.endTime),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TaskDetailsScreen(task: task),
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

            ),
          ),
          SizedBox(height: screenHeight * 0.02),
        ],
      ),
    );
  }
}

