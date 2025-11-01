import 'package:flutter/material.dart';
import 'package:flutter_pr5/src/features/animal_shelter/screens/animal_form_screen.dart';
import 'package:flutter_pr5/src/shared/constants/app_constants.dart';
import 'package:flutter_pr5/src/features/animal_shelter/models/animal.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_pr5/src/data/mock_repository.dart';

class AnimalDetailScreen extends StatefulWidget {
  final Animal animal;
  const AnimalDetailScreen({super.key, required this.animal});

  @override
  State<AnimalDetailScreen> createState() => _AnimalDetailScreenState();
}

class _AnimalDetailScreenState extends State<AnimalDetailScreen> {
  // Локальное состояние для отображения актуальных данных
  late Animal _currentAnimal;

  @override
  void initState() {
    super.initState();
    _currentAnimal = widget.animal;
  }

  // Метод для обновления статуса
  void _updateStatus(AnimalStatus? newStatus) {
    if (newStatus == null) return;
    setState(() {
      _currentAnimal = _currentAnimal.copyWith(status: newStatus);
    });
    MockRepository.instance.updateAnimal(_currentAnimal);
  }

  void _delete() {
    MockRepository.instance.deleteAnimal(_currentAnimal.id);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_currentAnimal.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Редактировать',
            onPressed: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => AnimalFormScreen(animal: _currentAnimal)),
              );
              setState(() {
                _currentAnimal = MockRepository.instance.getAnimalById(_currentAnimal.id)!;
              });
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        children: [
          // Фотография подопечного
          Container(
            height: 250,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12), // Для скругления углов у дочернего виджета
            ),
            child: CachedNetworkImage(
              imageUrl: _currentAnimal.imageUrl,
              fit: BoxFit.contain,
              placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => const Center(
                child: Icon(
                  Icons.broken_image_outlined,
                  color: Colors.grey,
                  size: 50,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Детальная информация
          _buildDetailRow(context, icon: Icons.badge_outlined, title: AppConstants.nameLabel, value: _currentAnimal.name),
          _buildDetailRow(context, icon: Icons.category_outlined, title: AppConstants.typeLabel, value: _animalTypeToString(_currentAnimal.type)),
          _buildDetailRow(context, icon: Icons.label_outline, title: AppConstants.breedLabel, value: _currentAnimal.breed),
          _buildDetailRow(context, icon: Icons.cake_outlined, title: AppConstants.ageLabel, value: '${_currentAnimal.age} ${_currentAnimal.age == 1 ? AppConstants.oneAgeMeasureLabel : AppConstants.ageMeasureLabel}'),
          _buildDetailRow(context, icon: Icons.description_outlined, title: AppConstants.descriptionLabel, value: _currentAnimal.description),
          const SizedBox(height: 16),
          _buildStatusDropdown(context), // Интерактивный статус

          const SizedBox(height: 32),

          // Кнопка удаления
          ElevatedButton.icon(
            onPressed: _delete,
            icon: const Icon(Icons.delete_forever),
            label: const Text(AppConstants.deleteButtonText),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[700],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  // Виджет для выпадающего списка статусов
  Widget _buildStatusDropdown(BuildContext context) {
    return DropdownButtonFormField<AnimalStatus>(
      value: _currentAnimal.status,
      decoration: const InputDecoration(
        labelText: AppConstants.statusLabel,
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.monitor_heart_outlined),
      ),
      items: AnimalStatus.values.map((status) => DropdownMenuItem(value: status, child: Text(_animalStatusToString(status)))).toList(),
      onChanged: _updateStatus,
    );
  }

  // Вспомогательный виджет для красивой строки с данными
  Widget _buildDetailRow(BuildContext context, {required IconData icon, required String title, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Theme.of(context).primaryColor, size: 20),
              const SizedBox(width: 12),
              Text(title, style: TextStyle(color: Colors.grey.shade700, fontSize: 14)),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 32, top: 4),
            child: Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
          ),
          const Divider(height: 16),
        ],
      ),
    );
  }

  // Функции для преобразования enum в читаемый текст
  String _animalTypeToString(AnimalType type) {
    return AppConstants.animalTypes[type.index];
  }

  String _animalStatusToString(AnimalStatus status) {
    return AppConstants.animalStatuses[status.index];
  }
}