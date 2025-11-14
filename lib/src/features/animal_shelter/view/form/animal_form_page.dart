import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pr5/src/data/mock_repository.dart';
import 'package:flutter_pr5/src/service_locator.dart';
import 'package:flutter_pr5/src/features/animal_shelter/cubit/form/animal_form_cubit.dart';
import 'package:flutter_pr5/src/features/animal_shelter/models/animal.dart';
import 'animal_form_view.dart';

class AnimalFormPage extends StatelessWidget {
  final Animal? animal; // null, создание нового подопечного

  const AnimalFormPage({super.key, this.animal});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AnimalFormCubit(getIt<MockRepository>(), animal),
      child: const AnimalFormView(),
    );
  }
}