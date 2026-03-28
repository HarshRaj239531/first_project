import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../devices/device_controller.dart';
import '../../../shared/widgets/device_card.dart';

class WebDashboardScreen extends StatelessWidget {
  const WebDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<DeviceController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(AppStrings.webControl),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.success.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.success.withOpacity(0.4)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.success,
                  ),
                ),
                const SizedBox(width: 6),
                const Text('Connected',
                    style: TextStyle(color: AppColors.success, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Web Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 16,
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.language, color: Colors.white, size: 20),
                      const SizedBox(width: 8),
                      const Text('Web Dashboard',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${ctrl.onlineCount} of ${ctrl.devices.length} devices online',
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.85), fontSize: 13),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'All Devices',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 12),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.85,
              ),
              itemCount: ctrl.devices.length,
              itemBuilder: (_, i) {
                final device = ctrl.devices[i];
                return DeviceCard(
                  device: device,
                  onToggle: () => ctrl.toggleDevice(device.id),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
