part of 'shelter_info_form_cubit.dart';

abstract class ShelterInfoFormState extends Equatable {
  const ShelterInfoFormState();

  @override
  List<Object> get props => [];
}

class ShelterInfoFormInitial extends ShelterInfoFormState {}

class ShelterInfoFormSaving extends ShelterInfoFormState {}

class ShelterInfoFormSuccess extends ShelterInfoFormState {}

class ShelterInfoFormFailure extends ShelterInfoFormState {
  final String error;

  const ShelterInfoFormFailure(this.error);

  @override
  List<Object> get props => [error];
}