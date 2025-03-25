import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:razinsoft_task_management/configs/res/color.dart';
import 'package:razinsoft_task_management/configs/res/components/round_button.dart';
import 'package:razinsoft_task_management/configs/res/text_styles.dart';
import 'package:razinsoft_task_management/configs/responsive/responsive_ui.dart';
import 'package:razinsoft_task_management/configs/services/database_services/database_services.dart';
import 'package:razinsoft_task_management/configs/widgets/customtext_with_formfield.dart';
import 'package:razinsoft_task_management/configs/widgets/datepicker_with_formfield.dart';
import 'package:razinsoft_task_management/model/taskmodel.dart';
import 'package:razinsoft_task_management/provider/DarkAndLightTheme/theme_provider.dart';
import 'package:razinsoft_task_management/view/navigation_bar.dart';

class TaskDetailsScreen extends StatefulWidget {
  final TaskModel task;

  const TaskDetailsScreen({super.key, required this.task});

  @override
  State<TaskDetailsScreen> createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
  final DatabaseService _databaseService = DatabaseService.instance;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isLoading = false;
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _startTimeController;
  late TextEditingController _endTimeController;

  String currentDate = "";
  void _getCurrentDate() {
    currentDate = DateFormat('MMMM dd, yyyy').format(DateTime.now());
  }

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
    _descriptionController = TextEditingController(
      text: widget.task.description,
    );
    _startTimeController = TextEditingController(text: widget.task.startTime);
    _endTimeController = TextEditingController(text: widget.task.endTime);
    _getCurrentDate();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _startTimeController.dispose();
    _endTimeController.dispose();
    super.dispose();
  }

  Future<void> _deleteTask() async {
    bool? confirmDelete = await showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Delete Task"),
            content: const Text("Are you sure you want to delete this task?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(context, true);
                  await _databaseService.deleteTask(widget.task.id.toString());
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Task deleted successfully!')),
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NavigationScreen()),
                  );
                },
                child: const Text(
                  "Delete",
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ResPonsiveUi(mobile: body(), desktop: body(), tablet: body()),
      ),
    );
  }

  Widget body() {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Form(
      key: formKey,
      child: Container(
        width: screenWidth,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFFFFF),
              Color(0xFFDFE4F1),
              Color(0xFFDFE4F1)],
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
                  Row(
                    children: [
                      InkWell(
                          onTap: (){
                            Navigator.pop(context);
                          },
                          child: Icon(CupertinoIcons.arrow_left, size: 28)),
                      SizedBox(width: screenWidth * 0.03),
                      Text('View Task', style: AppTextStyles.poppins20Medium),
                    ],
                  ),
                  GestureDetector(
                    onTap: _deleteTask,
                    child: Container(
                      height: screenHeight * 0.045,
                      width: screenWidth * 0.23,
                      decoration: BoxDecoration(
                        color: Color(0xffFFE1E2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          "Delete",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.red,

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
              width: screenWidth,

              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(20),
              ),
              padding: EdgeInsets.only(top: 30, bottom: 35),
              child: Column(
                children: [
                  CustomTextFieldWithFormField(
                    titleText: "Task Name",
                    placeholder: "Enter Task Title",
                    controller: _titleController,
                    // dynamicheight: screenHeight * 0.055,
                    validator: (value) {
                      if (_titleController.text == null ||
                          _titleController.text.isEmpty) {
                        return 'Task Title is required.';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: screenHeight * 0.015),
                  CustomTextFieldWithFormField(
                    titleText: "Task description",
                    placeholder:
                        "Optimize the user interface for our mobile app, ensuring a seamless and delightful user experience. Consider incorporating user feedback and modern design trends to enhance usability and aesthetics.\n",
                    controller: _descriptionController,
                    // dynamicheight: screenHeight * 0.15,
                    keyboardType: TextInputType.multiline,
                    validator: (value) {
                      if (_descriptionController.text == null ||
                          _descriptionController.text.isEmpty) {
                        return 'Description is required.';
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
                          controller: _startTimeController,
                          validator: (value) {
                            if (_startTimeController.text == null ||
                                _startTimeController.text.isEmpty) {
                              return 'Start Date is required.';
                            }
                            return null;
                          },
                        ),

                        /// End Time
                        CustomDatePickerFormField(
                          title: "End Date",
                          labelText: "$currentDate",
                          controller: _endTimeController,
                          validator: (value) {
                            if (_endTimeController.text == null ||
                                _endTimeController.text.isEmpty) {
                              return 'End Date is required.';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.04),
                  Container(
                    width: screenWidth * 0.90,
                    child: RoundButton(
                      title: "Complete",
                      loading: isLoading,
                      onPress: () async {
                        if (formKey.currentState!.validate()) {
                          setState(() => isLoading = true);
                          try {
                            TaskModel updatedTask = TaskModel(
                              id: widget.task.id,
                              title: _titleController.text,
                              description: _descriptionController.text,
                              startTime: _startTimeController.text,
                              endTime: _endTimeController.text,
                              status: 1,
                            );

                            await _databaseService.updateTask(updatedTask);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Task updated successfully!'),
                                backgroundColor: Colors.green,
                              ),
                            );
                            await Future.delayed(const Duration(seconds: 2));
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => NavigationScreen(),
                              ),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Failed to update task! Error: $e',
                                ),
                                backgroundColor: Colors.red,
                              ),
                            );
                          } finally {
                            setState(() => isLoading = false);
                          }
                        }
                      },
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.02),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
