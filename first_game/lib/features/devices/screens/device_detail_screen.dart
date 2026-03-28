import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animate_do/animate_do.dart';
import 'package:first_game/core/constants/app_colors.dart';
import 'package:first_game/shared/widgets/circular_slider.dart';
import '../device_provider.dart';
import '../models/device_model.dart';

class DeviceDetailScreen extends ConsumerWidget {
  final String? deviceId;
  const DeviceDetailScreen({super.key, this.deviceId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final devices = ref.watch(deviceProvider);
    final device = devices.firstWhere((d) => d.id == deviceId, orElse: () => devices[0]);
    final notifier = ref.read(deviceProvider.notifier);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(context, device),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      _buildHeroIcon(device),
                      const SizedBox(height: 24),
                      _buildStatusHeader(device),
                      const SizedBox(height: 40),
                      _buildMainControls(device, notifier),
                      const SizedBox(height: 32),
                      _buildAdvancedStats(device),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildPowerToggle(device, notifier),
    );
  }

  Widget _buildAppBar(BuildContext context, Device device) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimary, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          Text(
            device.name,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.more_vert_rounded, color: AppColors.textPrimary),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildHeroIcon(Device device) {
    return FadeInDown(
      duration: const Duration(milliseconds: 600),
      child: Hero(
        tag: 'device_${device.id}',
        child: Container(
          width: 140,
          height: 140,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: device.isOn ? AppColors.primary.withOpacity(0.1) : AppColors.surface,
            border: Border.all(
              color: device.isOn ? AppColors.primary.withOpacity(0.5) : AppColors.glassBorder,
              width: 1,
            ),
            boxShadow: device.isOn ? [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.2),
                blurRadius: 30,
                spreadRadius: 2,
              )
            ] : [],
          ),
          child: Icon(
            device.icon,
            size: 60,
            color: device.isOn ? AppColors.accent : AppColors.textHint,
          ),
        ),
      ),
    );
  }

  Widget _buildStatusHeader(Device device) {
    return Column(
      children: [
        Text(
          device.room.toUpperCase(),
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.w800,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: device.isOn ? AppColors.success.withOpacity(0.1) : AppColors.error.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            device.isOn ? 'ONLINE' : 'OFFLINE',
            style: TextStyle(
              color: device.isOn ? AppColors.success : AppColors.error,
              fontSize: 10,
              fontWeight: FontWeight.w900,
              letterSpacing: 1,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMainControls(Device device, DeviceNotifier notifier) {
    if (!device.isOn) {
      return FadeIn(
        child: Container(
          height: 250,
          alignment: Alignment.center,
          child: const Text(
            'Device is powered off',
            style: TextStyle(color: AppColors.textHint, fontSize: 16),
          ),
        ),
      );
    }

    switch (device.type) {
      case DeviceType.ac:
      case DeviceType.thermostat:
        return FadeInUp(
          child: CircularSlider(
            value: device.temperature,
            min: 16,
            max: 30,
            label: 'TEMPERATURE',
            color: AppColors.primary,
            onChanged: (v) => notifier.updateAttribute(device.id, temperature: v),
          ),
        );
      case DeviceType.light:
        return _buildLightControls(device, notifier);
      case DeviceType.fan:
        return _buildFanControls(device, notifier);
      default:
        return const SizedBox(height: 200, child: Center(child: Text('Basic Switch Control', style: TextStyle(color: AppColors.textSecondary))));
    }
  }

  Widget _buildLightControls(Device device, DeviceNotifier notifier) {
    return FadeInUp(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('BRIGHTNESS', style: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w800, fontSize: 12)),
              Text('${(device.brightness * 100).toInt()}%', style: const TextStyle(color: AppColors.accent, fontWeight: FontWeight.w800)),
            ],
          ),
          Slider(
            value: device.brightness,
            activeColor: AppColors.accent,
            inactiveColor: AppColors.surfaceVariant,
            onChanged: (v) => notifier.updateAttribute(device.id, brightness: v),
          ),
          const SizedBox(height: 32),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text('SCENE COLOR', style: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w800, fontSize: 12)),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _colorNode(Colors.white, device, notifier),
              _colorNode(Colors.orangeAccent, device, notifier),
              _colorNode(Colors.blueAccent, device, notifier),
              _colorNode(Colors.purpleAccent, device, notifier),
              _colorNode(Colors.greenAccent, device, notifier),
            ],
          ),
        ],
      ),
    );
  }

  Widget _colorNode(Color color, Device device, DeviceNotifier notifier) {
    bool isSelected = device.color == color;
    return GestureDetector(
      onTap: () => notifier.updateAttribute(device.id, color: color),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: isSelected ? Border.all(color: Colors.white, width: 3) : null,
          boxShadow: isSelected ? [BoxShadow(color: color.withOpacity(0.5), blurRadius: 15, spreadRadius: 2)] : [],
        ),
      ),
    );
  }

  Widget _buildFanControls(Device device, DeviceNotifier notifier) {
    return FadeInUp(
      child: Column(
        children: [
          const Text('FAN SPEED', style: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w800, fontSize: 12)),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(4, (index) {
              bool isSelected = device.speed == index;
              return GestureDetector(
                onTap: () => notifier.updateAttribute(device.id, speed: index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: isSelected ? AppColors.primary : AppColors.glassBorder),
                  ),
                  child: Text(
                    index == 0 ? 'OFF' : index.toString(),
                    style: TextStyle(color: isSelected ? Colors.white : AppColors.textSecondary, fontWeight: FontWeight.w900),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildAdvancedStats(Device device) {
    return FadeInUp(
      delay: const Duration(milliseconds: 400),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.surface.withOpacity(0.5),
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: AppColors.glassBorder, width: 0.5),
        ),
        child: Column(
          children: [
            _statRow(Icons.timer_outlined, 'USAGE TODAY', '4.2 Hrs'),
            const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Divider(color: AppColors.glassBorder)),
            _statRow(Icons.bolt_rounded, 'ENERGY CONSUMPTION', '1.8 kWh'),
            const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Divider(color: AppColors.glassBorder)),
            _statRow(Icons.history_rounded, 'LAST ACTIVE', '12 mins ago'),
          ],
        ),
      ),
    );
  }

  Widget _statRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: AppColors.textHint, size: 20),
        const SizedBox(width: 16),
        Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12, fontWeight: FontWeight.w600)),
        const Spacer(),
        Text(value, style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w800)),
      ],
    );
  }

  Widget _buildPowerToggle(Device device, DeviceNotifier notifier) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: ElevatedButton(
          onPressed: () => notifier.toggleDevice(device.id),
          style: ElevatedButton.styleFrom(
            backgroundColor: device.isOn ? AppColors.error : AppColors.success,
            minimumSize: const Size(double.infinity, 60),
          ),
          child: Text(
            device.isOn ? 'TURN OFF DEVICE' : 'TURN ON DEVICE',
            style: const TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1),
          ),
        ),
      ),
    );
  }
}

