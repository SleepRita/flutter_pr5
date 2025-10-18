import 'package:flutter/material.dart';
import 'package:flutter_pr5/src/shared/constants/app_constants.dart';
import 'package:flutter_pr5/src/features/shelter_info/models/shelter_info.dart';

class ShelterInfoFormScreen extends StatefulWidget {
  final ShelterInfo initialInfo;
  final Function(ShelterInfo) onSave;
  final VoidCallback onCancel;

  const ShelterInfoFormScreen({super.key, required this.initialInfo, required this.onSave, required this.onCancel});

  @override
  State<ShelterInfoFormScreen> createState() => _ShelterInfoFormScreenState();
}

class _ShelterInfoFormScreenState extends State<ShelterInfoFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _addressController;
  late TextEditingController _hoursController;
  late TextEditingController _aboutController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialInfo.name);
    _addressController = TextEditingController(text: widget.initialInfo.address);
    _hoursController = TextEditingController(text: widget.initialInfo.workingHours);
    _aboutController = TextEditingController(text: widget.initialInfo.about);
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final newInfo = widget.initialInfo.copyWith(
        name: _nameController.text,
        address: _addressController.text,
        workingHours: _hoursController.text,
        about: _aboutController.text,
      );
      widget.onSave(newInfo);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(onPressed: widget.onCancel, child: const Text(AppConstants.cancelButtonText)),
                const SizedBox(width: 8),
                ElevatedButton(onPressed: _submit, child: const Text(AppConstants.saveButtonText)),
              ],
            )
          ],
        ),
      ),
    );
  }
}