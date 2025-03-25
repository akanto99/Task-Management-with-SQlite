import 'package:flutter/material.dart';
import 'package:razinsoft_task_management/configs/res/color.dart';
import 'package:razinsoft_task_management/configs/res/text_styles.dart';
import 'package:razinsoft_task_management/configs/services/splash_services.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    SplashService().navigateAfterDelay(context);
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: Container(
          height: screenHeight,
          width: screenWidth,
          decoration: BoxDecoration(
            gradient:LinearGradient(
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
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: screenHeight * 0.2,
                width: screenWidth*0.45,
                child: Image.asset('assets/images/splash/dart.png'),
              ),

              SizedBox(height: screenHeight*0.02),
              Text(
                'KEEP IN TOUCH',
                style:AppTextStyles.poppins14Medium,
              ),
              Text(
                'WITH US',
             style:AppTextStyles.poppins12Regular,
              ),
              SizedBox(height: screenHeight*0.02),
              Container(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: AppColors.blueViolet,
                  strokeWidth: 3,
                  backgroundColor:  AppColors.whiteColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
