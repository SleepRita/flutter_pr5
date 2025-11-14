import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pr5/src/data/mock_repository.dart';
import 'package:flutter_pr5/src/service_locator.dart';
import 'package:flutter_pr5/src/features/animal_shelter/cubit/list/animal_list_cubit.dart';
import 'animal_list_view.dart';

class AnimalListPage extends StatelessWidget {
  const AnimalListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AnimalListCubit(getIt<MockRepository>())
        ..loadAnimals(),
      child: const AnimalListView(),
    );
  }
}