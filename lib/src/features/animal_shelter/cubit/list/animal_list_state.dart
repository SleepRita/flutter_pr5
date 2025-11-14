part of 'animal_list_cubit.dart';

abstract class AnimalListState extends Equatable {
  const AnimalListState();

  @override
  List<Object?> get props => [];
}

class AnimalListInitial extends AnimalListState {}

class AnimalListLoading extends AnimalListState {}

class AnimalListLoaded extends AnimalListState {
  final List<Animal> allAnimals;
  final String searchQuery;
  final AnimalType? selectedType;
  final AnimalStatus? selectedStatus;
  final RangeValues? selectedAgeRange;

  const AnimalListLoaded({
    required this.allAnimals,
    this.searchQuery = '',
    this.selectedType,
    this.selectedStatus,
    this.selectedAgeRange,
  });

  // Геттер для получения отфильтрованного списка на лету
  List<Animal> get filteredAnimals {
    return allAnimals.where((animal) {
      final nameMatches = animal.name.toLowerCase().contains(searchQuery.toLowerCase());
      final typeMatches = selectedType == null || animal.type == selectedType;
      final statusMatches = selectedStatus == null || animal.status == selectedStatus;
      final ageMatches = selectedAgeRange == null ||
          (animal.age >= selectedAgeRange!.start && animal.age <= selectedAgeRange!.end);
      return nameMatches && typeMatches && statusMatches && ageMatches;
    }).toList();
  }

  // Метод copyWith для удобного обновления части состояния
  AnimalListLoaded copyWith({
    List<Animal>? allAnimals,
    String? searchQuery,
    AnimalType? selectedType,
    AnimalStatus? selectedStatus,
    RangeValues? selectedAgeRange,
    // Флаги для явного сброса в null
    bool clearType = false,
    bool clearStatus = false,
    bool clearAge = false,
  }) {
    return AnimalListLoaded(
        allAnimals: allAnimals ?? this.allAnimals,
        searchQuery: searchQuery ?? this.searchQuery,
        // Если флаг clearType=true, устанавливается selectedType (даже если он null).
        // Иначе, используется старое значение, если новое не предоставлено.
        selectedType: clearType ? selectedType : (selectedType ?? this.selectedType),
    selectedStatus: clearStatus ? selectedStatus : (selectedStatus ?? this.selectedStatus),
    selectedAgeRange: clearAge ? null : (selectedAgeRange ?? this.selectedAgeRange),
    );
  }

  @override
  List<Object?> get props => [allAnimals, searchQuery, selectedType, selectedStatus, selectedAgeRange];
}

class AnimalListError extends AnimalListState {
  final String message;
  const AnimalListError(this.message);

  @override
  List<Object> get props => [message];
}