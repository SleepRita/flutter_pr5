part of 'animal_detail_cubit.dart';

abstract class AnimalDetailState extends Equatable {
  const AnimalDetailState();

  @override
  List<Object> get props => [];
}

class AnimalDetailInitial extends AnimalDetailState {}

class AnimalDetailLoading extends AnimalDetailState {}

class AnimalDetailLoaded extends AnimalDetailState {
  final Animal animal;

  const AnimalDetailLoaded(this.animal);

  @override
  List<Object> get props => [animal];
}

class AnimalDetailError extends AnimalDetailState {
  final String message;

  const AnimalDetailError(this.message);

  @override
  List<Object> get props => [message];
}