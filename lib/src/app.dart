import 'package:flutter/material.dart';
import 'features/animal_shelter/state/animals_container.dart';

class AnimalShelterApp extends StatelessWidget {
  const AnimalShelterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Приют "Пушистый дом"',
      theme: ThemeData(
        primarySwatch: Colors.brown,
        useMaterial3: true,
      ),
      home: const AnimalsContainer(),
    );
  }
}
