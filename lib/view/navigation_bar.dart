import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:razinsoft_task_management/configs/res/color.dart';
import 'package:razinsoft_task_management/provider/DarkAndLightTheme/theme_provider.dart';
import 'package:razinsoft_task_management/view/screens/calender/calender_screen.dart';
import 'package:razinsoft_task_management/view/screens/home/home_screen.dart';
import 'package:razinsoft_task_management/view/screens/task/task_screen.dart';

class NavigationScreen extends StatefulWidget {

  const NavigationScreen({super.key, });

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  int _currentIndex = 0;

  final List<String> selectedIcons = [
    "assets/images/navbar/homebg.svg",
    "assets/images/navbar/assignbg.svg",
    "assets/images/navbar/calbg.svg",
  ];

  final List<String> unselectedIcons = [
    "assets/images/navbar/home.svg",
    "assets/images/navbar/assign.svg",
    "assets/images/navbar/cal.svg",
  ];

  final List<Widget> _pages = [
    HomeScreen(),
    TaskScreen(),
    CalenderScreen(),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          _pages[_currentIndex],

          // Bottom Navigation Bar
          Positioned(
            bottom: 15,
            child: Container(
              width: screenWidth * 0.9,
              height: screenHeight * 0.08,
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(50),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(3, (index) {
                  return _buildNavItem(index);
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isSelected = _currentIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(7.0),
        child: Container(
          width: screenWidth * 0.26,
          decoration: BoxDecoration(
            color: isSelected ? AppColors.navOpacity : AppColors.whiteColor,
            borderRadius: BorderRadius.circular(50),
          ),
          child: Center(
            child: SvgPicture.asset(
              isSelected ? selectedIcons[index] : unselectedIcons[index],
              width: 40,
              height: 40,
            ),
          ),
        ),
      ),
    );
  }
}
