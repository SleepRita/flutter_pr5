import 'package:flutter/material.dart';
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
    // 3. Добавляем обработку нового экрана в switch
    switch (_currentScreen) {
      case Screen.list:
        return AnimalListScreen(
          animals: _animals,
          onAdd: () => _showForm(),
          // Теперь onTap будет открывать детали, а onEdit - форму
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
    // Новый кейс для детального экрана
      case Screen.detail:
        return AnimalDetailScreen(
          animal: _selectedAnimal!, // Уверены, что он не null в этом состоянии
          onBackToList: _showList,
          onEdit: () => _showForm(animal: _selectedAnimal!),
          onDelete: () {
            _deleteAnimal(_selectedAnimal!.id);
            _showList(); // После удаления возвращаемся к списку
          },
        );
    }
  }
}