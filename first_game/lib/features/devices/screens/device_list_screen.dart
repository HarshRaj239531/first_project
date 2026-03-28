import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:first_game/core/constants/app_colors.dart';
import 'package:first_game/core/constants/app_strings.dart';
import 'package:first_game/shared/widgets/device_card.dart';
import 'package:flutter/material.dart';
import '../device_provider.dart';

class DeviceListScreen extends ConsumerWidget {
  const DeviceListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final devices = ref.watch(deviceProvider);
    final notifier = ref.read(deviceProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(AppStrings.allDevices),
        actions: [
          PopupMenuButton<String>(
            color: AppColors.surface,
            onSelected: (v) {
              // Implementation for turn all on/off can be added to notifier
            },
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'on', child: Text('Turn All ON', style: TextStyle(color: AppColors.textPrimary))),
              PopupMenuItem(value: 'off', child: Text('Turn All OFF', style: TextStyle(color: AppColors.textPrimary))),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stats bar
            _StatsBar(
              total: devices.length,
              online: devices.where((d) => d.isOn).length,
            ),
            const SizedBox(height: 32),
            // Device grid
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.8,
              ),
              itemCount: devices.length,
              itemBuilder: (ctx, i) {
                final device = devices[i];
                return DeviceCard(
                  device: device,
                  onToggle: () => notifier.toggleDevice(device.id),
                  onTap: () => Navigator.pushNamed(
                    ctx, 
                    '/device-detail', 
                    arguments: device.id,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}


class _StatsBar extends StatelessWidget {
  final int total;
  final int online;

  const _StatsBar({required this.total, required this.online});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.surfaceVariant),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _stat('Total', total.toString(), Icons.devices, AppColors.primary),
          _divider(),
          _stat('Online', online.toString(), Icons.wifi, AppColors.success),
          _divider(),
          _stat('Offline', (total - online).toString(), Icons.wifi_off, AppColors.textHint),
        ],
      ),
    );
  }

  Widget _stat(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 22),
        const SizedBox(height: 6),
        Text(value,
            style: TextStyle(
                color: color, fontWeight: FontWeight.bold, fontSize: 18)),
        Text(label,
            style:
                const TextStyle(color: AppColors.textHint, fontSize: 12)),
      ],
    );
  }

  Widget _divider() => Container(
        height: 40,
        width: 1,
        color: AppColors.surfaceVariant,
      );
}
