import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:plinplanerko/bloc/tasks_cubit.dart';
import 'package:plinplanerko/pages/add_edit_task_screen.dart';
import 'package:plinplanerko/pages/task_screen.dart';
import 'package:plinplanerko/ui_kit/app_colors.dart';
import 'package:plinplanerko/ui_kit/app_styles.dart';
import 'package:pull_down_button/pull_down_button.dart';

import '../bloc/task_cubit.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late DateTime _firstDayOfWeek;
  final TextEditingController _passwordEditingController = TextEditingController();

  DateTime _getFirstDayOfWeek(DateTime date) {
    return date.subtract(Duration(days: date.weekday - 1));
  }

  bool _isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  bool _isSameHour(DateTime time1, DateTime time2) {
    return time1.hour == time2.hour;
  }

  @override
  void dispose() {
    _passwordEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Padding(
          padding: EdgeInsets.symmetric(vertical: 24.w, horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.55,
                  height: 68.w,
                  child: Text('Organize Your Daily Tasks', style: AppStyles.quicksandW600DarkGray(28.sp),
                  ),
                ),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (BuildContext context) =>
                        MultiBlocProvider(providers: [
                          BlocProvider(create: (context) => TaskCubit()),
                        ],
                        child: AddEditTaskScreen()))
                  ),
                  child: Container(
                    width: 52.w,
                    height: 52.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(width: 1.w, color: AppColors.black.withValues(alpha: 0.07)),
                      color: AppColors.white
                    ),
                    child: Center(
                      child: SvgPicture.asset('assets/icons/plus.svg', width: 22.w,),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: 24.w,),
            BlocSelector<TasksCubit, TasksState, DateTime>(
            selector: (state) => state.currentDate!,
            builder: (context, currentDate) {
              _firstDayOfWeek = _getFirstDayOfWeek(currentDate);
              return Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24.r),
                color: AppColors.white
              ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(DateFormat('MMMM yyyy').format(currentDate), style: AppStyles.quicksandW600DarkGray(20.sp),),
                        GestureDetector(
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                                context: context, firstDate: DateTime(2015),
                                lastDate: DateTime(2074));
                            if (pickedDate != null) {
                              if(!context.mounted) return;
                              context.read<TasksCubit>().updateCurrentDate(pickedDate);
                            }
                          },
                          child: SizedBox(
                            width: 24.w,
                            height: 24.w,
                            child: Center(
                                child: SvgPicture.asset('assets/icons/down.svg', width: 16.w,fit: BoxFit.fitWidth,)),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 12.w,),
                    Row(
                      children: List.generate(7, (int index) {
                        DateTime day = _firstDayOfWeek.add(Duration(days: index));
                        return CupertinoButton(
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              context.read<TasksCubit>().updateCurrentDate(day);
                            },
                            child: Container(
                              width: 42.w,
                              height: 78.w,
                              padding: EdgeInsets.symmetric(vertical: 12.w, horizontal: 6.w),
                              decoration: _isSameDate(day, currentDate) ? BoxDecoration(
                                  borderRadius: BorderRadius.circular(21.r),
                                  color: AppColors.primary
                              ) : null,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    DateFormat('E').format(day),
                                    style: _isSameDate(day, currentDate) ?
                                    AppStyles.quicksandW500White(14.sp) :
                                    AppStyles.quicksandW500lightGray(14.sp),),
                                  Text(DateFormat('d').format(day),
                                  style: _isSameDate(day, currentDate) ?
                                    AppStyles.quicksandW500White(20.sp) :
                                    AppStyles.quicksandW500DarkGray(20.sp),
                                  )
                                ],
                              ),
                            ),
                        );
                      }
                      ),
                    ),
                  ],
                ),
            );
              },
            ),
            SizedBox(height: 24.w,),
            Text('Today tasks', style: AppStyles.quicksandW600Black(20.sp),),
            SizedBox(height: 16.w,),
            BlocBuilder<TasksCubit, TasksState>(
              builder: (context, state) {
                List<TaskState> currentTasksByDay = state.tasks.where((e) => _isSameDate(e.dateTime!, state.currentDate!)).toList();
                List<int> uniqueHours = currentTasksByDay.map((e) => e.dateTime!.hour).toSet().toList();
                uniqueHours.sort();
                if (currentTasksByDay.isNotEmpty) {
                  return Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List.generate(uniqueHours.length, (int index) {
                          List<TaskState> currentTasksByHours = currentTasksByDay.where((e) => e.dateTime!.hour == uniqueHours[index]).toList();
                          currentTasksByHours.sort((a,b) => a.dateTime!.compareTo(b.dateTime!));
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(DateFormat('HH:mm').format(DateTime(
                                  state.currentDate!.year,
                                  state.currentDate!.month,
                                  state.currentDate!.day,
                                  uniqueHours[index], 0, 0)),
                                style: AppStyles.quicksandW500lightGray(18.sp),),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.7,
                                child: Column(
                                  children: List.generate(currentTasksByHours.length, (int index)
                                  {
                                    Color priorityColor;
                                    switch (currentTasksByHours[index].priority) {
                                      case 1:
                                        priorityColor = AppColors.red;
                                        break;
                                      case 2:
                                        priorityColor = AppColors.orange;
                                        break;
                                      case 3:
                                        priorityColor = AppColors.green;
                                        break;
                                      default:
                                        priorityColor = AppColors.white;
                                        break;
                                    }
                                    return Padding(
                                      padding: EdgeInsets.only(bottom: 8.w),
                                      child: GestureDetector(
                                        onTap: () {
                                          if(currentTasksByHours[index].password.isNotEmpty) {
                                            bool isPasswordVisible = false;
                                            bool isPasswordIncorrect = false;
                                            showDialog(
                                                context: context,
                                                builder: (BuildContext context) => StatefulBuilder(
                                                    builder: (context, setState)
                                                    {
                                                      return Dialog(
                                                        insetPadding: EdgeInsets.symmetric(horizontal: 16.w),
                                                        child: Container(
                                                          width: MediaQuery.of(context).size.width,
                                                          padding: EdgeInsets.all(16.w),
                                                          height: 212.w,
                                                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(16.r), color: AppColors.white),
                                                          child: Column(
                                                            children: [
                                                              Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  Text(
                                                                    'Enter password',
                                                                    style: AppStyles.quicksandW600lightGray(18.sp),
                                                                  ),
                                                                  CupertinoButton(
                                                                    onPressed: () => Navigator.of(context).pop(),
                                                                    padding: EdgeInsets.zero,
                                                                    child: Container(
                                                                      width: 32.w,
                                                                      height: 32.w,
                                                                      decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.background),
                                                                      child: Center(
                                                                        child: SvgPicture.asset(
                                                                          'assets/icons/close.svg',
                                                                          width: 14.w,
                                                                          fit: BoxFit.fitWidth,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                height: 16.w,
                                                              ),
                                                              Container(
                                                                width: MediaQuery.of(context).size.width,
                                                                height: 52.w,
                                                                padding: EdgeInsets.symmetric(vertical: 16.w, horizontal: 16.w),
                                                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(26.r), border: Border.all(width: 1.w, color: AppColors.black.withValues(alpha: 0.1))),
                                                                child: TextFormField(
                                                                  controller: _passwordEditingController,
                                                                  obscureText: !isPasswordVisible,
                                                                  onChanged: (value) {
                                                                    if (value == currentTasksByHours[index].password) {
                                                                      setState(() {
                                                                        isPasswordIncorrect = false;
                                                                      });
                                                                    }
                                                                  },
                                                                  decoration: InputDecoration(
                                                                      border: InputBorder.none,
                                                                      contentPadding: EdgeInsets.zero,
                                                                      isDense: true,
                                                                      hintText: 'Enter the password...',
                                                                      hintStyle: AppStyles.quicksandW500lightGray(16.sp),
                                                                      suffixIconConstraints: BoxConstraints(maxWidth: 22.w, maxHeight: 17.w),
                                                                      suffixIcon: GestureDetector(
                                                                        onTap: () {
                                                                          setState(() {
                                                                            isPasswordVisible = !isPasswordVisible;
                                                                          });
                                                                        },
                                                                        child: isPasswordVisible
                                                                            ? SvgPicture.asset(
                                                                          'assets/icons/eye close.svg',
                                                                          width: 22.w,
                                                                          fit: BoxFit.fitWidth,
                                                                        )
                                                                            : SvgPicture.asset(
                                                                          'assets/icons/eye open.svg',
                                                                          width: 22.w,
                                                                          fit: BoxFit.fitWidth,
                                                                        ),
                                                                      )),
                                                                ),
                                                              ),
                                                              isPasswordIncorrect
                                                                  ? SizedBox(
                                                                height: 22.w,
                                                                child: Text(
                                                                  'Wrong password',
                                                                  style: AppStyles.quicksandW500Red(14.sp),
                                                                ),
                                                              )
                                                                  : SizedBox(
                                                                height: 22.w,
                                                              ),
                                                              CupertinoButton(
                                                                  onPressed: () {
                                                                    if (_passwordEditingController.text == currentTasksByHours[index].password) {
                                                                      setState(() {
                                                                        isPasswordIncorrect = false;
                                                                      });
                                                                      Navigator.of(context).pop();
                                                                      _passwordEditingController.clear();
                                                                      context.read<TasksCubit>().updateCurrentDate(currentTasksByHours[index].dateTime!);
                                                                      Navigator.of(context).push(
                                                                          MaterialPageRoute(builder: (
                                                                              BuildContext context) =>
                                                                              BlocProvider(
                                                                                create: (context) =>
                                                                                    TaskCubit(
                                                                                        task: currentTasksByHours[index]),
                                                                                child: TaskScreen(),
                                                                              ))
                                                                      );
                                                                    } else {
                                                                      setState(() {
                                                                        isPasswordIncorrect = true;
                                                                      });
                                                                    }
                                                                  },
                                                                  padding: EdgeInsets.zero,
                                                                  child: Container(
                                                                    width: MediaQuery.of(context).size.width,
                                                                    height: 50.w,
                                                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(26.r), color: AppColors.primary),
                                                                    child: Center(
                                                                      child: Text(
                                                                        'Continue',
                                                                        style: AppStyles.quicksandW600White(18.sp),
                                                                      ),
                                                                    ),
                                                                  ))
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    })).then((val) {
                                              _passwordEditingController.clear();
                                            });
                                          } else {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(builder: (
                                                    BuildContext context) =>
                                                    BlocProvider(
                                                      create: (context) =>
                                                          TaskCubit(
                                                              task: currentTasksByHours[index]),
                                                      child: TaskScreen(),
                                                    ))
                                            );
                                          }
                                        },
                                        child: Opacity(
                                          opacity: currentTasksByHours[index].isCompleted ? 0.5 : 1,
                                          child: Container(
                                            padding: EdgeInsets.all(12.w),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                BorderRadius.circular(24.r),
                                                border: Border.all(
                                                    width: 1.w,
                                                    color: AppColors.black
                                                        .withValues(alpha: 0.07)),
                                                color: AppColors.white),
                                            child:
                                            IntrinsicHeight(
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                                children: [
                                                  Container(
                                                    width: 4.w,
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(2.r),
                                                        color: priorityColor
                                                    ),
                                                  ),
                                                  SizedBox(width: 12.w,),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Expanded(
                                                              child: Text(
                                                                currentTasksByHours[index].about,
                                                                style: AppStyles.quicksandW600DarkGray(18.sp),
                                                                overflow: TextOverflow.ellipsis,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 82.w,
                                                              height: 36.w,
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.end,
                                                                children: [
                                                                  if (currentTasksByHours[index].password.isNotEmpty)
                                                                    Padding(
                                                                      padding: EdgeInsets.only(right: 6.w),
                                                                      child: Container(
                                                                        width: 36.w,
                                                                        height: 36.w,
                                                                        decoration: BoxDecoration(
                                                                          shape: BoxShape.circle,
                                                                          color: AppColors.background,
                                                                        ),
                                                                        child: Center(
                                                                          child: SvgPicture.asset('assets/icons/lock.svg', width: 14.w, fit: BoxFit.fitWidth,),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  PullDownButton(
                                                                    routeTheme: PullDownMenuRouteTheme(
                                                                        width: MediaQuery.of(context).size.width * 0.35
                                                                    ),
                                                                    itemBuilder: (context) => [
                                                                      PullDownMenuItem(
                                                                        onTap: () {
                                                                          if (currentTasksByHours[index].password.isNotEmpty) {
                                                                            bool isPasswordVisible = false;
                                                                            bool isPasswordIncorrect = false;
                                                                            showDialog(
                                                                                context: context,
                                                                                builder: (BuildContext context) => StatefulBuilder(
                                                                                    builder: (context, setState)
                                                                                      {
                                                                                        return Dialog(
                                                                                              insetPadding: EdgeInsets.symmetric(horizontal: 16.w),
                                                                                              child: Container(
                                                                                                width: MediaQuery.of(context).size.width,
                                                                                                padding: EdgeInsets.all(16.w),
                                                                                                height: 212.w,
                                                                                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(16.r), color: AppColors.white),
                                                                                                child: Column(
                                                                                                  children: [
                                                                                                    Row(
                                                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                      children: [
                                                                                                        Text(
                                                                                                          'Enter password',
                                                                                                          style: AppStyles.quicksandW600lightGray(18.sp),
                                                                                                        ),
                                                                                                        CupertinoButton(
                                                                                                          onPressed: () => Navigator.of(context).pop(),
                                                                                                          padding: EdgeInsets.zero,
                                                                                                          child: Container(
                                                                                                            width: 32.w,
                                                                                                            height: 32.w,
                                                                                                            decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.background),
                                                                                                            child: Center(
                                                                                                              child: SvgPicture.asset(
                                                                                                                'assets/icons/close.svg',
                                                                                                                width: 14.w,
                                                                                                                fit: BoxFit.fitWidth,
                                                                                                              ),
                                                                                                            ),
                                                                                                          ),
                                                                                                        )
                                                                                                      ],
                                                                                                    ),
                                                                                                    SizedBox(
                                                                                                      height: 16.w,
                                                                                                    ),
                                                                                                    Container(
                                                                                                      width: MediaQuery.of(context).size.width,
                                                                                                      height: 52.w,
                                                                                                      padding: EdgeInsets.symmetric(vertical: 16.w, horizontal: 16.w),
                                                                                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(26.r), border: Border.all(width: 1.w, color: AppColors.black.withValues(alpha: 0.1))),
                                                                                                      child: TextFormField(
                                                                                                        controller: _passwordEditingController,
                                                                                                        obscureText: !isPasswordVisible,
                                                                                                        onChanged: (value) {
                                                                                                          if (value == currentTasksByHours[index].password) {
                                                                                                            setState(() {
                                                                                                              isPasswordIncorrect = false;
                                                                                                            });
                                                                                                          }
                                                                                                        },
                                                                                                        decoration: InputDecoration(
                                                                                                            border: InputBorder.none,
                                                                                                            contentPadding: EdgeInsets.zero,
                                                                                                            isDense: true,
                                                                                                            hintText: 'Enter the password...',
                                                                                                            hintStyle: AppStyles.quicksandW500lightGray(16.sp),
                                                                                                            suffixIconConstraints: BoxConstraints(maxWidth: 22.w, maxHeight: 17.w),
                                                                                                            suffixIcon: GestureDetector(
                                                                                                              onTap: () {
                                                                                                                setState(() {
                                                                                                                  isPasswordVisible = !isPasswordVisible;
                                                                                                                });
                                                                                                              },
                                                                                                              child: isPasswordVisible
                                                                                                                  ? SvgPicture.asset(
                                                                                                                      'assets/icons/eye close.svg',
                                                                                                                      width: 22.w,
                                                                                                                      fit: BoxFit.fitWidth,
                                                                                                                    )
                                                                                                                  : SvgPicture.asset(
                                                                                                                      'assets/icons/eye open.svg',
                                                                                                                      width: 22.w,
                                                                                                                      fit: BoxFit.fitWidth,
                                                                                                                    ),
                                                                                                            )),
                                                                                                      ),
                                                                                                    ),
                                                                                                    isPasswordIncorrect
                                                                                                        ? SizedBox(
                                                                                                            height: 22.w,
                                                                                                            child: Text(
                                                                                                              'Wrong password',
                                                                                                              style: AppStyles.quicksandW500Red(14.sp),
                                                                                                            ),
                                                                                                          )
                                                                                                        : SizedBox(
                                                                                                            height: 22.w,
                                                                                                          ),
                                                                                                    CupertinoButton(
                                                                                                        onPressed: () {
                                                                                                          if (_passwordEditingController.text == currentTasksByHours[index].password) {
                                                                                                            setState(() {
                                                                                                              isPasswordIncorrect = false;
                                                                                                            });
                                                                                                            Navigator.of(context).pop();
                                                                                                            _passwordEditingController.clear();
                                                                                                            context.read<TasksCubit>().updateCurrentDate(currentTasksByHours[index].dateTime!);

                                                                                                            Navigator.of(context).push(MaterialPageRoute(
                                                                                                                builder: (BuildContext context) => BlocProvider(
                                                                                                                  create: (context) => TaskCubit(task: currentTasksByHours[index]),
                                                                                                                  child: AddEditTaskScreen(),
                                                                                                                )));
                                                                                                          } else {
                                                                                                            setState(() {
                                                                                                              isPasswordIncorrect = true;
                                                                                                            });
                                                                                                          }
                                                                                                        },
                                                                                                        padding: EdgeInsets.zero,
                                                                                                        child: Container(
                                                                                                          width: MediaQuery.of(context).size.width,
                                                                                                          height: 50.w,
                                                                                                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(26.r), color: AppColors.primary),
                                                                                                          child: Center(
                                                                                                            child: Text(
                                                                                                              'Continue',
                                                                                                              style: AppStyles.quicksandW600White(18.sp),
                                                                                                            ),
                                                                                                          ),
                                                                                                        ))
                                                                                                  ],
                                                                                                ),
                                                                                              ),
                                                                                            );
                                                                                          })).then((val) {
                                                                                  _passwordEditingController.clear();
                                                                            });
                                                                          } else {
                                                                            context.read<TasksCubit>().updateCurrentDate(currentTasksByHours[index].dateTime!);
                                                                            Navigator.of(context).push(
                                                                                MaterialPageRoute(
                                                                                    builder: (BuildContext context) => BlocProvider(
                                                                                      create: (context) => TaskCubit(task: currentTasksByHours[index]),
                                                                                      child: AddEditTaskScreen(),
                                                                                    )));
                                                                          }
                                                                        },
                                                                        title: 'Edit',
                                                                        iconWidget: SvgPicture.asset('assets/icons/pen.svg'),
                                                                        itemTheme: PullDownMenuItemTheme(
                                                                            textStyle: AppStyles.quicksandW500DarkGray(16.sp)
                                                                        ),
                                                                      ),
                                                                      PullDownMenuItem(
                                                                        onTap: () {
                                                                          if (currentTasksByHours[index].password.isNotEmpty) {
                                                                            bool isPasswordVisible = false;
                                                                            bool isPasswordIncorrect = false;
                                                                            showDialog(
                                                                                context: context,
                                                                                builder: (BuildContext context) => StatefulBuilder(
                                                                                    builder: (context, setState) =>
                                                                                        Dialog(
                                                                                          insetPadding: EdgeInsets.symmetric(horizontal: 16.w),
                                                                                          child: Container(
                                                                                            width: MediaQuery.of(context).size.width,
                                                                                            padding: EdgeInsets.all(16.w),
                                                                                            height: 212.w,
                                                                                            decoration: BoxDecoration(
                                                                                                borderRadius: BorderRadius.circular(16.r),
                                                                                                color: AppColors.white
                                                                                            ),
                                                                                            child: Column(
                                                                                              children: [
                                                                                                Row(
                                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                  children: [
                                                                                                    Text('Enter password', style: AppStyles.quicksandW600lightGray(18.sp),),
                                                                                                    CupertinoButton(
                                                                                                      onPressed: () => Navigator.of(context).pop(),
                                                                                                      padding: EdgeInsets.zero,
                                                                                                      child: Container(
                                                                                                        width: 32.w,
                                                                                                        height: 32.w,
                                                                                                        decoration: BoxDecoration(
                                                                                                            shape: BoxShape.circle,
                                                                                                            color: AppColors.background
                                                                                                        ),
                                                                                                        child: Center(
                                                                                                          child: SvgPicture.asset('assets/icons/close.svg', width: 14.w, fit: BoxFit.fitWidth,),
                                                                                                        ),
                                                                                                      ),
                                                                                                    )
                                                                                                  ],
                                                                                                ),
                                                                                                SizedBox(height: 16.w,),
                                                                                                Container(
                                                                                                  width: MediaQuery.of(context).size.width,
                                                                                                  height: 52.w,
                                                                                                  padding: EdgeInsets.symmetric(vertical: 16.w, horizontal: 16.w),
                                                                                                  decoration: BoxDecoration(
                                                                                                      borderRadius: BorderRadius.circular(26.r),
                                                                                                      border: Border.all(width: 1.w, color: AppColors.black.withValues(alpha: 0.1))
                                                                                                  ),
                                                                                                  child: TextFormField(
                                                                                                    controller: _passwordEditingController,
                                                                                                    obscureText: !isPasswordVisible,
                                                                                                    onChanged: (value) {
                                                                                                      if (value == currentTasksByHours[index].password) {
                                                                                                        setState(() {
                                                                                                          isPasswordIncorrect = false;
                                                                                                        });
                                                                                                      }
                                                                                                    },
                                                                                                    decoration: InputDecoration(
                                                                                                        border: InputBorder.none,
                                                                                                        contentPadding: EdgeInsets.zero,
                                                                                                        isDense: true,
                                                                                                        hintText: 'Enter the password...',
                                                                                                        hintStyle: AppStyles.quicksandW500lightGray(16.sp),
                                                                                                        suffixIconConstraints: BoxConstraints(
                                                                                                            maxWidth: 22.w,
                                                                                                            maxHeight: 17.w
                                                                                                        ),
                                                                                                        suffixIcon: GestureDetector(
                                                                                                          onTap: () {
                                                                                                            setState(() {
                                                                                                              isPasswordVisible = !isPasswordVisible;
                                                                                                            });
                                                                                                          },
                                                                                                          child: isPasswordVisible ?
                                                                                                          SvgPicture.asset('assets/icons/eye close.svg', width: 22.w, fit: BoxFit.fitWidth,) :
                                                                                                          SvgPicture.asset('assets/icons/eye open.svg', width: 22.w, fit: BoxFit.fitWidth,) ,
                                                                                                        )
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                                isPasswordIncorrect ?
                                                                                                SizedBox(
                                                                                                  height: 22.w,
                                                                                                  child: Text('Wrong password', style: AppStyles.quicksandW500Red(14.sp),),
                                                                                                )
                                                                                                    :
                                                                                                SizedBox(height: 22.w,),
                                                                                                CupertinoButton(
                                                                                                    onPressed: () {
                                                                                                      if (_passwordEditingController.text == currentTasksByHours[index].password) {
                                                                                                        setState(() {
                                                                                                          isPasswordIncorrect = false;
                                                                                                        });
                                                                                                        context.read<TasksCubit>().deleteTask(currentTasksByHours[index].id!);
                                                                                                        _passwordEditingController.clear();
                                                                                                        Navigator.of(context).pop();
                                                                                                      } else {
                                                                                                        setState(() {
                                                                                                          isPasswordIncorrect = true;
                                                                                                        });
                                                                                                      }
                                                                                                    },
                                                                                                    padding: EdgeInsets.zero,
                                                                                                    child: Container(
                                                                                                      width: MediaQuery.of(context).size.width,
                                                                                                      height: 50.w,
                                                                                                      decoration: BoxDecoration(
                                                                                                          borderRadius: BorderRadius.circular(26.r),
                                                                                                          color: AppColors.primary
                                                                                                      ),
                                                                                                      child: Center(
                                                                                                        child: Text('Continue', style: AppStyles.quicksandW600White(18.sp),),
                                                                                                      ),
                                                                                                    )
                                                                                                )
                                                                                              ],
                                                                                            ),
                                                                                          ),
                                                                                        )
                                                                                )).then((val) {
                                                                              _passwordEditingController.clear();
                                                                            });;
                                                                          } else {
                                                                            context.read<TasksCubit>().deleteTask(currentTasksByHours[index].id!);
                                                                          }

                                                                        },
                                                                        title: 'Delete',
                                                                        iconWidget: SvgPicture.asset('assets/icons/trash.svg'),
                                                                        itemTheme: PullDownMenuItemTheme(
                                                                            textStyle: AppStyles.quicksandW500DarkGray(16.sp)
                                                                        ),
                                                                      ),
                                                                    ],
                                                                    buttonBuilder: (context, showMenu) =>
                                                                        CupertinoButton(
                                                                          onPressed: showMenu,
                                                                          padding: EdgeInsets.zero,
                                                                          child: Container(
                                                                            width: 36.w,
                                                                            height: 36.w,
                                                                            decoration: BoxDecoration(
                                                                              shape: BoxShape.circle,
                                                                              color: AppColors.background,
                                                                            ),
                                                                            child: Center(
                                                                              child: SvgPicture.asset('assets/icons/dots.svg', width: 14.w, fit: BoxFit.fitWidth,),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                  ),

                                                                ],
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                        SizedBox(height: 8.w,),
                                                        if (currentTasksByHours[index].description.isNotEmpty)
                                                          Text(
                                                            currentTasksByHours[index].description,
                                                            style: AppStyles.quicksandW500lightGray(16.sp),
                                                            maxLines: 2,
                                                            overflow: TextOverflow.ellipsis,
                                                          ),
                                                        SizedBox(height: 8.w,),
                                                        if (currentTasksByHours[index].subtasks.isNotEmpty)
                                                          Column(
                                                            children: List.generate(currentTasksByHours[index].subtasks.length,
                                                                    (subtaskIndex) =>
                                                                    SizedBox(
                                                                      width: MediaQuery.of(context).size.width,
                                                                      height: 32.w,
                                                                      child: Row(
                                                                        children: [
                                                                          SizedBox(
                                                                            width: 20.w,
                                                                            height: 20.w,
                                                                            child: Checkbox(
                                                                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                                                value: currentTasksByHours[index].subtasks[subtaskIndex].isChecked,
                                                                                onChanged: (bool? value) {
                                                                                  setState(() {
                                                                                    currentTasksByHours[index].subtasks[subtaskIndex].isChecked = value!;
                                                                                  });
                                                                                  context.read<TasksCubit>().updateTask(currentTasksByHours[index].id!, currentTasksByHours[index]);
                                                                                }),
                                                                          ),
                                                                          SizedBox(width: 8.w,),
                                                                          Text(currentTasksByHours[index].subtasks[subtaskIndex].text!, style: AppStyles.quicksandW500lightGray(16.sp),)
                                                                        ],
                                                                      ),
                                                                    )
                                                            ),
                                                          ),
                                                        Text(
                                                          '${DateFormat('HH:mm').format(currentTasksByHours[index].dateTime!)} AM',
                                                          style: AppStyles.quicksandW500lightGray(14.sp),
                                                        )
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  ),
                                ),
                              )
                            ],
                          );
                        }
                        ),
                      ),
                    ),
                  );
                } else {
                  return Center(
                    child: Text('No tasks for this day', style: AppStyles.quicksandW500lightGray(18.sp),),
                  );
                }
              },
            )
          ],
        ),
      )
      ),
    );
  }
}
