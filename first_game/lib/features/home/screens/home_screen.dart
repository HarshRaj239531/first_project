import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animate_do/animate_do.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../devices/device_provider.dart';
import '../../automation/automation_controller.dart';
import '../../../routes/app_routes.dart';
import '../widgets/room_selector.dart';
import '../../../shared/widgets/device_card.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String _selectedRoom = 'Living Room';

  @override
  Widget build(BuildContext context) {
    final devices = ref.watch(deviceProvider);
    // Legacy support for automation for now
    // final autoCtrl = context.watch<AutomationController>(); 

    final rooms = ref.read(deviceProvider.notifier).rooms;
    final filteredDevices = devices.where((d) => d.room == _selectedRoom).toList();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: FadeInDown(duration: const Duration(milliseconds: 800), child: _Header()),
                ),
                FadeInUp(
                  duration: const Duration(milliseconds: 800),
                  delay: const Duration(milliseconds: 200),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: _StatsRow(
                      devicesOnline: devices.where((d) => d.isOn).length,
                      totalDevices: devices.length,
                      activeRules: 3, // Mocked for now
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                FadeInLeft(
                  duration: const Duration(milliseconds: 600),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      'Quick Rooms',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                RoomSelector(
                  rooms: rooms,
                  selectedRoom: _selectedRoom,
                  onRoomSelected: (room) => setState(() => _selectedRoom = room),
                ),
                const SizedBox(height: 24),
                // Featured devices for room
                SizedBox(
                  height: 180,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filteredDevices.length,
                    itemBuilder: (context, index) {
                      final device = filteredDevices[index];
                      return Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: SizedBox(
                          width: 160,
                          child: DeviceCard(
                            device: device,
                            onToggle: () => ref.read(deviceProvider.notifier).toggleDevice(device.id),
                            onTap: () => Navigator.pushNamed(
                              context, 
                              AppRoutes.deviceDetail, 
                              arguments: device.id,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 40),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    'Smart Capabilities',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: _FeatureGrid(),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Header ─────────────────────────────────────────────────────────────────
class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final hour = DateTime.now().hour;
    final greeting = hour < 12
        ? AppStrings.goodMorning
        : hour < 17
            ? AppStrings.goodAfternoon
            : AppStrings.goodEvening;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$greeting 👋',
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              AppStrings.appName,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 28,
                fontWeight: FontWeight.w900,
                letterSpacing: -1,
              ),
            ),
          ],
        ),
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, AppRoutes.settings),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.glassBorder, width: 0.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(Icons.settings_outlined,
                color: AppColors.textPrimary, size: 24),
          ),
        ),
      ],
    );
  }
}

// ─── Stats Row ───────────────────────────────────────────────────────────────
class _StatsRow extends StatelessWidget {
  final int devicesOnline;
  final int totalDevices;
  final int activeRules;

  const _StatsRow({
    required this.devicesOnline,
    required this.totalDevices,
    required this.activeRules,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            label: AppStrings.devicesOnline,
            value: '$devicesOnline/$totalDevices',
            icon: Icons.bolt_rounded,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _StatCard(
            label: AppStrings.automationActive,
            value: activeRules.toString(),
            icon: Icons.auto_awesome_rounded,
            color: AppColors.accent,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: color.withOpacity(0.2), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(height: 16),
          Text(value,
              style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -1)),
          Text(label,
              style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

// ─── Feature Grid ────────────────────────────────────────────────────────────
class _FeatureGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final features = [
      _Feature('Devices', Icons.devices_other_rounded, AppColors.primary, AppRoutes.devices,
          'Control & monitor'),
      _Feature('Voice AI', Icons.mic_none_rounded, AppColors.violet, AppRoutes.voiceControl,
          'Smart assistant'),
      _Feature('Gesture AI', Icons.pan_tool_outlined, AppColors.pink, AppRoutes.gestureControl,
          'Air controls'),
      _Feature('Dashboard', Icons.language_rounded, AppColors.accent, AppRoutes.webControl,
          'Remote access'),
      _Feature('Automation', Icons.bolt_rounded, AppColors.success, AppRoutes.automation,
          'AI smart rules'),
      _Feature('Settings', Icons.tune_rounded, AppColors.textHint, AppRoutes.settings,
          'Preferences'),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.95,
      ),
      itemCount: features.length,
      itemBuilder: (ctx, i) => FadeInUp(
        duration: const Duration(milliseconds: 600),
        delay: Duration(milliseconds: 500 + (i * 100)),
        child: _FeatureCard(feature: features[i]),
      ),
    );
  }
}

class _Feature {
  final String title;
  final IconData icon;
  final Color color;
  final String route;
  final String subtitle;

  _Feature(this.title, this.icon, this.color, this.route, this.subtitle);
}

class _FeatureCard extends StatefulWidget {
  final _Feature feature;
  const _FeatureCard({required this.feature});

  @override
  State<_FeatureCard> createState() => _FeatureCardState();
}

class _FeatureCardState extends State<_FeatureCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 150));
    _scale = Tween(begin: 1.0, end: 0.96).animate(
        CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final f = widget.feature;
    return GestureDetector(
      onTapDown: (_) => _ctrl.forward(),
      onTapUp: (_) {
        _ctrl.reverse();
        Navigator.pushNamed(context, f.route);
      },
      onTapCancel: () => _ctrl.reverse(),
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: AppColors.glassBorder, width: 0.5),
            boxShadow: [
              BoxShadow(
                color: f.color.withOpacity(0.05),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [f.color, f.color.withOpacity(0.6)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: f.color.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(f.icon, color: Colors.white, size: 26),
              ),
              const SizedBox(height: 20),
              Text(f.title,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w800,
                    fontSize: 17,
                    letterSpacing: -0.5,
                  )),
              const SizedBox(height: 4),
              Text(f.subtitle,
                  style: const TextStyle(
                    color: AppColors.textHint,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis),
            ],
          ),
        ),
      ),
    );
  }
}
