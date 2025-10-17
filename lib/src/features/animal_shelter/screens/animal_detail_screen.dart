import 'package:flutter/material.dart';
import '../../../shared/constants/app_constants.dart';
import '../models/animal.dart';

class AnimalDetailScreen extends StatelessWidget {
  final Animal animal;
  final Function(String id, AnimalStatus newStatus) onUpdateStatus;
  final VoidCallback onDelete;

  const AnimalDetailScreen({
    super.key,
    required this.animal,
    required this.onUpdateStatus,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
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
        _buildDetailRow(context, icon: Icons.cake_outlined, title: AppConstants.ageLabel, value: '${animal.age} ${animal.age == 1 ? AppConstants.oneAgeMeasureLabel : AppConstants.ageMeasureLabel}'),
        _buildDetailRow(context, icon: Icons.description_outlined, title: AppConstants.descriptionLabel, value: animal.description),
        const SizedBox(height: 16),
        _buildStatusDropdown(context), // Интерактивный статус

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
    );
  }

  // Виджет для выпадающего списка статусов
  Widget _buildStatusDropdown(BuildContext context) {
    return DropdownButtonFormField<AnimalStatus>(
      value: animal.status,
      decoration: const InputDecoration(
        labelText: AppConstants.statusLabel,
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.monitor_heart_outlined),
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