import 'package:get_it/get_it.dart';
import 'package:flutter_pr5/src/data/mock_repository.dart';

// Глобальный экземпляр GetIt
final getIt = GetIt.instance;

void setupLocator() {
  getIt.registerLazySingleton<MockRepository>(() => MockRepository.instance);
}