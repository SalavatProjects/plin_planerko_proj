import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:plinplanerko/pages/bottom_nav_bar_screen.dart';
import 'package:plinplanerko/ui_kit/app_colors.dart';
import 'package:plinplanerko/ui_kit/app_styles.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage('assets/images/Onbording.png'), fit: BoxFit.fill)
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CupertinoButton(
                    onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (BuildContext context) => BottomNavBarScreen())),
                    padding: EdgeInsets.zero,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 50.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25.r),
                        color: AppColors.white,
                      ),
                      child: Center(
                          child: Text('Continue', style: AppStyles.quicksandW600Primary(18.sp),)),
                    )
                ),
                SizedBox(height: 16.w,)
              ],
            ),
          ),
        ),
        ),
    );
  }
}
