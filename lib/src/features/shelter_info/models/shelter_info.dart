class ShelterInfo {
  final String name;
  final String address;
  final String workingHours;
  final String about;

  ShelterInfo({
    required this.name,
    required this.address,
    required this.workingHours,
    required this.about,
  });

  ShelterInfo copyWith({
    String? name,
    String? address,
    String? workingHours,
    String? about,
  }) {
    return ShelterInfo(
      name: name ?? this.name,
      address: address ?? this.address,
      workingHours: workingHours ?? this.workingHours,
      about: about ?? this.about,
    );
  }
}