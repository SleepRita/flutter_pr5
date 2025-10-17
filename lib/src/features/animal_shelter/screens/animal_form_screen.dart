import 'package:flutter/material.dart';
import '../models/animal.dart';
import '../../../shared/constants/app_constants.dart';

class AnimalFormScreen extends StatefulWidget {
  final Animal? animal;
  final Function(Animal) onSave;
  final VoidCallback onCancel;

  const AnimalFormScreen({
    super.key,
    this.animal,
    required this.onSave,
    required this.onCancel,
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
  AnimalType _selectedType = AnimalType.cat;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.animal?.name);
    _breedController = TextEditingController(text: widget.animal?.breed);
    _ageController = TextEditingController(text: widget.animal?.age.toString());
    _descriptionController = TextEditingController(text: widget.animal?.description);
    _selectedType = widget.animal?.type ?? AnimalType.cat;
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final animalData = Animal(
          id: widget.animal?.id ?? '',
          name: _nameController.text,
          type: _selectedType,
          breed: _breedController.text,
          age: int.tryParse(_ageController.text) ?? 0,
          description: _descriptionController.text,
          status: widget.animal?.status ?? AnimalStatus.lookingForHome,
          dateAdded: widget.animal?.dateAdded
      );
      widget.onSave(animalData);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.animal == null ? AppConstants.newPetLabel : AppConstants.editButtonText),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: widget.onCancel,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: AppConstants.nameLabel),
                validator: (value) => value!.isEmpty ? AppConstants.enterNameLabel : null,
              ),
              TextFormField(
                controller: _breedController,
                decoration: const InputDecoration(labelText: AppConstants.breedLabel),
                validator: (value) => value!.isEmpty ? AppConstants.enterBreedLabel : null,
              ),
              TextFormField(
                controller: _ageController,
                decoration: const InputDecoration(labelText: AppConstants.descriptionAgeLabel),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) return AppConstants.enterAgeLabel;
                  if (int.tryParse(value) == null) return AppConstants.enterIntLabel;
                  return null;
                },
              ),
              DropdownButtonFormField<AnimalType>(
                value: _selectedType,
                items: AnimalType.values.map((type) => DropdownMenuItem(
                  value: type,
                  child: Text(type.toString().split('.').last),
                )).toList(),
                onChanged: (value) => setState(() => _selectedType = value!),
                decoration: const InputDecoration(labelText: AppConstants.typeLabel),
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: AppConstants.descriptionLabel),
                maxLines: 4,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                child: const Text(AppConstants.saveButtonText),
              ),
            ],
          ),
        ),
      ),
    );
  }
}