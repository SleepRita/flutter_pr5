import 'package:flutter/material.dart';
import 'package:flutter_pr5/src/data/mock_repository.dart';
import 'package:flutter_pr5/src/features/auth/view/auth_page.dart';
import 'package:flutter_pr5/src/features/main/view/main_page.dart';
import 'package:flutter_pr5/src/features/shelter_info/models/shelter_info.dart';
import 'package:flutter_pr5/src/service_locator.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_pr5/src/features/animal_shelter/view/detail/animal_detail_page.dart';
import 'package:flutter_pr5/src/features/animal_shelter/view/form/animal_form_page.dart';
import 'package:flutter_pr5/src/features/animal_shelter/view/list/animal_list_page.dart';
import 'package:flutter_pr5/src/features/shelter_info/view/display/shelter_info_display_page.dart';
import 'package:flutter_pr5/src/features/shelter_info/view/form/shelter_info_form_page.dart';

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
      builder: (context, state) => const AuthPage(),
    ),
    // Маршрут для главного экрана
    GoRoute(
      path: '/main',
      builder: (context, state) => const MainPage(),
    ),
    // Маршруты, которые открываются поверх всего (вертикальная навигация)
    GoRoute(
      path: '/animals',
      builder: (context, state) => const AnimalListPage(),
    ),
    GoRoute(
      path: '/info',
      builder: (context, state) => const ShelterInfoDisplayPage(),
    ),
    GoRoute(
      path: '/animals/add',
      builder: (context, state) => const AnimalFormPage(),
    ),
    GoRoute(
      path: '/animals/details/:id',
      builder: (context, state) {
        final animalId = state.pathParameters['id']!;
        return AnimalDetailPage(animalId: animalId);
      },
    ),
    GoRoute(
      path: '/animals/edit/:id',
      builder: (context, state) {
        final animalId = state.pathParameters['id']!;
        final animal = getIt<MockRepository>().getAnimalById(animalId);
        return AnimalFormPage(animal: animal);
      },
    ),
    GoRoute(
      path: '/info/edit',
      builder: (context, state) {
        // Получаем объект ShelterInfo, переданный через extra
        final info = state.extra as ShelterInfo;
        return ShelterInfoFormPage(initialInfo: info);
      },
    ),
  ],
);