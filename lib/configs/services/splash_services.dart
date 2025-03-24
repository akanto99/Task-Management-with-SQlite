import 'package:flutter/material.dart';
import 'package:razinsoft_task_management/view/navigation_bar.dart';

class SplashService {
  Future<void> navigateAfterDelay(BuildContext context) async {
    await Future.delayed(Duration(seconds: 2));
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => NavigationScreen()),
    );
  }
}
