import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pr5/src/data/mock_repository.dart';
import 'package:flutter_pr5/src/service_locator.dart';
import 'package:flutter_pr5/src/shared/constants/app_constants.dart';
import 'package:flutter_pr5/src/features/animal_shelter/cubit/detail/animal_detail_cubit.dart';
import 'package:flutter_pr5/src/features/animal_shelter/models/animal.dart';
import 'package:go_router/go_router.dart';

class AnimalDetailView extends StatelessWidget {
  const AnimalDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AnimalDetailCubit, AnimalDetailState>(
      // Listener для обработки "одноразовых" событий, например, удаление
      listener: (context, state) {
      },
      // Builder для перерисовки UI
      builder: (context, state) {
        if (state is AnimalDetailLoaded) {
          final animal = state.animal;
          return Scaffold(
            appBar: AppBar(
              title: Text(animal.name),
              actions: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  tooltip: 'Редактировать',
                  onPressed: () async {
                    await context.push('/animals/edit/${animal.id}');
                    // После возврата Cubit идет запрос на перезагрузку данных
                    // ignore: use_build_context_synchronously
                    context.read<AnimalDetailCubit>().loadAnimalDetails();
                  },
                ),
              ],
            ),
            body: _buildContent(context, animal),
          );
        }
        if (state is AnimalDetailError) {
          return Scaffold(appBar: AppBar(), body: Center(child: Text(state.message)));
        }
        // Состояния Initial и Loading
        return Scaffold(appBar: AppBar(), body: const Center(child: CircularProgressIndicator()));
      },
    );
  }

  // Верстка контента
  Widget _buildContent(BuildContext context, Animal animal) {
    return ListView(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      children: [
        // Фотография подопечного
        Container(
          height: 250,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: CachedNetworkImage(
            imageUrl: animal.imageUrl,
            fit: BoxFit.contain,
            placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
            errorWidget: (context, url, error) => const Center(
              child: Icon(Icons.broken_image_outlined, color: Colors.grey, size: 50),
            ),
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
        _buildStatusDropdown(context, animal.status), // Интерактивный статус
      ],
    );
  }

  // Виджет для выпадающего списка статусов
  Widget _buildStatusDropdown(BuildContext context, AnimalStatus currentStatus) {
    return DropdownButtonFormField<AnimalStatus>(
      value: currentStatus,
      decoration: const InputDecoration(
        labelText: AppConstants.statusLabel,
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.monitor_heart_outlined),
      ),
      items: AnimalStatus.values.map((status) => DropdownMenuItem(value: status, child: Text(_animalStatusToString(status)))).toList(),
      onChanged: (newStatus) {
        if (newStatus != null) {
          // Вызов метод из Cubit для обновления статуса
          context.read<AnimalDetailCubit>().updateAnimalStatus(newStatus);
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