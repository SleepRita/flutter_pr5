part of 'auth_cubit.dart';

// Абстрактный базовый класс для всех состояний
// Equatable нужен для того, чтобы можно было сравнивать состояния: state1 == state2
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

// Начальное состояние, экран ничего не делает
class AuthInitial extends AuthState {}

// Состояние загрузки, показывается индикатор прогресса
class AuthLoading extends AuthState {}

// Состояние успешной аутентификации
class AuthSuccess extends AuthState {}

// Состояние ошибки, можно показать сообщение
class AuthFailure extends AuthState {
  final String error;

  const AuthFailure(this.error);

  @override
  List<Object> get props => [error];
}