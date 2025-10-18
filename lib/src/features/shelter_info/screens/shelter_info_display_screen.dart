import 'package:flutter/material.dart';
import 'package:flutter_pr5/src/shared/constants/app_constants.dart';
import 'package:flutter_pr5/src/features/shelter_info/models/shelter_info.dart';

class ShelterInfoDisplayScreen extends StatelessWidget {
  final ShelterInfo info;

  const ShelterInfoDisplayScreen({
    super.key,
    required this.info,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        _buildInfoCard(context, icon: Icons.home_work_outlined, title: AppConstants.titleLabel, content: info.name),
        _buildInfoCard(context, icon: Icons.location_on_outlined, title: AppConstants.addressLabel, content: info.address),
        _buildInfoCard(context, icon: Icons.access_time_outlined, title: AppConstants.workingTimeLabel, content: info.workingHours),
        _buildInfoCard(context, icon: Icons.info_outline, title: AppConstants.aboutUsLabel, content: info.about),
      ],
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