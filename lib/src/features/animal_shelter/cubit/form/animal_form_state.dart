part of 'animal_form_cubit.dart';

abstract class AnimalFormState extends Equatable {
  const AnimalFormState();

  @override
  List<Object?> get props => [];
}

// Начальное состояние, хранит животное для редактирования (если есть)
class AnimalFormInitial extends AnimalFormState {
  final Animal? initialAnimal;
  const AnimalFormInitial(this.initialAnimal);

  @override
  List<Object?> get props => [initialAnimal];
}

class AnimalFormSaving extends AnimalFormState {}

class AnimalFormSuccess extends AnimalFormState {}

class AnimalFormFailure extends AnimalFormState {
  final String error;
  const AnimalFormFailure(this.error);

  @override
  List<Object> get props => [error];
}