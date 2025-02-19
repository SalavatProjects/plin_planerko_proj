import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:plinplanerko/ui_kit/app_colors.dart';
import 'package:plinplanerko/ui_kit/app_styles.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
              padding: EdgeInsets.symmetric(vertical: 24.w, horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Settings', style: AppStyles.quicksandW600DarkGray(28.sp),),
                  SizedBox(height: 32.w,),
                  Center(
                    child: Image.asset(
                      'assets/images/plin_planerko.png',
                      width: MediaQuery.of(context).size.width * 0.45, fit: BoxFit.fitWidth,),
                  ),
                  SizedBox(height: 32.w,),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 116.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24.r),
                      color: AppColors.white
                    ),
                    padding: EdgeInsets.all(12.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CupertinoButton(
                          onPressed: () {},
                          padding: EdgeInsets.zero,
                          child: SizedBox(
                            width: 140.w,
                            height: 34.w,
                            child: Row(
                              children: [
                                SvgPicture.asset('assets/icons/contact us.svg', width: 22.w, fit: BoxFit.fitWidth,),
                                SizedBox(width: 14.w,),
                                Text('Contact us', style: AppStyles.quicksandW600DarkGray(18.sp),)
                              ],
                            ),
                          ),
                        ),
                        CupertinoButton(
                          onPressed: () {},
                          padding: EdgeInsets.zero,
                          child: SizedBox(
                            width: 170.w,
                            height: 34.w,
                            child: Row(
                              children: [
                                SvgPicture.asset('assets/icons/privacy policy.svg', width: 22.w, fit: BoxFit.fitWidth,),
                                SizedBox(width: 14.w,),
                                Text('Privacy Policy', style: AppStyles.quicksandW600DarkGray(18.sp),)
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
          )),
    );
  }
}
