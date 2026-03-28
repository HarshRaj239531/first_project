import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../settings_controller.dart';
import '../../../routes/app_routes.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<SettingsController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text(AppStrings.settings)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Profile card
          Container(
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.3),
                  blurRadius: 16,
                )
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.person, color: Colors.white, size: 28),
                ),
                const SizedBox(width: 16),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Smart Home User',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16)),
                    SizedBox(height: 4),
                    Text('user@smarthome.ai',
                        style:
                            TextStyle(color: Colors.white70, fontSize: 13)),
                  ],
                ),
              ],
            ),
          ),
          // Appearance
          _SectionHeader(title: 'Appearance'),
          _SettingsTile(
            icon: Icons.dark_mode_outlined,
            title: AppStrings.darkMode,
            subtitle: ctrl.isDarkMode ? 'Enabled' : 'Disabled',
            trailing: Switch(
              value: ctrl.isDarkMode,
              onChanged: (_) =>
                  context.read<SettingsController>().toggleDarkMode(),
            ),
          ),
          // Notifications
          _SectionHeader(title: 'Notifications'),
          _SettingsTile(
            icon: Icons.notifications_outlined,
            title: AppStrings.notifications,
            subtitle: ctrl.notificationsEnabled ? 'On' : 'Off',
            trailing: Switch(
              value: ctrl.notificationsEnabled,
              onChanged: (_) =>
                  context.read<SettingsController>().toggleNotifications(),
            ),
          ),
          // Account
          _SectionHeader(title: 'Account'),
          _SettingsTile(
            icon: Icons.lock_outline,
            title: 'Login / Signup',
            subtitle: 'Manage your account',
            trailing: const Icon(Icons.arrow_forward_ios,
                size: 14, color: AppColors.textHint),
            onTap: () => Navigator.pushNamed(context, AppRoutes.login),
          ),
          _SettingsTile(
            icon: Icons.info_outline,
            title: AppStrings.about,
            subtitle: AppStrings.version,
            trailing: null,
          ),
          const SizedBox(height: 16),
          // Logout
          Container(
            width: double.infinity,
            height: 52,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.error.withOpacity(0.4)),
              borderRadius: BorderRadius.circular(14),
            ),
            child: TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.logout, color: AppColors.error, size: 18),
              label: const Text(AppStrings.logout,
                  style: TextStyle(color: AppColors.error, fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          color: AppColors.textHint,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.surfaceVariant),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        title: Text(title,
            style: const TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500,
                fontSize: 14)),
        subtitle: Text(subtitle,
            style: const TextStyle(
                color: AppColors.textHint, fontSize: 12)),
        trailing: trailing,
        onTap: onTap,
      ),
    );
  }
}
