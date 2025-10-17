import 'package:flutter/material.dart';

class AppConstants {
  // Strings
  static const String appTitle = 'Приют "Пушистый дом"';
  static const String editButtonText = 'Редактировать';
  static const String saveButtonText = 'Сохранить';
  static const String deleteButtonText = 'Удалить из базы';
  static const String cancelButtonText = 'Отмена';
  static const String clearFiltersButtonText = 'Очистить фильтры';
  static const String addButtonText = 'Добавить';
  static const String petListTitle = 'Подопечные приюта';
  static const String nameLabel = 'Кличка';
  static const String typeLabel = 'Вид';
  static const String breedLabel = 'Порода';
  static const String ageLabel = 'Возраст';
  static const String descriptionLabel = 'Описание';
  static const String statusLabel = 'Статус';
  static const String ageMeasureLabel = 'года/лет';
  static const String oneAgeMeasureLabel = 'год';
  static const String newPetLabel = 'Новый подопечный';
  static const String enterNameLabel = 'Введите кличку';
  static const String enterBreedLabel = 'Введите породу';
  static const String enterAgeLabel = 'Введите возраст';
  static const String enterIntLabel = 'Введите корректное число';
  static const String descriptionAgeLabel = 'Введите возраст';
  static const String petLabel = 'Подопечный ';
  static const String deletedLabel = ' удален';
  static const String searchByNameLabel = 'Поиск по кличке...';
  static const String allTypesLabel = 'Все виды';
  static const String allStatusesLabel = 'Все статусы';
  static const String ageStartLabel = 'Возраст: от ';
  static const String ageToLabel = ' до ';
  static const String petAgesLabel = ' лет';
  static const String notFoundLabel = 'По вашему запросу ничего не найдено.\nПопробуйте изменить или сбросить фильтры.';
  static const String detailsLabel = 'Детали';
  static const String titleLabel = 'Название';
  static const String addressLabel = 'Адрес';
  static const String workingTimeLabel = 'Часы посещений';
  static const String aboutUsLabel = 'О нас';
  static const String aboutShelterLabel = 'О приюте';
  static const String editingLabel = 'Редактирование';
  static const String petsLabel = 'Подопечные';

  // Colors
  static const MaterialColor primaryColor = Colors.cyan;

  // Lists for Dropdowns
  static const List<String> animalTypes = ['Кошка', 'Собака', 'Другое'];
  static const List<String> animalStatuses = ['Ищет дом', 'Нашел дом', 'На лечении'];

  // Paddings and Spacings
  static const double defaultPadding = 16.0;
}