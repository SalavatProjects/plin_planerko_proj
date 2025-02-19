import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:plinplanerko/bloc/task_cubit.dart';
import 'package:plinplanerko/utils/constants.dart';
import 'package:pull_down_button/pull_down_button.dart';

import '../bloc/tasks_cubit.dart';
import '../storages/models/subtask.dart';
import '../ui_kit/app_colors.dart';
import '../ui_kit/app_styles.dart';
import 'add_edit_task_screen.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  late Color _priorityColor;
  late String _priorityText;

  double? _progress;

  void _checkProgress() {
    _progress = context.read<TaskCubit>().state.subtasks.where((e) => e.isChecked == true).length /
    context.read<TaskCubit>().state.subtasks.length;
  }
  @override
  void initState() {
    super.initState();
    context.read<TasksCubit>().updateCurrentDate(context.read<TaskCubit>().state.dateTime!);
    if (context.read<TaskCubit>().state.subtasks.isNotEmpty){
      _checkProgress();
    }
    switch(context.read<TaskCubit>().state.priority) {
      case 1:
        _priorityColor = AppColors.red;
        _priorityText = 'High';
        break;
      case 2:
        _priorityColor = AppColors.orange;
        _priorityText = 'Medium';
        break;
      case 3:
        _priorityColor = AppColors.green;
        _priorityText = 'Low';
        break;
      default:
        _priorityColor = AppColors.white;
        _priorityText = '';
        break;
    }
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
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: () => Navigator.of(context).pop(),
                        child: Container(
                          width: 52.w,
                          height: 52.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(width: 1.w, color: AppColors.black
                                .withValues(alpha: 0.07)),
                            color: AppColors.white,
                          ),
                          child: Center(
                            child: SvgPicture.asset(
                              'assets/icons/left.svg', width: 22.w,
                              fit: BoxFit.fitWidth,),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 110.w,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CupertinoButton(
                              padding: EdgeInsets.zero,
                              onPressed: () async {
                                context.read<TaskCubit>().updateIsCompleted(true);
                                await context.read<TasksCubit>().updateTask(
                                    context.read<TaskCubit>().state.id!, context.read<TaskCubit>().state);
                                if (!context.mounted) return;
                                Navigator.of(context).pop();
                              },
                              child: Container(
                                width: 52.w,
                                height: 52.w,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(width: 1.w, color: AppColors.black
                                      .withValues(alpha: 0.07)),
                                  color: AppColors.white,
                                ),
                                child: Center(
                                  child: SvgPicture.asset(
                                    'assets/icons/mark.svg', width: 22.w,
                                    fit: BoxFit.fitWidth,),
                                ),
                              ),
                            ),
                                BlocBuilder<TaskCubit, TaskState>(
                                builder: (context, state) {
                                  return PullDownButton(
                                  routeTheme: PullDownMenuRouteTheme(
                                      width: MediaQuery.of(context).size.width * 0.35
                                  ),
                                  itemBuilder: (context) => [
                                    PullDownMenuItem(
                                      onTap: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (BuildContext context) => BlocProvider(
                                                  create: (context) => TaskCubit(task: state),
                                                  child: AddEditTaskScreen(),
                                                )));
                                      },
                                      title: 'Edit',
                                      iconWidget: SvgPicture.asset('assets/icons/pen.svg'),
                                      itemTheme: PullDownMenuItemTheme(
                                          textStyle: AppStyles.quicksandW500DarkGray(16.sp)
                                      ),
                                    ),
                                    PullDownMenuItem(
                                      onTap: () {
                                        context.read<TasksCubit>().deleteTask(state.id!);
                                        Navigator.of(context).pop();
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
                                          width: 52.w,
                                          height: 52.w,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(width: 1.w, color: AppColors.black
                                                .withValues(alpha: 0.07)),
                                            color: AppColors.white,
                                          ),
                                          child: Center(
                                            child: SvgPicture.asset('assets/icons/dots.svg', width: 24.w, fit: BoxFit.fitWidth,),
                                          ),
                                        ),
                                      ),
                                );
                              },
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 16.w,),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(context.read<TaskCubit>().state.about, style: AppStyles.quicksandW600DarkGray(28.sp),),
                          SizedBox(height: 16.w,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 100.w,
                                height: 30.w,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15.r),
                                    color: _priorityColor.withValues(alpha: 0.15)
                                ),
                                child: Center(child: Text(_priorityText, style: AppStyles.quicksandW500DarkGray(14.sp).copyWith(color: _priorityColor),)),
                              ),
                              Container(
                                width: 106.w,
                                height: 30.w,
                                padding: EdgeInsets.symmetric(horizontal: 16.w),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15.r),
                                    color: AppColors.white
                                ),
                                child: Center(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SvgPicture.asset('assets/icons/calender.svg', width: 12.w, fit: BoxFit.fitWidth,),
                                      SizedBox(width: 4.w,),
                                      Text(
                                        DateFormat('dd.MM.yy').format(context.read<TaskCubit>().state.dateTime!),
                                        style: AppStyles.quicksandW500DarkGray(14.sp),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                width: 90.w,
                                height: 30.w,
                                padding: EdgeInsets.symmetric(horizontal: 16.w),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15.r),
                                    color: AppColors.white
                                ),
                                child: Center(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SvgPicture.asset('assets/icons/clock.svg', width: 12.w, fit: BoxFit.fitWidth,),
                                      SizedBox(width: 4.w,),
                                      Text(
                                        DateFormat('HH:mm').format(context.read<TaskCubit>().state.dateTime!),
                                        style: AppStyles.quicksandW500DarkGray(14.sp),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16.w,),
                          if (context.read<TaskCubit>().state.description.isNotEmpty || _progress != null)
                          Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.w),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(24.r),
                                color: AppColors.white
                            ),
                            child: Column(
                              children: [
                                if (context.read<TaskCubit>().state.description.isNotEmpty)
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('About this Task', style: AppStyles.quicksandW600lightGray(18.sp),),
                                        SizedBox(height: 12.w,),
                                        Text(context.read<TaskCubit>().state.description, style: AppStyles.quicksandW500lightGray(16.sp),),
                                        SizedBox(height: 24.w,),
                                      ],
                                    ),
                                  ),
                                if (_progress != null)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Progress', style: AppStyles.quicksandW600lightGray(18.sp),),
                                    SizedBox(height: 12.w,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Stack(
                                          children: [
                                            Container(
                                              width: 250.w,
                                              height: 10.w,
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(5.r),
                                                  color: AppColors.background
                                              ),
                                            ),
                                            AnimatedContainer(
                                              duration: AppConstants.duration200,
                                              width: _progress! * 250.w,
                                              height: 10.w,
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(5.r),
                                                  color: AppColors.primary
                                              ),
                                            ),
                                          ],
                                        ),
                                        Text('${(_progress! * 100).round()} %',style: AppStyles.quicksandW500lightGray(16.sp),)
                                      ],
                                    )
                                  ],
                                ),

                              ],
                            ),
                          ),
                          SizedBox(height: 12.w,),
                          if (_progress != null)
                            Container(
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.symmetric(vertical: 16.w, horizontal: 12.w),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(24.r),
                                  border: Border.all(width: 1.w, color: AppColors.black.withValues(alpha: 0.07)),
                                  color: AppColors.white
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Checklist', style: AppStyles.quicksandW600lightGray(18.sp),),
                                  SizedBox(height: 12.w,),
                                  BlocSelector<TaskCubit, TaskState, List<Subtask>>(
                                    selector: (state) => state.subtasks,
                                    builder: (context, subtasks) {
                                      return Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          ...List.generate(subtasks.length, (int index) {
                                            return SizedBox(
                                              width: MediaQuery.of(context).size.width,
                                              height: 32.w,
                                              child: Row(
                                                children: [
                                                  SizedBox(
                                                    width: 20.w,
                                                    height: 20.w,
                                                    child: Checkbox(
                                                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                        value: subtasks[index].isChecked,
                                                        onChanged: (bool? value) {
                                                          setState(() {
                                                            subtasks[index].isChecked = value!;
                                                            _checkProgress();
                                                          });
                                                          context.read<TasksCubit>().updateTask(context.read<TaskCubit>().state.id!, context.read<TaskCubit>().state);
                                                        }),
                                                  ),
                                                  SizedBox(width: 8.w,),
                                                  Text(subtasks[index].text!, style: AppStyles.quicksandW500lightGray(16.sp),)
                                                ],
                                              ),
                                            );
                                          }
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  
                  
                ],
              ),
          )),
    );
  }
}
