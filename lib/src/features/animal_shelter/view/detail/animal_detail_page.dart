import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pr5/src/data/mock_repository.dart';
import 'package:flutter_pr5/src/service_locator.dart';
import 'package:flutter_pr5/src/features/animal_shelter/cubit/detail/animal_detail_cubit.dart';
import 'animal_detail_view.dart';

class AnimalDetailPage extends StatelessWidget {
  final String animalId;

  const AnimalDetailPage({super.key, required this.animalId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AnimalDetailCubit(getIt<MockRepository>(), animalId)
        ..loadAnimalDetails(),
      child: const AnimalDetailView(),
    );
  }
}