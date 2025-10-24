enum AnimalStatus { lookingForHome, adopted, treatment }
enum AnimalType { cat, dog, other }

class Animal {
  final String id;
  final String name;
  final AnimalType type;
  final String breed;
  final int age;
  final String description;
  final String imageUrl;
  final AnimalStatus status;
  final DateTime dateAdded;

  Animal({
    required this.id,
    required this.name,
    required this.type,
    required this.breed,
    required this.age,
    required this.description,
    required this.imageUrl,
    this.status = AnimalStatus.lookingForHome,
    DateTime? dateAdded,
  }) : this.dateAdded = dateAdded ?? DateTime.now();

  // Метод copyWith для удобного изменения состояния
  Animal copyWith({
    String? name,
    AnimalType? type,
    String? breed,
    int? age,
    String? description,
    String? imageUrl,
    AnimalStatus? status,
  }) {
    return Animal(
      id: this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      breed: breed ?? this.breed,
      age: age ?? this.age,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      status: status ?? this.status,
      dateAdded: this.dateAdded,
    );
  }
}