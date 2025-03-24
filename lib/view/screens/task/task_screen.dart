import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:razinsoft_task_management/configs/res/components/round_button.dart';
import 'package:razinsoft_task_management/configs/responsive/responsive_ui.dart';
import 'package:razinsoft_task_management/configs/services/database_services/database_services.dart';
import 'package:razinsoft_task_management/configs/widgets/customtext_with_formfield.dart';
import 'package:razinsoft_task_management/configs/widgets/datepicker_with_formfield.dart';
import '../../../provider/DarkAndLightTheme/theme_provider.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  final DatabaseService _databaseService = DatabaseService.instance;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isLoading = false;

  late TextEditingController taskTitle;
  late TextEditingController taskDes;
  late TextEditingController taskStartTime;
  late TextEditingController taskEndTime;

  @override
  void initState() {
    super.initState();
    taskTitle = TextEditingController();
    taskDes = TextEditingController();
    taskStartTime = TextEditingController();
    taskEndTime = TextEditingController();
  }

  @override
  void dispose() {
    taskTitle.dispose();
    taskDes.dispose();
    taskStartTime.dispose();
    taskEndTime.dispose();
    super.dispose();
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
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Form(
      key: formKey,
      child: Container(
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
        child: Column(
          children: [
            SizedBox(height: screenHeight * 0.02),

            // Task Title
            CustomTextFieldWithFormField(
              titleText: "Title",
              placeholder: "Enter Title",
              controller: taskTitle,
              onChanged: (value) {
                setState(() {});
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Title is required.';
                }
                return null;
              },
            ),

            // Task Description
            CustomTextFieldWithFormField(
              titleText: "Description",
              placeholder: "Enter Description",
              controller: taskDes,
              onChanged: (value) {
                setState(() {});
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Description is required.';
                }
                return null;
              },
            ),

            // Start Time
            CustomDatePickerFormField(
              title: "Start Time",
              labelText: 'dd/mm/yyyy',
              controller: taskStartTime,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Start Time is required.';
                }
                return null;
              },
            ),

            // End Time
            CustomDatePickerFormField(
              title: "End Time",
              labelText: 'dd/mm/yyyy',
              controller: taskEndTime,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'End Time is required.';
                }
                return null;
              },
            ),

            // Create Button
            Container(
              width: screenWidth * 0.80,
              alignment: Alignment.centerLeft,
              child: RoundButton(
                title: "Create",
                loading: isLoading,
                onPress: () async {
                  if (formKey.currentState!.validate()) {
                    print("Form is valid, proceeding with insertion...");
                    setState(() {
                      isLoading = true;
                    });

                    await Future.delayed(Duration(seconds: 2));

                    try {
                      await _databaseService.addTask(
                        taskTitle.text,
                        taskDes.text,
                        taskStartTime.text,
                        taskEndTime.text,
                      );

                      print("Task successfully inserted into database!");

                      setState(() {
                        isLoading = false;
                      });

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Task created successfully!'),
                          backgroundColor: Colors.green,
                        ),
                      );

                      taskTitle.clear();
                      taskDes.clear();
                      taskStartTime.clear();
                      taskEndTime.clear();
                    } catch (e) {
                      setState(() {
                        isLoading = false;
                      });

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Failed to create task! Error: $e'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  } else {
                    print("Form is not valid.");
                  }
                },

              ),
            ),

            SizedBox(height: screenHeight * 0.02),
          ],
        ),
      ),
    );
  }
}
