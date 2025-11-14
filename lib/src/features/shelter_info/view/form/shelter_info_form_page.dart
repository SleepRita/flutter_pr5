import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pr5/src/data/mock_repository.dart';
import 'package:flutter_pr5/src/service_locator.dart';
import 'package:flutter_pr5/src/features/shelter_info/cubit/form/shelter_info_form_cubit.dart';
import 'package:flutter_pr5/src/features/shelter_info/models/shelter_info.dart';
import 'shelter_info_form_view.dart';

class ShelterInfoFormPage extends StatelessWidget {
  final ShelterInfo initialInfo;

  const ShelterInfoFormPage({super.key, required this.initialInfo});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ShelterInfoFormCubit(getIt<MockRepository>()),
      child: ShelterInfoFormView(initialInfo: initialInfo),
    );
  }
}