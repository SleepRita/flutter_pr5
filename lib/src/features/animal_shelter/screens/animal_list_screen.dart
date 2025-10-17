import 'package:flutter/material.dart';
import '../models/animal.dart';
import '../widgets/animal_tile.dart';

class AnimalListScreen extends StatelessWidget {
  final List<Animal> animals;
  final VoidCallback onAdd;
  final Function(Animal) onTap;
  final Function(Animal) onEdit;
  final Function(String) onDelete;

  const AnimalListScreen({
    super.key,
    required this.animals,
    required this.onAdd,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Подопечные приюта'),
      ),
      body: animals.isEmpty
          ? const Center(child: Text('В приюте пока нет животных.'))
          : ListView.builder(
        itemCount: animals.length,
        itemBuilder: (context, index) {
          final animal = animals[index];
          return AnimalTile(
            animal: animal,
            onTap: () => onTap(animal),
            onEdit: () => onEdit(animal),
            onDelete: () => onDelete(animal.id),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: onAdd,
        child: const Icon(Icons.add),
        tooltip: 'Добавить подопечного',
      ),
    );
  }
}