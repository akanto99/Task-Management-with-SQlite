import 'package:flutter/material.dart';
import 'package:razinsoft_task_management/configs/utils/routes/routes_name.dart';
import 'package:razinsoft_task_management/view/screens/calender/calender_screen.dart';
import 'package:razinsoft_task_management/view/screens/home/home_screen.dart';
import 'package:razinsoft_task_management/view/screens/task/task_screen.dart';
import 'package:razinsoft_task_management/view/splash_screen/splash_view.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesName.splash:
        return MaterialPageRoute(builder: (BuildContext context) => const SplashScreen());
      case RoutesName.homeScreen:
        return MaterialPageRoute(builder: (BuildContext context) => const HomeScreen());
      case RoutesName.taskScreen:
        return MaterialPageRoute(builder: (BuildContext context) => const TaskScreen());
      case RoutesName.calenderScreen:
        return MaterialPageRoute(builder: (BuildContext context) => const CalenderScreen());


      default:
        return _errorRoute();






    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return const Scaffold(
        body: Center(
          child: Text('No route defined'),
        ),
      );
    });
  }
}
