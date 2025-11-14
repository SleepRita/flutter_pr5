import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pr5/src/data/mock_repository.dart';
import 'package:flutter_pr5/src/features/animal_shelter/models/animal.dart';

part 'animal_detail_state.dart';

class AnimalDetailCubit extends Cubit<AnimalDetailState> {
  final MockRepository _repository;
  final String _animalId;

  AnimalDetailCubit(this._repository, this._animalId) : super(AnimalDetailInitial());

  Future<void> loadAnimalDetails() async {
    emit(AnimalDetailLoading());
    try {
      final animal = _repository.getAnimalById(_animalId);
      if (animal != null) {
        emit(AnimalDetailLoaded(animal));
      } else {
        emit(const AnimalDetailError('Животное не найдено'));
      }
    } catch (e) {
      emit(const AnimalDetailError('Ошибка загрузки данных'));
    }
  }

  Future<void> updateAnimalStatus(AnimalStatus newStatus) async {
    if (state is AnimalDetailLoaded) {
      final currentAnimal = (state as AnimalDetailLoaded).animal;
      final updatedAnimal = currentAnimal.copyWith(status: newStatus);
      _repository.updateAnimal(updatedAnimal);
      emit(AnimalDetailLoaded(updatedAnimal)); // Обновляем состояние немедленно
    }
  }
}