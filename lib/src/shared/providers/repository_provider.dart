import 'package:flutter/material.dart';
import 'package:flutter_pr5/src/data/mock_repository.dart';

// InheritedWidget, который будет хранить и предоставлять репозиторий.
class RepositoryProvider extends InheritedWidget {
  final MockRepository repository;

  const RepositoryProvider({
    super.key,
    required this.repository,
    required super.child,
  });

  // Статический метод 'of', который позволяет дочерним виджетам получить доступ к репозиторию.
  static MockRepository of(BuildContext context) {
    final provider = context.dependOnInheritedWidgetOfExactType<RepositoryProvider>();
    if (provider == null) {
      throw StateError('RepositoryProvider not found in context');
    }
    return provider.repository;
  }

  // Определяем, нужно ли уведомлять виджеты-подписчики об изменениях.
  // В нашем случае экземпляр репозитория один и тот же (синглтон),
  // поэтому возвращаем false.
  @override
  bool updateShouldNotify(RepositoryProvider oldWidget) => false;
}