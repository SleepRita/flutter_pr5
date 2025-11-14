import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pr5/src/data/mock_repository.dart';
import 'package:flutter_pr5/src/features/animal_shelter/models/animal.dart';

part 'animal_list_state.dart';

class AnimalListCubit extends Cubit<AnimalListState> {
  final MockRepository _repository;

  AnimalListCubit(this._repository) : super(AnimalListInitial());

  Future<void> loadAnimals() async {
    emit(AnimalListLoading());
    try {
      final animals = _repository.getAnimals();
      emit(AnimalListLoaded(allAnimals: animals));
    } catch (e) {
      emit(const AnimalListError('Не удалось загрузить список животных'));
    }
  }

  Future<void> deleteAnimal(String id) async {
    if (state is AnimalListLoaded) {
      final currentState = state as AnimalListLoaded;
      _repository.deleteAnimal(id);
      final updatedAnimals = _repository.getAnimals();
      // Обновление списка с сохранением текущих фильтров
      emit(currentState.copyWith(allAnimals: updatedAnimals));
    }
  }

  void searchQueryChanged(String query) {
    if (state is AnimalListLoaded) {
      final currentState = state as AnimalListLoaded;
      emit(currentState.copyWith(searchQuery: query));
    }
  }

  void animalTypeChanged(AnimalType? type) {
    if (state is AnimalListLoaded) {
      final currentState = state as AnimalListLoaded;
      // Мы явно передаем флаг, чтобы copyWith мог сбросить значение в null
      emit(currentState.copyWith(selectedType: type, clearType: true));
    }
  }

  void animalStatusChanged(AnimalStatus? status) {
    if (state is AnimalListLoaded) {
      final currentState = state as AnimalListLoaded;
      emit(currentState.copyWith(selectedStatus: status, clearStatus: true));
    }
  }

  void ageRangeChanged(RangeValues range) {
    if (state is AnimalListLoaded) {
      final currentState = state as AnimalListLoaded;
      emit(currentState.copyWith(selectedAgeRange: range));
    }
  }

  void clearAllFilters() {
    if (state is AnimalListLoaded) {
      final currentState = state as AnimalListLoaded;
      emit(currentState.copyWith(
        searchQuery: '',
        clearType: true,
        clearStatus: true,
        clearAge: true,
      ));
    }
  }
}