import 'package:flutter/material.dart';
import 'package:flutter_pr5/src/shared/constants/app_constants.dart';
import 'package:flutter_pr5/src/features/animal_shelter/models/animal.dart';
import 'package:flutter_pr5/src/features/animal_shelter/widgets/animal_tile.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_pr5/src/data/mock_repository.dart';

class AnimalListScreen extends StatefulWidget {
  const AnimalListScreen({super.key});

  @override
  State<AnimalListScreen> createState() => _AnimalListScreenState();
}

class _AnimalListScreenState extends State<AnimalListScreen> {
  late List<Animal> _animals;

  final _searchController = TextEditingController();
  String _searchQuery = '';
  AnimalType? _selectedType;
  AnimalStatus? _selectedStatus;
  RangeValues? _selectedAgeRange;

  // Переменные для диапазона возраста
  double _minAge = 0;
  double _maxAge = 20;

  @override
  void initState() {
    super.initState();
    // При инициализации получаются данные из репозитория
    _animals = MockRepository.instance.getAnimals();

    // Определение диапазона возраста на основе переданных данных
    if (_animals.isNotEmpty) {
      final ages = _animals.map((a) => a.age).toList();
      ages.sort();
      _minAge = ages.first.toDouble();
      _maxAge = ages.last.toDouble();
      if (_minAge == _maxAge) _maxAge += 1;
    }

    // Слушатель для текстового поля поиска
    _searchController.addListener(() {
      setState(() { _searchQuery = _searchController.text; });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _clearFilters() {
    setState(() {
      _searchController.clear();
      _selectedType = null;
      _selectedStatus = null;
      _selectedAgeRange = null;
    });
  }

  // Метод вызывается для обновления списка после возврата с другого экрана
  void _refreshAnimalList() {
    setState(() {
      _animals = MockRepository.instance.getAnimals();
    });
  }

  // Вспомогательная функция для преобразования Enum в строку
  String _animalStatusToString(AnimalStatus status) {
    switch (status) {
      case AnimalStatus.lookingForHome: return AppConstants.animalStatuses[0];
      case AnimalStatus.adopted: return AppConstants.animalStatuses[1];
      case AnimalStatus.treatment: return AppConstants.animalStatuses[2];
    }
  }

  @override
  Widget build(BuildContext context) {
    // Логика фильтрации списка на лету
    final filteredAnimals = _animals.where((animal) {
      final nameMatches = animal.name.toLowerCase().contains(_searchQuery.toLowerCase());
      final typeMatches = _selectedType == null || animal.type == _selectedType;
      final statusMatches = _selectedStatus == null || animal.status == _selectedStatus;
      final ageMatches = _selectedAgeRange == null ||
          (animal.age >= _selectedAgeRange!.start && animal.age <= _selectedAgeRange!.end);

      return nameMatches && typeMatches && statusMatches && ageMatches;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.petListTitle),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    labelText: AppConstants.searchByNameLabel,
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<AnimalType?>(
                        value: _selectedType,
                        decoration: const InputDecoration(labelText: AppConstants.typeLabel, border: OutlineInputBorder()),
                        items: [
                          const DropdownMenuItem(value: null, child: Text(AppConstants.allTypesLabel)),
                          ...AnimalType.values.map((type) => DropdownMenuItem(value: type, child: Text(AppConstants.animalTypes[type.index]))),
                        ],
                        onChanged: (value) => setState(() => _selectedType = value),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButtonFormField<AnimalStatus?>(
                        value: _selectedStatus,
                        decoration: const InputDecoration(labelText: AppConstants.statusLabel, border: OutlineInputBorder()),
                        items: [
                          const DropdownMenuItem(value: null, child: Text(AppConstants.allStatusesLabel)),
                          ...AnimalStatus.values.map((status) => DropdownMenuItem(value: status, child: Text(_animalStatusToString(status)))),
                        ],
                        onChanged: (value) => setState(() => _selectedStatus = value),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppConstants.ageStartLabel+'${_selectedAgeRange?.start.round() ?? _minAge.round()}'
                          +AppConstants.ageToLabel+'${_selectedAgeRange?.end.round() ?? _maxAge.round()}'+AppConstants.petAgesLabel,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    RangeSlider(
                      min: _minAge,
                      max: _maxAge,
                      divisions: (_maxAge - _minAge).toInt().clamp(1, 100),
                      labels: RangeLabels(
                        (_selectedAgeRange ?? RangeValues(_minAge, _maxAge)).start.round().toString(),
                        (_selectedAgeRange ?? RangeValues(_minAge, _maxAge)).end.round().toString(),
                      ),
                      values: _selectedAgeRange ?? RangeValues(_minAge, _maxAge),
                      onChanged: (values) => setState(() => _selectedAgeRange = values),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _clearFilters,
                        icon: const Icon(Icons.clear_all),
                        label: const Text(AppConstants.clearFiltersButtonText),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          await context.push('/animals/add');
                          // После возврата обновление списка
                          _refreshAnimalList();
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
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),
          // Список занимает все оставшееся место
          Expanded(
            child: filteredAnimals.isEmpty
                ? const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  AppConstants.notFoundLabel,
                  textAlign: TextAlign.center,
                ),
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.only(top: 8, bottom: 80),
              itemCount: filteredAnimals.length,
              itemBuilder: (context, index) {
                final animal = filteredAnimals[index];
                return AnimalTile(
                  animal: animal,
                  onTap: () async {
                    await context.push('/animals/details/${animal.id}');
                    _refreshAnimalList();
                  },
                  onEdit: () async {
                    await context.push('/animals/edit/${animal.id}');
                    _refreshAnimalList();
                  },
                  onDelete: () {
                    MockRepository.instance.deleteAnimal(animal.id);
                    _refreshAnimalList();
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}