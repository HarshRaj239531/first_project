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
      child: Hero(
        tag: 'device_${device.id}',
        child: Material(
          color: Colors.transparent,
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
              color: device.isOn ? null : AppColors.surface,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: device.isOn
                    ? AppColors.primary.withOpacity(0.5)
                    : AppColors.glassBorder,
                width: 1.2,
              ),
              boxShadow: device.isOn
                  ? [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      )
                    ]
                  : [],
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
                            : AppColors.surfaceVariant.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        device.icon,
                        color: device.isOn ? AppColors.accent : AppColors.textHint,
                        size: 24,
                      ),
                    ),
                    Switch(
                      value: device.isOn,
                      onChanged: onToggle != null ? (_) => onToggle!() : null,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  device.name,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  device.room,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: device.isOn
                        ? AppColors.success.withOpacity(0.15)
                        : AppColors.surfaceVariant.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: device.isOn ? AppColors.success : AppColors.textHint,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        device.isOn ? 'ACTIVE' : 'OFFLINE',
                        style: TextStyle(
                          color: device.isOn ? AppColors.success : AppColors.textHint,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
