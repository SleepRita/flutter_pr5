import 'package:flutter/material.dart';
import 'package:flutter_pr5/src/data/mock_repository.dart';
import 'package:flutter_pr5/src/service_locator.dart';
import 'package:flutter_pr5/src/shared/constants/app_constants.dart';
import 'package:flutter_pr5/src/features/shelter_info/models/shelter_info.dart';
import 'package:go_router/go_router.dart';

class ShelterInfoDisplayScreen extends StatefulWidget {
  const ShelterInfoDisplayScreen({super.key});

  @override
  State<ShelterInfoDisplayScreen> createState() => _ShelterInfoDisplayScreenState();
}

class _ShelterInfoDisplayScreenState extends State<ShelterInfoDisplayScreen> {
  // Локальное состояние для отображения информации
  late ShelterInfo _info;

  @override
  void initState() {
    super.initState();
    _info = getIt<MockRepository>().getShelterInfo();
  }

  // Метод для обновления данных после возврата с экрана редактирования
  void _refreshInfo() {
    setState(() {
      _info = getIt<MockRepository>().getShelterInfo();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.aboutShelterLabel),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildInfoCard(context, icon: Icons.home_work_outlined, title: AppConstants.titleLabel, content: _info.name),
          _buildInfoCard(context, icon: Icons.location_on_outlined, title: AppConstants.addressLabel, content: _info.address),
          _buildInfoCard(context, icon: Icons.access_time_outlined, title: AppConstants.workingTimeLabel, content: _info.workingHours),
          _buildInfoCard(context, icon: Icons.info_outline, title: AppConstants.aboutUsLabel, content: _info.about),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: AppConstants.editButtonText,
        onPressed: () async {
          await context.push('/info/edit');
          _refreshInfo();
        },
        child: const Icon(Icons.edit),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, {required IconData icon, required String title, required String content}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Theme.of(context).primaryColor),
                const SizedBox(width: 8),
                Text(title, style: Theme.of(context).textTheme.titleLarge),
              ],
            ),
            const Divider(height: 20),
            Text(content, style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.5)),
          ],
        ),
      ),
    );
  }
}