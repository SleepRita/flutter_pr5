import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pr5/src/data/mock_repository.dart';
import 'package:flutter_pr5/src/service_locator.dart';
import 'package:flutter_pr5/src/features/shelter_info/cubit/display/shelter_info_display_cubit.dart';
import 'shelter_info_display_view.dart';

class ShelterInfoDisplayPage extends StatelessWidget {
  const ShelterInfoDisplayPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ShelterInfoDisplayCubit(getIt<MockRepository>())
        ..loadShelterInfo(), // Сразу запускается загрузка данных
      child: const ShelterInfoDisplayView(),
    );
  }
}