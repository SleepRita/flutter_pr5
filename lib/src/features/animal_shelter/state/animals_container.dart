import 'package:flutter/material.dart';

// Перечисление для управления навигацией
enum Screen { list, form }

class AnimalsContainer extends StatefulWidget {
  const AnimalsContainer({super.key});

  @override
  State<AnimalsContainer> createState() => _AnimalsContainerState();
}

class _AnimalsContainerState extends State<AnimalsContainer> {
  Screen _currentScreen = Screen.list;

  @override
  Widget build(BuildContext context) {
    switch (_currentScreen) {

    }
  }
}