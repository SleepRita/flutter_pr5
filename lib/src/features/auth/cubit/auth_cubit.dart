import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pr5/src/shared/routing/app_router.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  // Метод для входа в систему.
  Future<void> login(String login, String password) async {
    // Валидация
    if (login.isEmpty || password.isEmpty) {
      emit(const AuthFailure('Логин и пароль не могут быть пустыми'));
      return;
    }

    emit(AuthLoading());

    try {
      // Имитация сетевого запроса
      await Future.delayed(const Duration(seconds: 1));

      isAuth = true;

      emit(AuthSuccess());
    } catch (e) {
      emit(const AuthFailure('Произошла ошибка при входе'));
    }
  }
}