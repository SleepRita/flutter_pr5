import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pr5/src/shared/constants/app_constants.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_pr5/src/features/shelter_info/cubit/form/shelter_info_form_cubit.dart';
import 'package:flutter_pr5/src/features/shelter_info/models/shelter_info.dart';

class ShelterInfoFormView extends StatefulWidget {
  final ShelterInfo initialInfo;

  const ShelterInfoFormView({super.key, required this.initialInfo});

  @override
  State<ShelterInfoFormView> createState() => _ShelterInfoFormViewState();
}

class _ShelterInfoFormViewState extends State<ShelterInfoFormView> {
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
      final newInfo = widget.initialInfo.copyWith(
        name: _nameController.text.trim(),
        address: _addressController.text.trim(),
        workingHours: _hoursController.text.trim(),
        about: _aboutController.text.trim(),
      );
      context.read<ShelterInfoFormCubit>().saveShelterInfo(newInfo);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Редактирование информации'),
      ),
      body: BlocListener<ShelterInfoFormCubit, ShelterInfoFormState>(
        listener: (context, state) {
          if (state is ShelterInfoFormSuccess) {
            context.pop(); // Возврат на предыдущий экран при успехе
          }
          if (state is ShelterInfoFormFailure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(state.error)));
          }
        },
        child: Form(
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
              BlocBuilder<ShelterInfoFormCubit, ShelterInfoFormState>(
                builder: (context, state) {
                  if (state is ShelterInfoFormSaving) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return ElevatedButton(
                    onPressed: _submit,
                    child: const Text(AppConstants.saveButtonText),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}