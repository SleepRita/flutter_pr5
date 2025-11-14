import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pr5/src/shared/constants/app_constants.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_pr5/src/features/animal_shelter/cubit/form/animal_form_cubit.dart';
import 'package:flutter_pr5/src/features/animal_shelter/models/animal.dart';

class AnimalFormView extends StatefulWidget {
  const AnimalFormView({super.key});

  @override
  State<AnimalFormView> createState() => _AnimalFormViewState();
}

class _AnimalFormViewState extends State<AnimalFormView> {
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
    // Получение начальных данных из состояния Cubit'а. Cubit создается раньше и имеет начальное состояние.
    final initialAnimal = (context.read<AnimalFormCubit>().state as AnimalFormInitial).initialAnimal;

    // Инициализаця контроллеров. Если это создание нового животного (initialAnimal == null),
    // поля будут пустыми. Если редактирование, поля заполнятся данными.
    _nameController = TextEditingController(text: initialAnimal?.name ?? '');
    _breedController = TextEditingController(text: initialAnimal?.breed ?? '');
    _ageController = TextEditingController(text: initialAnimal?.age.toString() ?? '');
    _descriptionController = TextEditingController(text: initialAnimal?.description ?? '');
    _imageUrlController = TextEditingController(text: initialAnimal?.imageUrl ?? '');
    _selectedType = initialAnimal?.type ?? AnimalType.cat; // По умолчанию 'Кошка' для нового
  }

  @override
  void dispose() {
    // Очищение контроллеров
    _nameController.dispose();
    _breedController.dispose();
    _ageController.dispose();
    _descriptionController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  // Метод, вызываемый при нажатии на кнопку "Сохранить"
  void _submit() {
    // Проверка, прошла ли форма валидацию
    if (_formKey.currentState!.validate()) {
      // Вызов метода Cubit'а для сохранения с передачей данных из контроллеров
      context.read<AnimalFormCubit>().saveAnimal(
        name: _nameController.text.trim(),
        breed: _breedController.text.trim(),
        age: int.tryParse(_ageController.text.trim()) ?? 0,
        description: _descriptionController.text.trim(),
        imageUrl: _imageUrlController.text.trim(),
        type: _selectedType,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final animal = (context.read<AnimalFormCubit>().state as AnimalFormInitial).initialAnimal;

    return Scaffold(
      appBar: AppBar(
        title: Text(animal == null ? 'Новый подопечный' : 'Редактировать'),
      ),
      // BlocListener слушает изменения состояния для выполнения действий
      // (навигация, показ Snackbar), не перерисовывая при этом весь виджет.
      body: BlocListener<AnimalFormCubit, AnimalFormState>(
        listener: (context, state) {
          if (state is AnimalFormSuccess) {
            context.pop(); // Возвращаемся назад при успешном сохранении
          }
          if (state is AnimalFormFailure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(state.error)));
          }
        },
        child: Form(
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
              // BlocBuilder перерисовывает только кнопку, когда это необходимо
              BlocBuilder<AnimalFormCubit, AnimalFormState>(
                builder: (context, state) {
                  // Если идет сохранение, показывается индикатор загрузки
                  if (state is AnimalFormSaving) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  // В любом другом состоянии показывается кнопка
                  return ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(AppConstants.saveButtonText),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}