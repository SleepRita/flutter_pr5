import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pr5/src/features/animal_shelter/widgets/animal_tile.dart';
import 'package:flutter_pr5/src/shared/constants/app_constants.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_pr5/src/features/animal_shelter/cubit/list/animal_list_cubit.dart';
import 'package:flutter_pr5/src/features/animal_shelter/models/animal.dart';

class AnimalListView extends StatelessWidget {
  const AnimalListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.petListTitle),
      ),
      body: BlocBuilder<AnimalListCubit, AnimalListState>(
        builder: (context, state) {
          if (state is AnimalListLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is AnimalListLoaded) {
            return _buildContent(context, state);
          }
          if (state is AnimalListError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, AnimalListLoaded state) {
    final cubit = context.read<AnimalListCubit>();

    return Column(
      children: [
        // Панель фильтров
        _FilterPanel(state: state),
        const Divider(height: 1, indent: 16, endIndent: 16),
        // Список животных
        Expanded(
          child: state.filteredAnimals.isEmpty
              ? const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(AppConstants.notFoundLabel, textAlign: TextAlign.center),
            ),
          )
              : ListView.builder(
            padding: const EdgeInsets.only(top: 8, bottom: 80),
            itemCount: state.filteredAnimals.length,
            itemBuilder: (context, index) {
              final animal = state.filteredAnimals[index];
              return AnimalTile(
                animal: animal,
                onTap: () async {
                  await context.push('/animals/details/${animal.id}');
                  cubit.loadAnimals(); // Обновление на случай изменений статуса
                },
                onEdit: () async {
                  await context.push('/animals/edit/${animal.id}');
                  cubit.loadAnimals(); // Обновление после редактирования
                },
                onDelete: () => cubit.deleteAnimal(animal.id),
              );
            },
          ),
        ),
      ],
    );
  }
}

// Панель фильтров
class _FilterPanel extends StatefulWidget {
  final AnimalListLoaded state;
  const _FilterPanel({required this.state});

  @override
  State<_FilterPanel> createState() => _FilterPanelState();
}

class _FilterPanelState extends State<_FilterPanel> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.state.searchQuery);
  }

  @override
  void didUpdateWidget(covariant _FilterPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Синхронизация контроллера, если текст изменился извне (например, при сбросе)
    if (widget.state.searchQuery != _searchController.text) {
      _searchController.text = widget.state.searchQuery;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AnimalListCubit>();
    final state = widget.state;
    final ages = state.allAnimals.map((a) => a.age).toList()..sort();
    final minAge = ages.isEmpty ? 0.0 : ages.first.toDouble();
    final maxAge = ages.isEmpty ? 20.0 : (ages.last.toDouble() > minAge ? ages.last.toDouble() : minAge + 1);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Column(
        children: [
          // Поиск
          TextField(
            controller: _searchController,
            decoration: const InputDecoration(labelText: AppConstants.searchByNameLabel, prefixIcon: Icon(Icons.search), border: OutlineInputBorder()),
            onChanged: (query) => cubit.searchQueryChanged(query),
          ),
          const SizedBox(height: 12),
          // Дропдауны
          Row(
            children: [
              // Тип
              Expanded(
                child: DropdownButtonFormField<AnimalType?>(
                  value: state.selectedType,
                  decoration: const InputDecoration(labelText: AppConstants.typeLabel, border: OutlineInputBorder()),
                  items: [
                    const DropdownMenuItem(value: null, child: Text(AppConstants.allTypesLabel)),
                    ...AnimalType.values.map((type) => DropdownMenuItem(value: type, child: Text(AppConstants.animalTypes[type.index]))),
                  ],
                  onChanged: (value) => cubit.animalTypeChanged(value),
                ),
              ),
              const SizedBox(width: 12),
              // Статус
              Expanded(
                child: DropdownButtonFormField<AnimalStatus?>(
                  value: state.selectedStatus,
                  decoration: const InputDecoration(labelText: AppConstants.statusLabel, border: OutlineInputBorder()),
                  items: [
                    const DropdownMenuItem(value: null, child: Text(AppConstants.allStatusesLabel)),
                    ...AnimalStatus.values.map((status) => DropdownMenuItem(value: status, child: Text(AppConstants.animalStatuses[status.index]))),
                  ],
                  onChanged: (value) => cubit.animalStatusChanged(value),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Слайдер возраста
          RangeSlider(
            min: minAge,
            max: maxAge,
            divisions: (maxAge - minAge).toInt().clamp(1, 100),
            labels: RangeLabels(
              (state.selectedAgeRange ?? RangeValues(minAge, maxAge)).start.round().toString(),
              (state.selectedAgeRange ?? RangeValues(minAge, maxAge)).end.round().toString(),
            ),
            values: state.selectedAgeRange ?? RangeValues(minAge, maxAge),
            onChanged: (values) => cubit.ageRangeChanged(values),
          ),
          const SizedBox(height: 8),
          // Кнопки
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    cubit.clearAllFilters();
                    _searchController.clear();
                    FocusScope.of(context).unfocus(); // Скрыть клавиатуру
                  },
                  icon: const Icon(Icons.clear_all),
                  label: const Text(AppConstants.clearFiltersButtonText),
                  style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12)),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () async {
                    await context.push('/animals/add');
                    cubit.loadAnimals();
                  },
                  icon: const Icon(Icons.add),
                  label: const Text(AppConstants.addButtonText),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
