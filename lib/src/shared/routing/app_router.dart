import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_pr5/src/data/mock_repository.dart';
import 'package:flutter_pr5/src/features/main_screen.dart';
import 'package:flutter_pr5/src/features/animal_shelter/screens/animal_detail_screen.dart';
import 'package:flutter_pr5/src/features/animal_shelter/screens/animal_form_screen.dart';
import 'package:flutter_pr5/src/features/animal_shelter/screens/animal_list_screen.dart';
import 'package:flutter_pr5/src/features/shelter_info/screens/shelter_info_display_screen.dart';
import 'package:flutter_pr5/src/features/shelter_info/screens/shelter_info_form_screen.dart';

// Ключи для навигаторов
final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final goRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/animals',
  routes: [
    // ShellRoute - оболочка с BottomNavigationBar
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return MainScreen(child: child);
      },
      routes: [
        GoRoute(
          path: '/animals',
          pageBuilder: (context, state) => const NoTransitionPage(child: AnimalListScreen()),
          routes: [
            // Вложенные маршруты. Они будут открываться поверх BottomNavigationBar
            GoRoute(
              parentNavigatorKey: _rootNavigatorKey,
              path: 'add',
              builder: (context, state) => const AnimalFormScreen(),
            ),
            GoRoute(
              parentNavigatorKey: _rootNavigatorKey,
              path: 'details/:id',
              builder: (context, state) {
                final animalId = state.pathParameters['id']!;
                final animal = MockRepository.instance.getAnimalById(animalId);
                return AnimalDetailScreen(animal: animal!);
              },
            ),
            GoRoute(
              parentNavigatorKey: _rootNavigatorKey,
              path: 'edit/:id',
              builder: (context, state) {
                final animalId = state.pathParameters['id']!;
                final animal = MockRepository.instance.getAnimalById(animalId);
                return AnimalFormScreen(animal: animal);
              },
            ),
          ],
        ),
        GoRoute(
          path: '/info',
          pageBuilder: (context, state) => const NoTransitionPage(child: ShelterInfoDisplayScreen()),
          routes: [
            // Вложенный маршрут
            GoRoute(
              parentNavigatorKey: _rootNavigatorKey,
              path: 'edit',
              builder: (context, state) => const ShelterInfoFormScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);