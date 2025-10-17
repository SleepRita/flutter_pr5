import 'package:flutter/material.dart';
import 'shared/constants/app_constants.dart';
import 'features/main_screen.dart';

class AnimalShelterApp extends StatelessWidget {
  const AnimalShelterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appTitle,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppConstants.primaryColor),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppConstants.primaryColor,
          foregroundColor: Colors.white,
          elevation: 2, // Небольшая тень
          centerTitle: true, // Центрирование заголовка
        ),
      ),
      home: const MainScreen(),
    );
  }
}
