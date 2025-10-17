import 'package:flutter/material.dart';
import '../models/animal.dart';

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
        subtitle: Text(
          '${animal.breed}, ${animal.age} ${animal.age == 1 ? "год" : "года/лет"}',
        ),
        onTap: onTap,
        // Кнопки действий справа
        trailing: Row(
          mainAxisSize: MainAxisSize.min, // Чтобы Row занимал минимум места
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: onEdit,
              tooltip: 'Редактировать',
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: onDelete,
              tooltip: 'Удалить',
            ),
          ],
        ),
      ),
    );
  }
}