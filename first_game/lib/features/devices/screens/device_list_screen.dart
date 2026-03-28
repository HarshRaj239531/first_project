import 'package:first_game/core/constants/app_colors.dart';
import 'package:first_game/core/constants/app_strings.dart';
import 'package:first_game/shared/widgets/device_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../device_controller.dart';

class DeviceListScreen extends StatelessWidget {
  const DeviceListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<DeviceController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(AppStrings.allDevices),
        actions: [
          PopupMenuButton<String>(
            color: AppColors.cardDark,
            onSelected: (v) {
              if (v == 'on') controller.turnAllOn();
              if (v == 'off') controller.turnAllOff();
            },
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'on', child: Text('Turn All ON', style: TextStyle(color: AppColors.textPrimary))),
              PopupMenuItem(value: 'off', child: Text('Turn All OFF', style: TextStyle(color: AppColors.textPrimary))),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stats bar
            _StatsBar(
              total: controller.devices.length,
              online: controller.onlineCount,
            ),
            const SizedBox(height: 24),
            // Device grid
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.85,
              ),
              itemCount: controller.devices.length,
              itemBuilder: (ctx, i) {
                final device = controller.devices[i];
                return DeviceCard(
                  device: device,
                  onToggle: () => controller.toggleDevice(device.id),
                  onTap: () => Navigator.pushNamed(ctx, '/device-detail'),
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
