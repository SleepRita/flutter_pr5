import 'package:flutter/material.dart';
import 'package:flutter_pr5/src/shared/constants/app_constants.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_pr5/src/shared/routing/app_router.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  void _logout(BuildContext context) {
    isAuth = false;
    context.go('/auth');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.appTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Выйти',
            onPressed: () => _logout(context),
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
              // Вертикальная навигация
              onTap: () => context.push('/animals'),
            ),
            const SizedBox(height: 24),
            _buildNavigationCard(
              context: context,
              icon: Icons.info_outline,
              title: 'О приюте',
              subtitle: 'Узнайте больше о нашей работе',
              // Вертикальная навигация
              onTap: () => context.push('/info'),
            ),
          ],
        ),
      ),
    );
  }

  // Вспомогательный виджет для отрисовки навигационной карточки
  Widget _buildNavigationCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      clipBehavior: Clip.antiAlias, // Для красивого эффекта нажатия
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