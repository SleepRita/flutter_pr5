import 'package:flutter/material.dart';
import 'package:flutter_pr5/src/shared/constants/app_constants.dart';
import 'package:flutter_pr5/src/features/animal_shelter/models/animal.dart';

class AnimalTile extends StatelessWidget {
  final Animal animal;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const AnimalTile({
    super.key,
    required this.animal,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  // Вспомогательная функция для получения иконки в зависимости от типа животного
  IconData _getAnimalIcon() {
    switch (animal.type) {
      case AnimalType.cat:
        return Icons.pets;
      case AnimalType.dog:
        return Icons.pets;
      case AnimalType.other:
        return Icons.star;
    }
  }

  // Вспомогательная функция для получения цвета статуса
  Color _getStatusColor(AnimalStatus status) {
    switch (status) {
      case AnimalStatus.lookingForHome:
        return Colors.green.shade700;
      case AnimalStatus.treatment:
        return Colors.orange.shade800;
      case AnimalStatus.adopted:
        return Colors.blue.shade700;
    }
  }

  // Вспомогательная функция для получения текста статуса
  String _getStatusText(AnimalStatus status) {
    switch (status) {
      case AnimalStatus.lookingForHome:
        return AppConstants.animalStatuses[0];
      case AnimalStatus.treatment:
        return AppConstants.animalStatuses[2];
      case AnimalStatus.adopted:
        return AppConstants.animalStatuses[1];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      elevation: 2.0,
      child: ListTile(
        // Иконка слева
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).primaryColorLight,
          child: Icon(
            _getAnimalIcon(),
            color: Theme.of(context).primaryColorDark,
          ),
        ),
        // Основная информация
        title: Text(
          animal.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text('${animal.breed}, ${animal.age} ${animal.age == 1 ? AppConstants.oneAgeMeasureLabel : AppConstants.ageMeasureLabel}'),
            const SizedBox(height: 6),
            // Виджет для статуса с иконкой и цветом
            Row(
              children: [
                Icon(
                  Icons.circle,
                  size: 10,
                  color: _getStatusColor(animal.status),
                ),
                const SizedBox(width: 6),
                Text(
                  _getStatusText(animal.status),
                  style: TextStyle(
                    color: _getStatusColor(animal.status),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
        onTap: onTap,
        // Кнопки действий справа
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: onEdit,
              tooltip: AppConstants.editButtonText,
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: onDelete,
              tooltip: AppConstants.deleteButtonText,
            ),
          ],
        ),
      ),
    );
  }
}