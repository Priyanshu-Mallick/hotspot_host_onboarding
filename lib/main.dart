// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotspot_host_onboarding/screens/experience_selection_screen.dart';

import 'theme/app_colors.dart';
import 'theme/app_text_styles.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hotspot Host Onboarding',
      theme: ThemeData(
        primaryColor: AppColors.primaryAccent,
        accentColor: AppColors.secondaryAccent,
        backgroundColor: AppColors.base1,
        scaffoldBackgroundColor: AppColors.base1,
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.base1,
          elevation: 0,
        ),
        textTheme: TextTheme(
          headline1: AppTextStyles.heading1,
          headline2: AppTextStyles.heading2,
          bodyText1: AppTextStyles.bodyText,
        ),
      ),
      home: ExperienceSelectionScreen(),
    );
  }
}
