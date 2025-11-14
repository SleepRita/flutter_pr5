import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pr5/src/data/mock_repository.dart';
import 'package:flutter_pr5/src/features/shelter_info/models/shelter_info.dart';

part 'shelter_info_display_state.dart';

class ShelterInfoDisplayCubit extends Cubit<ShelterInfoDisplayState> {
  final MockRepository _repository;

  ShelterInfoDisplayCubit(this._repository) : super(ShelterInfoDisplayInitial());

  Future<void> loadShelterInfo() async {
    emit(ShelterInfoDisplayLoading());
    try {
      final info = _repository.getShelterInfo();
      emit(ShelterInfoDisplayLoaded(info));
    } catch (e) {
      emit(const ShelterInfoDisplayError('Не удалось загрузить информацию о приюте'));
    }
  }
}