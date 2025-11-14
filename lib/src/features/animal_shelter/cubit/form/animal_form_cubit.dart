import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pr5/src/data/mock_repository.dart';
import 'package:flutter_pr5/src/features/animal_shelter/models/animal.dart';

part 'animal_form_state.dart';

class AnimalFormCubit extends Cubit<AnimalFormState> {
  final MockRepository _repository;
  final Animal? _initialAnimal;

  AnimalFormCubit(this._repository, this._initialAnimal) : super(AnimalFormInitial(_initialAnimal));

  Future<void> saveAnimal({
    required String name,
    required String breed,
    required int age,
    required String description,
    required String imageUrl,
    required AnimalType type,
  }) async {
    emit(AnimalFormSaving());
    try {
      if (_initialAnimal != null) { // Режим редактирования
        final updatedAnimal = _initialAnimal!.copyWith(
          name: name,
          breed: breed,
          age: age,
          description: description,
          imageUrl: imageUrl,
          type: type,
        );
        _repository.updateAnimal(updatedAnimal);
      } else { // Режим создания
        final newAnimal = Animal(
          id: '', // id генерируется в репозитории
          name: name,
          breed: breed,
          age: age,
          description: description,
          imageUrl: imageUrl,
          type: type,
        );
        _repository.addAnimal(newAnimal);
      }
      emit(AnimalFormSuccess());
    } catch (e) {
      emit(const AnimalFormFailure('Не удалось сохранить животное'));
    }
  }
}