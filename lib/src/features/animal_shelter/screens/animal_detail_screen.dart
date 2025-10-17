import 'package:flutter/material.dart';
import '../models/animal.dart';

class AnimalDetailScreen extends StatelessWidget {
  final Animal animal;
  final VoidCallback onBackToList;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const AnimalDetailScreen({
    super.key,
    required this.animal,
    required this.onBackToList,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Кнопка "назад" будет вызывать наш колбэк для правильного управления состоянием
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
            tooltip: 'Редактировать',
          ),
        ],
      ),
      body: ListView( // ListView позволяет прокручивать, если контент не помещается
        padding: const EdgeInsets.all(16.0),
        children: [
          // --- ЗАГЛУШКА ДЛЯ ФОТОГРАФИИ ---
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

          // --- ДЕТАЛЬНАЯ ИНФОРМАЦИЯ ---
          _buildDetailRow(context, icon: Icons.badge_outlined, title: 'Кличка', value: animal.name),
          _buildDetailRow(context, icon: Icons.category_outlined, title: 'Вид', value: _animalTypeToString(animal.type)),
          _buildDetailRow(context, icon: Icons.label_outline, title: 'Порода', value: animal.breed),
          _buildDetailRow(context, icon: Icons.cake_outlined, title: 'Возраст', value: '${animal.age} года/лет'),
          _buildDetailRow(context, icon: Icons.description_outlined, title: 'Описание', value: animal.description),
          _buildDetailRow(context, icon: Icons.monitor_heart_outlined, title: 'Статус', value: _animalStatusToString(animal.status)),

          const SizedBox(height: 32),

          // --- КНОПКА УДАЛЕНИЯ ---
          ElevatedButton.icon(
            onPressed: onDelete,
            icon: const Icon(Icons.delete_forever),
            label: const Text('Удалить из базы'),
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
      case AnimalType.cat: return 'Кошка';
      case AnimalType.dog: return 'Собака';
      case AnimalType.other: return 'Другое';
    }
  }

  String _animalStatusToString(AnimalStatus status) {
    switch (status) {
      case AnimalStatus.lookingForHome: return 'Ищет дом';
      case AnimalStatus.adopted: return 'Нашел дом';
      case AnimalStatus.treatment: return 'На лечении';
    }
  }
}