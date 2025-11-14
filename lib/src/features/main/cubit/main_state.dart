part of 'main_cubit.dart';

abstract class MainState extends Equatable {
  const MainState();

  @override
  List<Object> get props => [];
}

// Начальное, стандартное состояние экрана
class MainInitial extends MainState {}

// Состояние, которое отправляется после успешного выхода
class MainLogoutSuccess extends MainState {}