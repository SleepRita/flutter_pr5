import 'package:flutter/material.dart';
import 'package:flutter_pr5/src/features/animal_shelter/screens/animal_list_screen.dart';
import 'package:flutter_pr5/src/features/auth/screens/auth_screen.dart';
import 'package:flutter_pr5/src/features/shelter_info/screens/shelter_info_display_screen.dart';
import 'package:flutter_pr5/src/shared/constants/app_constants.dart';

class MainScreen extends StatefulWidget {
  final bool isAuth;
  const MainScreen({super.key, required this.isAuth});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  @override
  void initState() {
    super.initState();
    // Проверка авторизации. Если пользователь не авторизован, его перенаправит на экран входа.
    if (!widget.isAuth) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const AuthScreen()),
        );
      });
    }
  }

  void _logout() {
    // Выход из аккаунта с полной очисткой стека навигации.
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const AuthScreen()),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Пока происходит перенаправление (если isAuth == false), показывается индикатор
    // загрузки, чтобы избежать моргания экрана.
    if (!widget.isAuth) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.appTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Выйти',
            onPressed: _logout,
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
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AnimalListScreen()),
                );
              },
            ),
            const SizedBox(height: 24),
            _buildNavigationCard(
              context: context,
              icon: Icons.info_outline,
              title: 'О приюте',
              subtitle: 'Узнайте больше о нашей работе',
              // Вертикальная навигация
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ShelterInfoDisplayScreen()),
                );
              },
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