import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:razinsoft_task_management/configs/res/color.dart';
import 'package:razinsoft_task_management/configs/res/components/round_button.dart';
import 'package:razinsoft_task_management/configs/res/text_styles.dart';
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


  String currentDate = "";
  void _getCurrentDate() {
    currentDate = DateFormat('MMMM dd, yyyy').format(DateTime.now());
  }


  @override
  void initState() {
    super.initState();
    taskTitle = TextEditingController();
    taskDes = TextEditingController();
    taskStartTime = TextEditingController();
    taskEndTime = TextEditingController();
    _getCurrentDate();
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
        width: screenWidth ,
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
              width: screenWidth *0.9,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Create New Task', style: AppTextStyles.poppins20Medium),
                  SizedBox()
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.04),
        Container(
          width: screenWidth,

          decoration: BoxDecoration(
              color: AppColors.whiteColor,
            borderRadius: BorderRadius.circular(20)
          ),
          padding: EdgeInsets.only(top: 30,bottom: 35),
          child: Column(
            children: [
              // Task Title
              CustomTextFieldWithFormField(
                titleText: "Task Name",
                // dynamicheight: screenHeight*0.055,
                placeholder: "Enter Your Task Name",
                controller: taskTitle,
                onChanged: (value) {
                  setState(() {});
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Task Name is required.';
                  }
                  return null;
                },
              ),
              SizedBox(height: screenHeight * 0.015),
              // Task Description
              CustomTextFieldWithFormField(
                titleText: "Task description",
                placeholder: "Optimize the user interface for our mobile app, ensuring a seamless and delightful user experience. Consider incorporating user feedback and modern design trends to enhance usability and aesthetics.\n",
                controller: taskDes,
                // dynamicheight: screenHeight*0.15,
                keyboardType: TextInputType.multiline,
                onChanged: (value) {
                  setState(() {});
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Task description is required.';
                  }
                  return null;
                },
              ),
              SizedBox(height: screenHeight * 0.015),

              Container(
                width: screenWidth * 0.9,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    /// Start Time
                    CustomDatePickerFormField(
                      title: "Start Date",
                      labelText: "$currentDate",
                      controller: taskStartTime,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Start Date is required.';
                        }
                        return null;
                      },
                    ),

                    /// End Time
                    CustomDatePickerFormField(
                      title: "End Date",
                      labelText: "$currentDate",
                      controller: taskEndTime,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'End Date is required.';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: screenHeight * 0.04),
              // Create Button
              Container(
                width: screenWidth * 0.90,
                child: RoundButton(
                  title: "Create new tasks",
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
              
            ],
          ),

        ),
            SizedBox(height: screenHeight * 0.02),
          ],
        ),
      ),
    );
  }
}
