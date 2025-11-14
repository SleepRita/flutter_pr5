import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pr5/src/shared/constants/app_constants.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_pr5/src/features/shelter_info/cubit/display/shelter_info_display_cubit.dart';
import 'package:flutter_pr5/src/features/shelter_info/models/shelter_info.dart';

class ShelterInfoDisplayView extends StatelessWidget {
  const ShelterInfoDisplayView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.aboutShelterLabel),
      ),
      // BlocBuilder отвечает за перерисовку UI при изменении состояния
      body: BlocBuilder<ShelterInfoDisplayCubit, ShelterInfoDisplayState>(
        builder: (context, state) {
          if (state is ShelterInfoDisplayLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is ShelterInfoDisplayLoaded) {
            return _buildContent(context, state.shelterInfo);
          }
          if (state is ShelterInfoDisplayError) {
            return Center(child: Text(state.message));
          }
          return const Center(child: Text('Начальное состояние'));
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, ShelterInfo info) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildInfoCard(context, icon: Icons.home_work_outlined, title: AppConstants.titleLabel, content: info.name),
          _buildInfoCard(context, icon: Icons.location_on_outlined, title: AppConstants.addressLabel, content: info.address),
          _buildInfoCard(context, icon: Icons.access_time_outlined, title: AppConstants.workingTimeLabel, content: info.workingHours),
          _buildInfoCard(context, icon: Icons.info_outline, title: AppConstants.aboutUsLabel, content: info.about),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: AppConstants.editButtonText,
        onPressed: () async {
          // Переход на экран редактирования
          await context.push('/info/edit', extra: info);
          // После возврата с экрана редактирования Cubit перезагружает данные
          // ignore: use_build_context_synchronously
          context.read<ShelterInfoDisplayCubit>().loadShelterInfo();
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