import 'package:flutter/material.dart';
import 'package:flutter_pr5/src/shared/constants/app_constants.dart';
import '../models/shelter_info.dart';
import '../screens/shelter_info_display_screen.dart';
import '../screens/shelter_info_form_screen.dart';

class ShelterInfoContainer extends StatefulWidget {
  const ShelterInfoContainer({super.key});

  @override
  State<ShelterInfoContainer> createState() => _ShelterInfoContainerState();
}

class _ShelterInfoContainerState extends State<ShelterInfoContainer> {
  ShelterInfo _info = ShelterInfo(
    name: 'Приют "Пушистый дом"',
    address: 'г. Доброград, ул. Уютная, д. 1',
    workingHours: 'Ежедневно с 10:00 до 18:00',
    about: 'Мы - некоммерческая организация, которая помогает бездомным животным '
        'найти новый дом и любящую семью. Создан в 2024 году группой волонтеров.',
  );

  bool _isEditing = false;

  void _updateInfo(ShelterInfo newInfo) {
    setState(() {
      _info = newInfo;
      _isEditing = false;
    });
  }

  void _toggleEditMode() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? AppConstants.editingLabel : AppConstants.aboutShelterLabel),
      ),
      body: _isEditing
          ? ShelterInfoFormScreen(
        initialInfo: _info,
        onSave: _updateInfo,
        onCancel: _toggleEditMode,
      )
          : ShelterInfoDisplayScreen(
        info: _info,
      ),
      floatingActionButton: !_isEditing
          ? FloatingActionButton(
        onPressed: _toggleEditMode,
        tooltip: AppConstants.editButtonText,
        child: const Icon(Icons.edit),
      )
          : null,
    );
  }
}