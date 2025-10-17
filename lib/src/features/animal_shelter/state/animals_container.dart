import 'package:flutter/material.dart';
import 'package:flutter_pr5/src/shared/constants/app_constants.dart';
import '../models/animal.dart';
import '../screens/animal_list_screen.dart';
import '../screens/animal_form_screen.dart';
import '../screens/animal_detail_screen.dart';

// Перечисление для управления навигацией
enum Screen { list, form, detail }

class AnimalsContainer extends StatefulWidget {
  const AnimalsContainer({super.key});

  @override
  State<AnimalsContainer> createState() => _AnimalsContainerState();
}

class _AnimalsContainerState extends State<AnimalsContainer> {
  final List<Animal> _animals = [
    Animal(id: '1', name: 'Барсик', type: AnimalType.cat, breed: 'Дворняга', age: 3,
        description: 'Ласковый и игривый кот, любит спать на коленях.'),
    Animal(id: '2', name: 'Рекс', type: AnimalType.dog, breed: 'Овчарка', age: 5,
        description: 'Умный и верный пёс, отличный охранник.', status: AnimalStatus.treatment),
    Animal(id: '3', name: 'Мурка', type: AnimalType.cat, breed: 'Сиамская', age: 2,
        description: 'Грациозная и независимая кошка.'),
    Animal(id: '4', name: 'Шарик', type: AnimalType.dog, breed: 'Пудель', age: 1,
        description: 'Энергичный щенок, требует много внимания и игр.'),
    Animal(id: '5', name: 'Пушистик', type: AnimalType.other, breed: 'Кролик', age: 1,
        description: 'Милый декоративный кролик, приучен к лотку.'),
  ];
  Screen _currentScreen = Screen.list;
  Animal? _selectedAnimal;

  // Методы для навигации
  void _showList() {
    setState(() {
      _currentScreen = Screen.list;
      _selectedAnimal = null;
    });
  }

  void _showForm({Animal? animal}) {
    setState(() {
      _selectedAnimal = animal;
      _currentScreen = Screen.form;
    });
  }

  void _showDetail(Animal animal) {
    setState(() {
      _selectedAnimal = animal;
      _currentScreen = Screen.detail;
    });
  }

  // Бизнес-логика
  void _addAnimal(Animal animal) {
    final newAnimal = Animal(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: animal.name,
      type: animal.type,
      breed: animal.breed,
      age: animal.age,
      description: animal.description,
    );
    setState(() {
      _animals.add(newAnimal);
    });
    _showList();
  }

  void _updateAnimal(Animal updatedAnimal) {
    setState(() {
      final index = _animals.indexWhere((a) => a.id == updatedAnimal.id);
      if (index != -1) {
        _animals[index] = updatedAnimal;
      }
    });
    _showList();
  }

  void _deleteAnimal(String id) {
    final index = _animals.indexWhere((a) => a.id == id);
    if (index == -1) return;

    final removedAnimal = _animals.removeAt(index);
    setState(() {}); // Обновление UI

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppConstants.petLabel+"${removedAnimal.name}"+AppConstants.deletedLabel),
        action: SnackBarAction(
          label: AppConstants.cancelButtonText,
          onPressed: () {
            setState(() {
              _animals.insert(index, removedAnimal);
            });
          },
        ),
      ),
    );
  }

  void _updateAnimalStatus(String id, AnimalStatus newStatus) {
    setState(() {
      final index = _animals.indexWhere((animal) => animal.id == id);
      if (index != -1) {
        // Используем copyWith для безопасного изменения объекта
        _animals[index] = _animals[index].copyWith(status: newStatus);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (_currentScreen) {
      case Screen.list:
        return AnimalListScreen(
          animals: _animals,
          onAdd: () => _showForm(),
          onTap: _showDetail,
          onEdit: (animal) => _showForm(animal: animal),
          onDelete: _deleteAnimal,
        );
      case Screen.form:
        return AnimalFormScreen(
          animal: _selectedAnimal,
          onSave: (animal) {
            if (_selectedAnimal == null || animal.id.isEmpty) {
              _addAnimal(animal);
            } else {
              _updateAnimal(animal);
            }
          },
          onCancel: _showList,
        );
      case Screen.detail:
        return AnimalDetailScreen(
          animal: _selectedAnimal!,
          onBackToList: _showList,
          onEdit: () => _showForm(animal: _selectedAnimal!),
          onDelete: () {
            _deleteAnimal(_selectedAnimal!.id);
            _showList(); // После удаления возвращаемся к списку
          },
          onUpdateStatus: _updateAnimalStatus,
        );
    }
  }
}