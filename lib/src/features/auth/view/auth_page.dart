import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pr5/src/features/auth/cubit/auth_cubit.dart';
import 'auth_view.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Создается и предоставляется AuthCubit.
    return BlocProvider(
      create: (context) => AuthCubit(),
      // Отображается AuthView, который будет использовать этот Cubit.
      child: const AuthView(),
    );
  }
}