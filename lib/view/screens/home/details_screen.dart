import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:razinsoft_task_management/configs/res/components/round_button.dart';
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

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
    _descriptionController = TextEditingController(text: widget.task.description);
    _startTimeController = TextEditingController(text: widget.task.startTime);
    _endTimeController = TextEditingController(text: widget.task.endTime);
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
      builder: (context) => AlertDialog(
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
              Navigator.push(context, MaterialPageRoute(builder: (context)=>NavigationScreen()));
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
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
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Form(
      key: formKey,
      child: Container(
        width: screenWidth,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFFFFF), Color(0xFFDFE4F1)],
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: screenHeight * 0.02),

            TextButton(
              onPressed: _deleteTask,
              child: const Text("Delete"),
            ),

            CustomTextFieldWithFormField(
              titleText: "Title",
              placeholder: "Enter Title",
              controller: _titleController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Title is required.';
                }
                return null;
              },
            ),

            CustomTextFieldWithFormField(
              titleText: "Description",
              placeholder: "Enter Description",
              controller: _descriptionController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Description is required.';
                }
                return null;
              },
            ),

            CustomDatePickerFormField(
              title: "Start Time",
              labelText: 'dd/mm/yyyy',
              controller: _startTimeController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Start Time is required.';
                }
                return null;
              },
            ),

            CustomDatePickerFormField(
              title: "End Time",
              labelText: 'dd/mm/yyyy',
              controller: _endTimeController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'End Time is required.';
                }
                return null;
              },
            ),

            Container(
              width: screenWidth * 0.80,
              alignment: Alignment.centerLeft,
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
                        const SnackBar(content: Text('Task updated successfully!'), backgroundColor: Colors.green),
                      );
                      await Future.delayed(const Duration(seconds: 2));
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => NavigationScreen()));
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to update task! Error: $e'), backgroundColor: Colors.red),
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
    );
  }
}
