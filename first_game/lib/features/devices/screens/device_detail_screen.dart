import 'package:first_game/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../device_controller.dart';

class DeviceDetailScreen extends StatelessWidget {
  const DeviceDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<DeviceController>();
    // For demo, show detailed view of first device
    final device = controller.devices.isNotEmpty ? controller.devices[0] : null;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text(device?.name ?? 'Device Detail')),
      body: device == null
          ? const Center(child: Text('No device selected.'))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // Hero icon
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: device.isOn ? AppColors.primaryGradient : null,
                      color: device.isOn ? null : AppColors.cardDark,
                      boxShadow: device.isOn
                          ? [
                              BoxShadow(
                                color: AppColors.primary.withOpacity(0.4),
                                blurRadius: 24,
                                spreadRadius: 4,
                              )
                            ]
                          : [],
                    ),
                    child: Icon(device.icon, size: 52, color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  Text(device.name,
                      style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 22,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(device.room,
                      style: const TextStyle(color: AppColors.textSecondary)),
                  const SizedBox(height: 4),
                  Text(device.typeLabel,
                      style: const TextStyle(color: AppColors.textHint)),
                  const SizedBox(height: 32),
                  // Toggle
                  _InfoCard(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Power',
                              style: TextStyle(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.w600)),
                          Switch(
                            value: device.isOn,
                            onChanged: (_) =>
                                controller.toggleDevice(device.id),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _InfoCard(
                    children: [
                      _infoRow('Status', device.isOn ? 'Online' : 'Offline'),
                      _divider(),
                      _infoRow('Room', device.room),
                      _divider(),
                      _infoRow('Type', device.typeLabel),
                      _divider(),
                      _infoRow('Device ID', device.id),
                    ],
                  ),
                ],
              ),
            ),
    );
  }

  Widget _infoRow(String label, String value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style: const TextStyle(color: AppColors.textSecondary)),
            Text(value,
                style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500)),
          ],
        ),
      );

  Widget _divider() => const Divider(color: AppColors.surfaceVariant, height: 1);
}

class _InfoCard extends StatelessWidget {
  final List<Widget> children;
  const _InfoCard({required this.children});

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.cardDark,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.surfaceVariant),
        ),
        child: Column(children: children),
      );
}
