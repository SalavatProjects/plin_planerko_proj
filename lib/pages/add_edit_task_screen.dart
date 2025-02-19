import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:plinplanerko/storages/models/subtask.dart';
import 'package:plinplanerko/ui_kit/app_colors.dart';
import 'package:plinplanerko/ui_kit/app_styles.dart';

import '../bloc/task_cubit.dart';
import '../bloc/tasks_cubit.dart';


class AddEditTaskScreen extends StatefulWidget {
  const AddEditTaskScreen({super.key});

  @override
  State<AddEditTaskScreen> createState() => _AddEditTaskScreenState();
}

class _AddEditTaskScreenState extends State<AddEditTaskScreen> {
  final TextEditingController _titleEditingController = TextEditingController();
  final TextEditingController _descriptionEditingController = TextEditingController();
  final TextEditingController _checkboxEditingController = TextEditingController();
  final TextEditingController _passwordEditingController = TextEditingController();
  final TextEditingController _reenterPasswordEditingController = TextEditingController();

  bool _passwordVisible = false;
  bool _reenterPaswwordVisible = false;
  bool _isPasswordsMatched = true;
  // List<Subtask> _subtasks = [];
  // final List<SubtaskState> _checkBoxList = [];

  DateTime _changeTime(DateTime dateTime, int hour, int minute) {
    return DateTime(
      dateTime.year,
      dateTime.month,
      dateTime.day,
      hour,
      minute,
    );
  }

  DateTime _changeDate(DateTime dateTime, int year, int month, int day) {
    return DateTime(
      year,
      month,
      day,
      dateTime.hour,
      dateTime.minute
    );
  }

  @override
  void initState() {
    super.initState();
    context.read<TaskCubit>().updateDateTime(context.read<TasksCubit>().state.currentDate!);
    /*for (var elem in context.read<TaskCubit>().state.subtasks) {
      _subtasks.add(Subtask()
        ..isChecked = elem.isChecked
        ..text = elem.text
      );
    }*/
  }

