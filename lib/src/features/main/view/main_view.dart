import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pr5/src/shared/constants/app_constants.dart';
import 'package:flutter_pr5/src/features/main/cubit/main_cubit.dart';
import 'package:go_router/go_router.dart';

class MainView extends StatelessWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<MainCubit, MainState>(
      listener: (context, state) {
        if (state is MainLogoutSuccess) {
          context.go('/auth');
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(AppConstants.appTitle),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              tooltip: 'Выйти',
              // При нажатии вызов метода из Cubit
              onPressed: () => context.read<MainCubit>().logout(),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildNavigationCard(
                context: context,
                icon: Icons.pets,
                title: 'Подопечные приюта',
                subtitle: 'Просмотр, добавление и редактирование',
                onTap: () => context.push('/animals'),
              ),
              const SizedBox(height: 24),
              _buildNavigationCard(
                context: context,
                icon: Icons.info_outline,
                title: 'О приюте',
                subtitle: 'Узнайте больше о нашей работе',
                onTap: () => context.push('/info'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Вспомогательный виджет для карточки
  Widget _buildNavigationCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Icon(icon, size: 50, color: Theme.of(context).primaryColor),
              const SizedBox(height: 16),
              Text(title, style: Theme.of(context).textTheme.headlineSmall, textAlign: TextAlign.center),
              const SizedBox(height: 8),
              Text(subtitle, style: Theme.of(context).textTheme.bodyMedium, textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}