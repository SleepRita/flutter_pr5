import 'package:flutter/material.dart';
import 'package:flutter_pr5/src/shared/constants/app_constants.dart';
import 'package:flutter_pr5/src/features/animal_shelter/models/animal.dart';
import 'package:flutter_pr5/src/features/animal_shelter/screens/animal_list_screen.dart';
import 'package:flutter_pr5/src/features/animal_shelter/screens/animal_form_screen.dart';
import 'package:flutter_pr5/src/features/animal_shelter/screens/animal_detail_screen.dart';

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
        description: 'Ласковый и игривый кот.', imageUrl: 'https://img.ixbt.site/live/topics/preview/00/07/59/78/b992bbd4ef.jpg'),
    Animal(id: '2', name: 'Рекс', type: AnimalType.dog, breed: 'Овчарка', age: 5,
        description: 'Умный и верный пёс.', imageUrl: 'https://icdn.lenta.ru/images/2024/06/27/15/20240627155726315/pic_3250f5a394ff274cc05326487308ca25.jpg', status: AnimalStatus.treatment),
    Animal(id: '3', name: 'Мурка', type: AnimalType.cat, breed: 'Сиамская', age: 2,
        description: 'Грациозная и независимая.', imageUrl: 'https://pets-start.by/upload/resize_cache/iblock/118/550_500_1/oa6rtyhouqc25s89nmt7ca9ypuzhssax.jpg'),
    Animal(id: '4', name: 'Шарик', type: AnimalType.dog, breed: 'Карликовый пудель', age: 1,
        description: 'Энергичный щенок.', imageUrl: 'https://i.pinimg.com/736x/f0/c6/7c/f0c67c6d8ee566c1d463291449b7a768.jpg'),
    Animal(id: '5', name: 'Пушистик', type: AnimalType.other, breed: 'Кролик', age: 1,
        description: 'Милый декоративный кролик.', imageUrl: 'https://static.tildacdn.com/tild3230-3066-4431-b037-316134383966/tMFc8f5ce-B5hLIAv7Mc.jpg'),
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
      imageUrl: animal.imageUrl,
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
    setState(() {});

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
        // copyWith для безопасного изменения объекта
        _animals[index] = _animals[index].copyWith(status: newStatus);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  AppBar _buildAppBar() {
    switch (_currentScreen) {
      case Screen.list:
        return AppBar(
          title: const Text(AppConstants.petListTitle),
        );
      case Screen.detail:
        return AppBar(
          leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: _showList),
          title: Text(_selectedAnimal?.name ?? AppConstants.detailsLabel),
          actions: [
            IconButton(icon: const Icon(Icons.edit), onPressed: () => _showForm(animal: _selectedAnimal!)),
          ],
        );
      case Screen.form:
        return AppBar(
          leading: IconButton(icon: const Icon(Icons.close), onPressed: _showList),
          title: Text(_selectedAnimal == null ? AppConstants.newPetLabel : AppConstants.editButtonText),
        );
    }
  }

  Widget _buildBody() {
    switch (_currentScreen) {
      case Screen.list:
        return AnimalListScreen(
          animals: _animals,
          onAdd: () => _showForm(),
          onTap: _showDetail,
          onEdit: (animal) => _showForm(animal: animal),
          onDelete: _deleteAnimal,
        );
      case Screen.detail:
        return AnimalDetailScreen(
            animal: _selectedAnimal!,
            onUpdateStatus: _updateAnimalStatus,
            onDelete: () {
              _deleteAnimal(_selectedAnimal!.id);
              _showList();
            });
      case Screen.form:
        return AnimalFormScreen(
            animal: _selectedAnimal,
            onSave: (animal) {
              if (_selectedAnimal == null || animal.id.isEmpty) {
                _addAnimal(animal);
              } else {
                _updateAnimal(animal);
              }
            });
    }
  }
}