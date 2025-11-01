import 'package:flutter/material.dart';
import 'package:flutter_pr5/src/shared/routing/app_router.dart';
import 'shared/constants/app_constants.dart';

class AnimalShelterApp extends StatelessWidget {
  const AnimalShelterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: AppConstants.appTitle,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppConstants.primaryColor),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppConstants.primaryColor,
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
      ),
      routerConfig: goRouter,
    );
  }
}