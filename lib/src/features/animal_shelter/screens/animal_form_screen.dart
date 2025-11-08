import 'package:flutter/material.dart';
import 'package:flutter_pr5/src/data/mock_repository.dart';
import 'package:flutter_pr5/src/service_locator.dart';
import 'package:flutter_pr5/src/shared/constants/app_constants.dart';
import 'package:flutter_pr5/src/features/animal_shelter/models/animal.dart';
import 'package:go_router/go_router.dart';

class AnimalFormScreen extends StatefulWidget {
  // Конструктор принимает необязательный объект animal
  final Animal? animal;
  const AnimalFormScreen({super.key, this.animal});

  @override
  State<AnimalFormScreen> createState() => _AnimalFormScreenState();
}

class _AnimalFormScreenState extends State<AnimalFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _breedController;
  late TextEditingController _ageController;
  late TextEditingController _descriptionController;
  late TextEditingController _imageUrlController;
  late AnimalType _selectedType;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.animal?.name ?? '');
    _breedController = TextEditingController(text: widget.animal?.breed ?? '');
    _ageController = TextEditingController(text: widget.animal?.age.toString() ?? '');
    _descriptionController = TextEditingController(text: widget.animal?.description ?? '');
    _imageUrlController = TextEditingController(text: widget.animal?.imageUrl ?? '');
    _selectedType = widget.animal?.type ?? AnimalType.cat;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _breedController.dispose();
    _ageController.dispose();
    _descriptionController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      // Режим редактирования
      if (widget.animal != null) {
        final updatedAnimal = widget.animal!.copyWith(
          name: _nameController.text.trim(),
          breed: _breedController.text.trim(),
          age: int.tryParse(_ageController.text.trim()) ?? 0,
          description: _descriptionController.text.trim(),
          imageUrl: _imageUrlController.text.trim(),
          type: _selectedType,
        );
        getIt<MockRepository>().updateAnimal(updatedAnimal);
      } else { // Режим создания
        final newAnimal = Animal(
          id: '',
          name: _nameController.text.trim(),
          breed: _breedController.text.trim(),
          age: int.tryParse(_ageController.text.trim()) ?? 0,
          description: _descriptionController.text.trim(),
          imageUrl: _imageUrlController.text.trim(),
          type: _selectedType,
        );
        getIt<MockRepository>().addAnimal(newAnimal);
      }
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.animal == null ? 'Новый подопечный' : 'Редактировать'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          children: [
            TextFormField(
              controller: _imageUrlController,
              decoration: const InputDecoration(labelText: 'URL изображения', border: OutlineInputBorder()),
              keyboardType: TextInputType.url,
              validator: (value) {
                if (value == null || value.isEmpty) return 'Введите URL изображения';
                // Проверка на то, что это ссылка
                if (!value.startsWith('http')) return 'Введите корректный URL';
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: AppConstants.nameLabel, border: OutlineInputBorder()),
              validator: (value) => (value == null || value.isEmpty) ? AppConstants.enterNameLabel : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _breedController,
              decoration: const InputDecoration(labelText: AppConstants.breedLabel, border: OutlineInputBorder()),
              validator: (value) => (value == null || value.isEmpty) ? AppConstants.enterBreedLabel : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _ageController,
              decoration: const InputDecoration(labelText: AppConstants.ageLabel, border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) return AppConstants.enterAgeLabel;
                if (int.tryParse(value) == null) return AppConstants.enterIntLabel;
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<AnimalType>(
              value: _selectedType,
              decoration: const InputDecoration(labelText: AppConstants.typeLabel, border: OutlineInputBorder()),
              items: AnimalType.values.map((type) => DropdownMenuItem(
                value: type,
                child: Text(AppConstants.animalTypes[type.index]),
              )).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedType = value);
                }
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: AppConstants.descriptionLabel, border: OutlineInputBorder()),
              maxLines: 4,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(AppConstants.saveButtonText),
            ),
          ],
        ),
      ),
    );
  }
}
