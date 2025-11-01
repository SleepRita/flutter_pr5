import 'package:flutter_pr5/src/features/animal_shelter/models/animal.dart';
import 'package:flutter_pr5/src/features/shelter_info/models/shelter_info.dart';

// Синглтон - единственный экземпляр класса на все приложение
class MockRepository {
  // Приватный конструктор
  MockRepository._privateConstructor();
  // Статический экземпляр
  static final MockRepository instance = MockRepository._privateConstructor();

  final List<Animal> _animals = [
    Animal(id: '1', name: 'Барсик', type: AnimalType.cat, breed: 'Дворняга', age: 3,
        description: 'Ласковый и игривый кот.', imageUrl: 'https://img.ixbt.site/live/topics/preview/00/07/59/78/b992bbd4ef.jpg'),
    Animal(id: '2', name: 'Рекс', type: AnimalType.dog, breed: 'Овчарка', age: 5,
        description: 'Умный и верный пёс.', imageUrl: 'https://icdn.lenta.ru/images/2024/06/27/15/20240627155726315/pic_3250f5a394ff274cc05326487308ca25.jpg', status: AnimalStatus.treatment),
    Animal(id: '3', name: 'Мурка', type: AnimalType.cat, breed: 'Сиамская', age: 2,
        description: 'Грациозная и независимая.', imageUrl: 'https://pets-start.by/upload/resize_cache/iblock/118/550_500_1/oa6rtyhouqc25s89nmt7ca9ypuzhssax.jpg'),
    Animal(id: '4', name: 'Шарик', type: AnimalType.dog, breed: 'Карликовый пудель', age: 1,
        description: 'Энергичный щенок.', imageUrl: 'https://i.pinimg.com/736x/f0/c6/7c/f0c67c6d8ee566c1d463291449b7a768.jpg'),
    Animal(id: '5', name: 'Пушистик', type: AnimalType.other, breed: 'Кролик', age: 1,
        description: 'Милый декоративный кролик.', imageUrl: 'https://static.tildacdn.com/tild3230-3066-4431-b037-316134383966/tMFc8f5ce-B5hLIAv7Mc.jpg'),
  ];

  List<Animal> getAnimals() => _animals;

  Animal? getAnimalById(String id) {
    try {
      return _animals.firstWhere((animal) => animal.id == id);
    } catch (e) {
      return null;
    }
  }

  void addAnimal(Animal animal) {
    final newAnimalWithId = Animal(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: animal.name,
      type: animal.type,
      breed: animal.breed,
      age: animal.age,
      description: animal.description,
      imageUrl: animal.imageUrl,
      status: animal.status,
      dateAdded: animal.dateAdded,
    );
    _animals.add(newAnimalWithId);
  }

  void updateAnimal(Animal updatedAnimal) {
    final index = _animals.indexWhere((a) => a.id == updatedAnimal.id);
    if (index != -1) {
      _animals[index] = updatedAnimal;
    }
  }

  void deleteAnimal(String id) {
    _animals.removeWhere((animal) => animal.id == id);
  }

  ShelterInfo _shelterInfo = ShelterInfo(
    name: 'Приют "Пушистый дом"',
    address: 'г. Доброград, ул. Уютная, д. 1',
    workingHours: 'Ежедневно с 10:00 до 18:00',
    about: 'Мы - некоммерческая организация, которая помогает бездомным животным найти новый дом и любящую семью.',
  );

  ShelterInfo getShelterInfo() => _shelterInfo;

  void updateShelterInfo(ShelterInfo newInfo) {
    _shelterInfo = newInfo;
  }
}