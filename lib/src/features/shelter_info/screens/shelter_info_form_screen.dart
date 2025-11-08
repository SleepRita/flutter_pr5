import 'package:flutter/material.dart';
import 'package:flutter_pr5/src/shared/constants/app_constants.dart';
import 'package:flutter_pr5/src/features/shelter_info/models/shelter_info.dart';
import 'package:flutter_pr5/src/shared/providers/repository_provider.dart';
import 'package:go_router/go_router.dart';

class ShelterInfoFormScreen extends StatefulWidget {
  const ShelterInfoFormScreen({super.key});

  @override
  State<ShelterInfoFormScreen> createState() => _ShelterInfoFormScreenState();
}

class _ShelterInfoFormScreenState extends State<ShelterInfoFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _addressController;
  late TextEditingController _hoursController;
  late TextEditingController _aboutController;

  late ShelterInfo _initialInfo;
  bool _isInitialized = false; // Флаг для однократной инициализации

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      _initialInfo = RepositoryProvider.of(context).getShelterInfo();

      _nameController = TextEditingController(text: _initialInfo.name);
      _addressController = TextEditingController(text: _initialInfo.address);
      _hoursController = TextEditingController(text: _initialInfo.workingHours);
      _aboutController = TextEditingController(text: _initialInfo.about);
      _isInitialized = true;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _hoursController.dispose();
    _aboutController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final newInfo = _initialInfo.copyWith(
        name: _nameController.text.trim(),
        address: _addressController.text.trim(),
        workingHours: _hoursController.text.trim(),
        about: _aboutController.text.trim(),
      );
      RepositoryProvider.of(context).updateShelterInfo(newInfo);
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Редактирование информации'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            TextFormField(controller: _nameController, decoration: const InputDecoration(labelText: AppConstants.titleLabel)),
            const SizedBox(height: 16),
            TextFormField(controller: _addressController, decoration: const InputDecoration(labelText: AppConstants.addressLabel)),
            const SizedBox(height: 16),
            TextFormField(controller: _hoursController, decoration: const InputDecoration(labelText: AppConstants.workingTimeLabel)),
            const SizedBox(height: 16),
            TextFormField(controller: _aboutController, decoration: const InputDecoration(labelText: AppConstants.aboutUsLabel), maxLines: 5),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _submit,
              child: const Text(AppConstants.saveButtonText),
            ),
          ],
        ),
      ),
    );
  }
}