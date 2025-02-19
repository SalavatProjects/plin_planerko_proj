import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:blur/blur.dart';
import 'package:plinplanerko/pages/archive_page.dart';
import 'package:plinplanerko/pages/home_page.dart';
import 'package:plinplanerko/pages/settings_page.dart';

import '../ui_kit/app_colors.dart';
import '../ui_kit/app_styles.dart';
import '../utils/constants.dart';

class BottomNavBarScreen extends StatefulWidget {
  const BottomNavBarScreen({super.key});

  @override
  State<BottomNavBarScreen> createState() => _BottomNavBarScreenState();
}

class _BottomNavBarScreenState extends State<BottomNavBarScreen> {
  int _currentPage = 0;

  final List<Widget> _pages = [
    HomePage(),
    ArchivePage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        SafeArea(child: _pages[_currentPage]),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
              padding: EdgeInsets.all(34.w),
            child: Blur(
                borderRadius: BorderRadius.circular(31.r),
              overlay: Padding(
                padding: EdgeInsets.all(4.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _BottomNavBarBtn(
                        text: 'Home',
                        imagePath: 'assets/icons/home.svg',
                        isSelected: _currentPage == 0,
                        onPressed: () {
                          setState(() {
                            _currentPage = 0;
                          });
                        }),
                    _BottomNavBarBtn(
                        text: 'Archive',
                        imagePath: 'assets/icons/archive.svg',
                        isSelected: _currentPage == 1,
                        onPressed: () {
                          setState(() {
                            _currentPage = 1;
                          });
                        }),
                    _BottomNavBarBtn(
                        text: 'Settings',
                        imagePath: 'assets/icons/settings.svg',
                        isSelected: _currentPage == 2,
                        onPressed: () {
                          setState(() {
                            _currentPage = 2;
                          });
                        }),
                  ],
                ),
              ),
                child: Container(
                  width: 260.w,
                  height: 62.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(31.r),
                    color: AppColors.black.withValues(alpha: 0.2)
                  ),
                ),
            ),
          ),
        )
      ],
      ),
    );
  }
}

class _BottomNavBarBtn extends StatelessWidget {
  String text;
  String imagePath;
  bool isSelected;
  void Function() onPressed;

  _BottomNavBarBtn({
    super.key,
    required this.text,
    required this.imagePath,
    this.isSelected = false,
    required this.onPressed
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: onPressed,
      padding: EdgeInsets.zero,
      child: AnimatedContainer(
        duration: AppConstants.duration200,
        height: 54.w,
        decoration: isSelected ? BoxDecoration(
            borderRadius: BorderRadius.circular(27.r),
            color: AppColors.primary
        ) : null,
        child: isSelected ? Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.w),
          child: Row(
            children: [
              SvgPicture.asset(imagePath),
              SizedBox(width: 6,),
              Text(text, style: AppStyles.quicksandW500White(16.sp),)
            ],
          ),
        ) : Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Center(
            child: SvgPicture.asset(imagePath),),
        ),
      ),
    );
  }
}