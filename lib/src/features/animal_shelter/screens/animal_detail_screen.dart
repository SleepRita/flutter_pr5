import 'package:flutter/material.dart';
import 'package:flutter_pr5/src/shared/constants/app_constants.dart';
import '../models/animal.dart';

class AnimalDetailScreen extends StatelessWidget {
  final Animal animal;
  final VoidCallback onBackToList;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final Function(String id, AnimalStatus newStatus) onUpdateStatus;

  const AnimalDetailScreen({
    super.key,
    required this.animal,
    required this.onBackToList,
    required this.onEdit,
    required this.onDelete,
    required this.onUpdateStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: onBackToList,
        ),
        title: Text(animal.name),
        actions: [
          // Кнопка "редактировать" в AppBar
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: onEdit,
            tooltip: AppConstants.editButtonText,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Заглушка для фотографии
          Container(
            height: 250,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade400),
            ),
            child: Icon(
              Icons.pets,
              size: 100,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),

          // Детальная информация
          _buildDetailRow(context, icon: Icons.badge_outlined, title: AppConstants.nameLabel, value: animal.name),
          _buildDetailRow(context, icon: Icons.category_outlined, title: AppConstants.typeLabel, value: _animalTypeToString(animal.type)),
          _buildDetailRow(context, icon: Icons.label_outline, title: AppConstants.breedLabel, value: animal.breed),
          _buildDetailRow(context, icon: Icons.cake_outlined, title: AppConstants.ageLabel, value: '${animal.age} '+AppConstants.ageMeasureLabel),
          _buildDetailRow(context, icon: Icons.description_outlined, title: AppConstants.descriptionLabel, value: animal.description),
          _buildStatusDropdown(context),

          const SizedBox(height: 32),

          // Кнопка удаления
          ElevatedButton.icon(
            onPressed: onDelete,
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(Icons.monitor_heart_outlined, color: Theme.of(context).primaryColor),
          const SizedBox(width: 16),
          Expanded(
            child: DropdownButtonFormField<AnimalStatus>(
              value: animal.status,
              decoration: const InputDecoration(
                labelText: AppConstants.statusLabel,
                border: OutlineInputBorder(),
              ),
              items: AnimalStatus.values.map((status) {
                return DropdownMenuItem(
                  value: status,
                  child: Text(_animalStatusToString(status)),
                );
              }).toList(),
              onChanged: (newStatus) {
                if (newStatus != null) {
                  onUpdateStatus(animal.id, newStatus);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  // Вспомогательный виджет для красивого отображения строки с данными
  Widget _buildDetailRow(BuildContext context, {required IconData icon, required String title, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Theme.of(context).primaryColor, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
                const SizedBox(height: 2),
                Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Функции для преобразования enum в читаемый текст
  String _animalTypeToString(AnimalType type) {
    switch (type) {
      case AnimalType.cat: return AppConstants.animalTypes[0];
      case AnimalType.dog: return AppConstants.animalTypes[1];
      case AnimalType.other: return AppConstants.animalTypes[2];
    }
  }

  String _animalStatusToString(AnimalStatus status) {
    switch (status) {
      case AnimalStatus.lookingForHome: return AppConstants.animalStatuses[0];
      case AnimalStatus.adopted: return AppConstants.animalStatuses[1];
      case AnimalStatus.treatment: return AppConstants.animalStatuses[2];
    }
  }
}