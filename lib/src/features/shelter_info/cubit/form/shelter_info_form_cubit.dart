import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pr5/src/data/mock_repository.dart';
import 'package:flutter_pr5/src/features/shelter_info/models/shelter_info.dart';

part 'shelter_info_form_state.dart';

class ShelterInfoFormCubit extends Cubit<ShelterInfoFormState> {
  final MockRepository _repository;

  ShelterInfoFormCubit(this._repository) : super(ShelterInfoFormInitial());

  Future<void> saveShelterInfo(ShelterInfo info) async {
    emit(ShelterInfoFormSaving());
    try {
      // Имитируется задержка сети
      await Future.delayed(const Duration(milliseconds: 500));
      _repository.updateShelterInfo(info);
      emit(ShelterInfoFormSuccess());
    } catch (e) {
      emit(const ShelterInfoFormFailure('Не удалось сохранить изменения'));
    }
  }
}