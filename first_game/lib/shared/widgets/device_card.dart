import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../features/devices/models/device_model.dart';

class DeviceCard extends StatelessWidget {
  final Device device;
  final VoidCallback? onToggle;
  final VoidCallback? onTap;

  const DeviceCard({
    super.key,
    required this.device,
    this.onToggle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: device.isOn
              ? LinearGradient(
                  colors: [
                    AppColors.primary.withOpacity(0.3),
                    AppColors.accent.withOpacity(0.1),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: device.isOn ? null : AppColors.cardDark,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: device.isOn
                ? AppColors.primary.withOpacity(0.5)
                : AppColors.surfaceVariant,
            width: 1.2,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: device.isOn
                        ? AppColors.primary.withOpacity(0.2)
                        : AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    device.icon,
                    color: device.isOn ? AppColors.accent : AppColors.textHint,
                    size: 22,
                  ),
                ),
                Switch(
                  value: device.isOn,
                  onChanged: onToggle != null ? (_) => onToggle!() : null,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              device.name,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              device.room,
              style: const TextStyle(color: AppColors.textHint, fontSize: 12),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: device.isOn
                    ? AppColors.deviceOn.withOpacity(0.15)
                    : AppColors.deviceOff.withOpacity(0.3),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                device.isOn ? 'ON' : 'OFF',
                style: TextStyle(
                  color: device.isOn ? AppColors.deviceOn : AppColors.textHint,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
