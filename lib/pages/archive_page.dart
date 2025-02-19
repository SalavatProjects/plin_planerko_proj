import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:plinplanerko/bloc/tasks_cubit.dart';
import 'package:plinplanerko/pages/task_screen.dart';
import 'package:pull_down_button/pull_down_button.dart';

import '../bloc/task_cubit.dart';
import '../ui_kit/app_colors.dart';
import '../ui_kit/app_styles.dart';
import 'add_edit_task_screen.dart';

class ArchivePage extends StatefulWidget {
  const ArchivePage({super.key});

  @override
  State<ArchivePage> createState() => _ArchivePageState();
}

class _ArchivePageState extends State<ArchivePage> {
  final TextEditingController _passwordEditingController = TextEditingController();

  bool _isAll = true;

  @override
  void dispose() {
    _passwordEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.w),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Task archive', style: AppStyles.quicksandW600DarkGray(28.sp),
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
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 40.w,
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22.r),
                    color: AppColors.white
                  ),
                  child: IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CupertinoButton(
                          onPressed: () {
                            setState(() {
                              _isAll = true;
                            });
                          },
                          padding: EdgeInsets.zero,
                          child: Container(
                            width: MediaQuery.of(context).size.width / 2 - 20.w,
                            decoration: _isAll ? BoxDecoration(
                              borderRadius: BorderRadius.circular(22.r),
                              color: AppColors.primary.withValues(alpha: 0.15)
                            ) : null,
                            child: Center(
                              child: Text(
                                'All',
                                style: AppStyles.quicksandW600DarkGray(16.sp).copyWith(color: _isAll ? AppColors.primary : AppColors.lightGray),),
                            ),
                          ),
                        ),
                        CupertinoButton(
                          onPressed: () {
                            setState(() {
                              _isAll = false;
                            });
                          },
                          padding: EdgeInsets.zero,
                          child: Container(
                            width: MediaQuery.of(context).size.width / 2 - 20.w,
                            decoration: !_isAll ? BoxDecoration(
                                borderRadius: BorderRadius.circular(22.r),
                                color: AppColors.primary.withValues(alpha: 0.15)
                            ) : null,
                            child: Center(
                              child: Text(
                                'Done',
                                style: AppStyles.quicksandW600DarkGray(16.sp).copyWith(color: !_isAll ? AppColors.primary : AppColors.lightGray),),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 12.w,),
                BlocSelector<TasksCubit, TasksState, List<TaskState>>(
                    selector: (state) => state.tasks,
                    builder: (context, tasks) {
                      if (tasks.isNotEmpty) {
                        List<TaskState> currentTasks = [];
                        if (_isAll) {
                          currentTasks = tasks..sort((a,b) => a.dateTime!.compareTo(b.dateTime!));
                        } else {
                          currentTasks = tasks.where((e) => e.isCompleted).toList()..sort((a, b) => a.dateTime!.compareTo(a.dateTime!));
                        }
                        return Expanded(
                          child: SingleChildScrollView(
                              child: Column(
                                children: List.generate(currentTasks.length, (int index) {
                                  Color priorityColor;
                                  switch (currentTasks[index].priority) {
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
                                        if(currentTasks[index].password.isNotEmpty) {
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
                                                                  if (value == currentTasks[index].password) {
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
                                                                  if (_passwordEditingController.text == currentTasks[index].password) {
                                                                    setState(() {
                                                                      isPasswordIncorrect = false;
                                                                    });
                                                                    Navigator.of(context).pop();
                                                                    _passwordEditingController.clear();
                                                                    context.read<TasksCubit>().updateCurrentDate(currentTasks[index].dateTime!);
                                                                    Navigator.of(context).push(
                                                                        MaterialPageRoute(builder: (
                                                                            BuildContext context) =>
                                                                            BlocProvider(
                                                                              create: (context) =>
                                                                                  TaskCubit(
                                                                                      task: currentTasks[index]),
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
                                                            task: currentTasks[index]),
                                                    child: TaskScreen(),
                                                  ))
                                          );
                                        }
                                      },
                                      child: Opacity(
                                        opacity: currentTasks[index].isCompleted ? 0.5 : 1,
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
                                                              currentTasks[index].about,
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
                                                                if (currentTasks[index].password.isNotEmpty)
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
                                                                        if (currentTasks[index].password.isNotEmpty) {
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
                                                                                                  if (value == currentTasks[index].password) {
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
                                                                                                  if (_passwordEditingController.text == currentTasks[index].password) {
                                                                                                    setState(() {
                                                                                                      isPasswordIncorrect = false;
                                                                                                    });
                                                                                                    Navigator.of(context).pop();
                                                                                                    _passwordEditingController.clear();
                                                                                                    context.read<TasksCubit>().updateCurrentDate(currentTasks[index].dateTime!);

                                                                                                    Navigator.of(context).push(MaterialPageRoute(
                                                                                                        builder: (BuildContext context) => BlocProvider(
                                                                                                          create: (context) => TaskCubit(task: currentTasks[index]),
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
                                                                          context.read<TasksCubit>().updateCurrentDate(currentTasks[index].dateTime!);
                                                                          Navigator.of(context).push(
                                                                              MaterialPageRoute(
                                                                                  builder: (BuildContext context) => BlocProvider(
                                                                                    create: (context) => TaskCubit(task:currentTasks[index]),
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
                                                                        if (currentTasks[index].password.isNotEmpty) {
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
                                                                                                    if (value == currentTasks[index].password) {
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
                                                                                                    if (_passwordEditingController.text == currentTasks[index].password) {
                                                                                                      setState(() {
                                                                                                        isPasswordIncorrect = false;
                                                                                                      });
                                                                                                      context.read<TasksCubit>().deleteTask(currentTasks[index].id!);
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
                                                                          context.read<TasksCubit>().deleteTask(currentTasks[index].id!);
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
                                                      if (currentTasks[index].description.isNotEmpty)
                                                        Text(
                                                          currentTasks[index].description,
                                                          style: AppStyles.quicksandW500lightGray(16.sp),
                                                          maxLines: 2,
                                                          overflow: TextOverflow.ellipsis,
                                                        ),
                                                      SizedBox(height: 8.w,),
                                                      if (currentTasks[index].subtasks.isNotEmpty)
                                                        Column(
                                                          children: List.generate(currentTasks[index].subtasks.length,
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
                                                                              value: currentTasks[index].subtasks[subtaskIndex].isChecked,
                                                                              onChanged: (bool? value) {
                                                                                setState(() {
                                                                                  currentTasks[index].subtasks[subtaskIndex].isChecked = value!;
                                                                                });
                                                                                context.read<TasksCubit>().updateTask(currentTasks[index].id!, currentTasks[index]);
                                                                              }),
                                                                        ),
                                                                        SizedBox(width: 8.w,),
                                                                        Text(currentTasks[index].subtasks[subtaskIndex].text!, style: AppStyles.quicksandW500lightGray(16.sp),)
                                                                      ],
                                                                    ),
                                                                  )
                                                          ),
                                                        ),
                                                      Text(
                                                        '${DateFormat('HH:mm').format(currentTasks[index].dateTime!)} AM',
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
                                }),
                              )
                          ),
                        );
                      } else {
                        return Center(
                            child: Text('No tasks created yet', style: AppStyles.quicksandW500lightGray(18.sp),
                      ));
                      }
                    },
                  )
              ],
            ),

          )),
    );
  }
}