  @override
  void dispose() {
    _titleEditingController.dispose();
    _descriptionEditingController.dispose();
    _checkboxEditingController.dispose();
    _passwordEditingController.dispose();
    _reenterPasswordEditingController.dispose();
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
                BlocSelector<TaskCubit, TaskState, String>(
                  selector: (state) => state.about,
                  builder: (context, about) {
                    return about.isNotEmpty ?
                    Text('Edit task', style: AppStyles.quicksandW600DarkGray(28.sp),) :
                    Text('Add new task', style: AppStyles.quicksandW600DarkGray(28.sp),);
                  },
                ),
                BlocBuilder<TaskCubit, TaskState>(
                  builder: (context, state) {
                    return CupertinoButton(
                      onPressed:
                      state.about.isNotEmpty && state.dateTime != null && _isPasswordsMatched ?
                          () async {
                        if (state.id != null) {
                          await context.read<TasksCubit>().updateTask(state.id!, state);
                        } else {
                          await context.read<TasksCubit>().addTask(state);
                        }
                            if(!context.mounted) return;
                            Navigator.of(context).pop();
                          }
                          : null,
                        padding: EdgeInsets.zero,
                        child: Opacity(
                            opacity: state.about.isNotEmpty && state.dateTime != null ? 1 : 0.4,
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
                        )
                        )
                    );
                  }
                )
              ],
            ),
            SizedBox(height: 16.w,),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(vertical: 16.w, horizontal: 12.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24.r),
                      color: AppColors.white,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Title', style: AppStyles.quicksandW600lightGray(18.sp),),
                        SizedBox(height: 8.w,),
                        BlocSelector<TaskCubit, TaskState, String>(
                        selector: (state) => state.about,
                        builder: (context, about) {
                          _titleEditingController.text = about;
                          return Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.w),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(26.r),
                              border: Border.all(width: 1.w, color: AppColors.black.withValues(alpha: 0.1)),
                              color: AppColors.white
                          ),
                          child: TextFormField(
                            controller: _titleEditingController,
                            style: AppStyles.quicksandW500DarkGray(16.sp),
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.zero,
                                isDense: true,
                                hintText: 'Review Emails',
                                hintStyle: AppStyles.quicksandW500lightGray(16.sp)
                            ),
                            onChanged: (value) {
                              context.read<TaskCubit>().updateAbout(value);
                            },
                          ),
                        );
                        },
                      ),
                        SizedBox(height: 16.w,),
                        Text('Description', style: AppStyles.quicksandW600lightGray(18.sp),),
                        SizedBox(height: 8.w,),
                        BlocSelector<TaskCubit, TaskState, String>(
                        selector: (state) => state.description,
                        builder: (context, description) {
                          _descriptionEditingController.text = description;
                          return Container(
                          width: MediaQuery.of(context).size.width,
                          // height: 108.w,
                          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.w),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(26.r),
                              border: Border.all(width: 1.w, color: AppColors.black.withValues(alpha: 0.1)),
                              color: AppColors.white
                          ),
                          child: TextFormField(
                            controller: _descriptionEditingController,
                            style: AppStyles.quicksandW500DarkGray(16.sp),
                            maxLines: 4,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.zero,
                                isDense: true,
                                hintText: 'Check your inbox for important messages and respond to any urgent inquiries to stay updated on communications.',
                                hintStyle: AppStyles.quicksandW500lightGray(16.sp)
                            ),
                            onChanged: (value) {
                              context.read<TaskCubit>().updateDescription(value);
                            },
                          ),
                        );
                          },
                        ),
                        SizedBox(height: 16.w,),
                        Text('Date and Time', style: AppStyles.quicksandW600lightGray(18.sp),),
                        SizedBox(height: 8.w,),
                        BlocSelector<TasksCubit, TasksState, DateTime>(
                          selector: (state) => state.currentDate!,
                          builder: (context, currentDateTime) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CupertinoButton(
                                    onPressed: () async {
                                      DateTime? pickedDate = await showDatePicker(
                                          context: context,
                                          firstDate: DateTime(2015),
                                          lastDate: DateTime(2074));
                                      if (pickedDate != null) {
                                        if (!context.mounted) return;
                                        context.read<TaskCubit>().updateDateTime(_changeDate(
                                            currentDateTime, pickedDate.year, pickedDate.month, pickedDate.day));
                                        context.read<TasksCubit>().updateCurrentDate(_changeDate(
                                            currentDateTime, pickedDate.year, pickedDate.month, pickedDate.day));
                                      }
                                    },
                                    padding: EdgeInsets.zero,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.w),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(30.r),
                                          border: Border.all(width: 1.w, color: AppColors.black.withValues(alpha: 0.1))
                                      ),
                                      child: Row(
                                        children: [
                                          SvgPicture.asset('assets/icons/calender.svg', width: 16.w, fit: BoxFit.fitWidth,),
                                          SizedBox(width: 12.w,),
                                          Text(DateFormat('d MMMM y').format(currentDateTime), style: AppStyles.quicksandW500DarkGray(16.sp),)
                                        ],
                                      ),
                                    )
                                ),
                                CupertinoButton(
                                    onPressed: () async {
                                      TimeOfDay? pickedTime = await showTimePicker(
                                          context: context, initialTime: TimeOfDay.fromDateTime(currentDateTime));
                                      if (pickedTime != null) {
                                        if (!context.mounted) return;
                                        context.read<TaskCubit>().updateDateTime(_changeTime(
                                            currentDateTime, pickedTime.hour, pickedTime.minute));
                                        context.read<TasksCubit>().updateCurrentDate(_changeTime(
                                            currentDateTime, pickedTime.hour, pickedTime.minute));
                                      }
                                    },
                                    padding: EdgeInsets.zero,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.w),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(30.r),
                                          border: Border.all(width: 1.w, color: AppColors.black.withValues(alpha: 0.1))
                                      ),
                                      child: Row(
                                        children: [
                                          SvgPicture.asset('assets/icons/clock.svg', width: 16.w, fit: BoxFit.fitWidth,),
                                          SizedBox(width: 12.w,),
                                          Text('${DateFormat('HH:mm').format(currentDateTime)} PM', style: AppStyles.quicksandW500DarkGray(16.sp),)
                                        ],
                                      ),
                                    )
                                )
                              ],
                            );
                          },
                        ),
                        SizedBox(height: 16.w,),
                        Text('Priority', style: AppStyles.quicksandW600lightGray(18.sp),),
                        SizedBox(height: 8.w,),
                        BlocSelector<TaskCubit, TaskState, int>(
                          selector: (state) => state.priority,
                          builder: (context, priority) {
                            return Container(
                              padding: EdgeInsets.all(4.w),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30.r),
                                  border: Border.all(width: 1.w, color: AppColors.black.withValues(alpha: 0.07))
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  CupertinoButton(
                                    onPressed: () {
                                      context.read<TaskCubit>().updatePriority(1);
                                    },
                                    padding: EdgeInsets.zero,
                                    sizeStyle: CupertinoButtonSize.small,
                                    child: Container(
                                      width: 96.w,
                                      height: 32.w,
                                      decoration: priority == 1 ? BoxDecoration(
                                          borderRadius: BorderRadius.circular(30.r),
                                          color: AppColors.red.withValues(alpha: 0.15)
                                      ) : null,
                                      child: Center(
                                        child: Text('High', style: priority == 1 ?
                                        AppStyles.quicksandW600Red(16.sp) :
                                        AppStyles.quicksandW600lightGray(16.sp),),
                                      ),
                                    ),
                                  ),
                                  CupertinoButton(
                                    onPressed: () {
                                      context.read<TaskCubit>().updatePriority(2);
                                    },
                                    padding: EdgeInsets.zero,
                                    sizeStyle: CupertinoButtonSize.small,
                                    child: Container(
                                      width: 96.w,
                                      height: 32.w,
                                      decoration: priority == 2 ? BoxDecoration(
                                          borderRadius: BorderRadius.circular(30.r),
                                          color: AppColors.orange.withValues(alpha: 0.15)
                                      ) : null,
                                      child: Center(
                                        child: Text('Medium', style: priority == 2 ?
                                        AppStyles.quicksandW600Orange(16.sp) :
                                        AppStyles.quicksandW600lightGray(16.sp),),
                                      ),
                                    ),
                                  ),
                                  CupertinoButton(
                                    onPressed: () {
                                      context.read<TaskCubit>().updatePriority(3);
                                    },
                                    padding: EdgeInsets.zero,
                                    sizeStyle: CupertinoButtonSize.small,
                                    child: Container(
                                      width: 96.w,
                                      height: 32.w,
                                      decoration: priority == 3 ? BoxDecoration(
                                          borderRadius: BorderRadius.circular(30.r),
                                          color: AppColors.green.withValues(alpha: 0.15)
                                      ) : null,
                                      child: Center(
                                        child: Text('Low', style: priority == 3 ?
                                        AppStyles.quicksandW600Green(16.sp) :
                                        AppStyles.quicksandW600lightGray(16.sp),),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        )
                      ],
                    )
                  ),
                    SizedBox(height: 12.w,),
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
                                              });
                                            }),
                                      ),
                                      SizedBox(width: 8.w,),
                                      Text(subtasks[index].text!, style: AppStyles.quicksandW500lightGray(16.sp),)
                                    ],
                                  ),
                                );
                              }


                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                height: 32.w,
                                child: Row(
                                  children: [
                                    GestureDetector(
                                        onTap: () {
                                          if (_checkboxEditingController.text.isNotEmpty) {
                                            setState(() {
                                              context.read<TaskCubit>().addSubtask(
                                                  Subtask()
                                                      ..isChecked = false
                                                      ..text = _checkboxEditingController.text);
                                              _checkboxEditingController.clear();
                                            });
                                            FocusScope.of(context).unfocus();
                                          }
                                        },
                                        child: SvgPicture.asset('assets/icons/plus.svg'),
                                    ),
                                    SizedBox(width: 10.w,),
                                    Expanded(
                                      child: TextFormField(
                                        controller: _checkboxEditingController,
                                        style: AppStyles.quicksandW500DarkGray(16.sp),
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          contentPadding: EdgeInsets.zero,
                                          isDense: true,
                                          hintText: 'Add',
                                          hintStyle: AppStyles.quicksandW500lightGray(16.sp)
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          );
                          },
                        ),
                        ],
                      ),
                    ),
                    SizedBox(height: 12.w,),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.fromLTRB(12.w, 16.w, 12.w, 0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24.r),
                        color: AppColors.white
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Password', style: AppStyles.quicksandW600lightGray(18.sp),),
                          SizedBox(height: 8.w,),
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
                              obscureText: !_passwordVisible,
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
                                      _passwordVisible = !_passwordVisible;
                                    });
                                  },
                                  child: _passwordVisible ?
                                  SvgPicture.asset('assets/icons/eye close.svg', width: 22.w, fit: BoxFit.fitWidth,) :
                                  SvgPicture.asset('assets/icons/eye open.svg', width: 22.w, fit: BoxFit.fitWidth,) ,
                                )
                              ),
                              onChanged: (value) {
                                context.read<TaskCubit>().updatePassword(value);
                                setState(() {
                                  if (_reenterPasswordEditingController.text.isNotEmpty) {
                                    if (value != _reenterPasswordEditingController.text) {
                                      _isPasswordsMatched = false;
                                    } else {
                                      _isPasswordsMatched = true;
                                    }
                                  }
                                });
                              },
                            ),
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
                              controller: _reenterPasswordEditingController,
                              obscureText: !_reenterPaswwordVisible,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.zero,
                                  isDense: true,
                                  hintText: 'Re-enter the password...',
                                  hintStyle: AppStyles.quicksandW500lightGray(16.sp),
                                  suffixIconConstraints: BoxConstraints(
                                      maxWidth: 22.w,
                                      maxHeight: 17.w
                                  ),
                                  suffixIcon: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _reenterPaswwordVisible = !_reenterPaswwordVisible;
                                      });
                                    },
                                    child: _reenterPaswwordVisible ?
                                    SvgPicture.asset('assets/icons/eye close.svg', width: 22.w, fit: BoxFit.fitWidth,) :
                                    SvgPicture.asset('assets/icons/eye open.svg', width: 22.w, fit: BoxFit.fitWidth,),
                                  )
                              ),
                              onChanged: (value) {
                                setState(() {
                                  if (value != _passwordEditingController.text) {
                                    _isPasswordsMatched = false;
                                  } else {
                                    _isPasswordsMatched = true;
                                  }
                                });

                              },
                            ),
                          ),
                          _isPasswordsMatched ? SizedBox(height: 32.w,) :
                          SizedBox(
                            height: 32.w,
                            child: Center(
                                child: Text('passwords do not match', style: AppStyles.quicksandW500Red(14.sp),)),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
            

          ],
        ),
      )),
    );
  }
}
