import 'package:flutter/material.dart';
import 'package:flutter_pr5/src/shared/constants/app_constants.dart';
import 'package:flutter_pr5/src/features/animal_shelter/models/animal.dart';

class AnimalFormScreen extends StatefulWidget {
  final Animal? animal;
  final Function(Animal) onSave;

  const AnimalFormScreen({
    super.key,
    this.animal,
    required this.onSave,
  });

  @override
  State<AnimalFormScreen> createState() => _AnimalFormScreenState();
}

class _AnimalFormScreenState extends State<AnimalFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _breedController;
  late TextEditingController _ageController;
  late TextEditingController _descriptionController;
  late AnimalType _selectedType;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.animal?.name ?? '');
    _breedController = TextEditingController(text: widget.animal?.breed ?? '');
    _ageController = TextEditingController(text: widget.animal?.age.toString() ?? '');
    _descriptionController = TextEditingController(text: widget.animal?.description ?? '');
    _selectedType = widget.animal?.type ?? AnimalType.cat;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _breedController.dispose();
    _ageController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final newOrUpdatedAnimal = Animal(
          id: widget.animal?.id ?? '',
          name: _nameController.text.trim(),
          type: _selectedType,
          breed: _breedController.text.trim(),
          age: int.tryParse(_ageController.text.trim()) ?? 0,
          description: _descriptionController.text.trim(),
          status: widget.animal?.status ?? AnimalStatus.lookingForHome,
          dateAdded: widget.animal?.dateAdded
      );
      widget.onSave(newOrUpdatedAnimal);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        children: [
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
    );
  }
}