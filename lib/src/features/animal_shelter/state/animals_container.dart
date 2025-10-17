import 'package:flutter/material.dart';
import '../models/animal.dart';
import '../screens/animal_list_screen.dart';
import '../screens/animal_form_screen.dart';

// Перечисление для управления навигацией
enum Screen { list, form }

class AnimalsContainer extends StatefulWidget {
  const AnimalsContainer({super.key});

  @override
  State<AnimalsContainer> createState() => _AnimalsContainerState();
}

class _AnimalsContainerState extends State<AnimalsContainer> {
  final List<Animal> _animals = [];
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
    setState(() {}); // Обновляем UI

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Подопечный "${removedAnimal.name}" удален'),
        action: SnackBarAction(
          label: 'Отменить',
          onPressed: () {
            setState(() {
              _animals.insert(index, removedAnimal);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Логика отображения нужного экрана
    switch (_currentScreen) {
      case Screen.list:
        return AnimalListScreen(
          animals: _animals,
          onAdd: () => _showForm(),
          onEdit: (animal) => _showForm(animal: animal),
          onDelete: _deleteAnimal,
        );
      case Screen.form:
        return AnimalFormScreen(
          animal: _selectedAnimal,
          onSave: (animal) {
            if (_selectedAnimal == null) {
              _addAnimal(animal);
            } else {
              _updateAnimal(animal);
            }
          },
          onCancel: _showList,
        );
    }
  }
}