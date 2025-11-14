part of 'shelter_info_display_cubit.dart';

abstract class ShelterInfoDisplayState extends Equatable {
  const ShelterInfoDisplayState();

  @override
  List<Object> get props => [];
}

class ShelterInfoDisplayInitial extends ShelterInfoDisplayState {}

class ShelterInfoDisplayLoading extends ShelterInfoDisplayState {}

class ShelterInfoDisplayLoaded extends ShelterInfoDisplayState {
  final ShelterInfo shelterInfo;

  const ShelterInfoDisplayLoaded(this.shelterInfo);

  @override
  List<Object> get props => [shelterInfo];
}

class ShelterInfoDisplayError extends ShelterInfoDisplayState {
  final String message;

  const ShelterInfoDisplayError(this.message);

  @override
  List<Object> get props => [message];
}