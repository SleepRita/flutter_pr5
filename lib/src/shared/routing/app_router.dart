import 'package:flutter/material.dart';
import 'package:flutter_pr5/src/data/mock_repository.dart';
import 'package:flutter_pr5/src/features/auth/screens/auth_screen.dart';
import 'package:flutter_pr5/src/features/main/screens/main_screen.dart';
import 'package:flutter_pr5/src/service_locator.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_pr5/src/features/animal_shelter/screens/animal_detail_screen.dart';
import 'package:flutter_pr5/src/features/animal_shelter/screens/animal_form_screen.dart';
import 'package:flutter_pr5/src/features/animal_shelter/screens/animal_list_screen.dart';
import 'package:flutter_pr5/src/features/shelter_info/screens/shelter_info_display_screen.dart';
import 'package:flutter_pr5/src/features/shelter_info/screens/shelter_info_form_screen.dart';

bool isAuth = false;

final goRouter = GoRouter(
  initialLocation: '/auth',
  redirect: (BuildContext context, GoRouterState state) {
    final bool loggingIn = state.matchedLocation == '/auth';

    // Если пользователь не авторизован и пытается зайти не на страницу входа,
    // он перенаправляется на /auth
    if (!isAuth && !loggingIn) {
      return '/auth';
    }
    // Если пользователь авторизован и находится на странице входа, он перенаправляется
    // на главный экран
    if (isAuth && loggingIn) {
      return '/main';
    }
    return null;
  },
  routes: [
    // Маршрут для экрана авторизации
    GoRoute(
      path: '/auth',
      builder: (context, state) => const AuthScreen(),
    ),
    // Маршрут для главного экрана
    GoRoute(
      path: '/main',
      builder: (context, state) => const MainScreen(),
    ),
    // Маршруты, которые открываются поверх всего (вертикальная навигация)
    GoRoute(
      path: '/animals',
      builder: (context, state) => const AnimalListScreen(),
    ),
    GoRoute(
      path: '/info',
      builder: (context, state) => const ShelterInfoDisplayScreen(),
    ),
    GoRoute(
      path: '/animals/add',
      builder: (context, state) => const AnimalFormScreen(),
    ),
    GoRoute(
      path: '/animals/details/:id',
      builder: (context, state) {
        final animalId = state.pathParameters['id']!;
        final animal = getIt<MockRepository>().getAnimalById(animalId);
        return AnimalDetailScreen(animal: animal!);
      },
    ),
    GoRoute(
      path: '/animals/edit/:id',
      builder: (context, state) {
        final animalId = state.pathParameters['id']!;
        final animal = getIt<MockRepository>().getAnimalById(animalId);
        return AnimalFormScreen(animal: animal);
      },
    ),
    GoRoute(
      path: '/info/edit',
      builder: (context, state) => const ShelterInfoFormScreen(),
    ),
  ],
);