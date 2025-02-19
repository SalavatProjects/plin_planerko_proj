import 'package:flutter/material.dart';
import 'package:plinplanerko/bloc/tasks_cubit.dart';
import 'package:plinplanerko/pages/onboarding_screen.dart';
import 'package:plinplanerko/storages/isar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:plinplanerko/ui_kit/app_colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppIsarDatabase.init();
  runApp(BlocProvider(
    create: (context) => TasksCubit(),
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    context.read<TasksCubit>().updateCurrentDate(DateTime.now());
    return ScreenUtilInit(
      child: MaterialApp(
        theme: ThemeData(
          scaffoldBackgroundColor: AppColors.background,
          useMaterial3: true,
        ),
        home: FutureBuilder(
          future: context.read<TasksCubit>().getTasks(),
          builder: (context, snapshot) {
            return OnboardingScreen();
          }
        ),
      ),
    );
  }
}

