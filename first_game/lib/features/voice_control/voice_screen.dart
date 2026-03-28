import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import 'voice_controller.dart';

class VoiceScreen extends StatefulWidget {
  const VoiceScreen({super.key});

  @override
  State<VoiceScreen> createState() => _VoiceScreenState();
}

class _VoiceScreenState extends State<VoiceScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _waveCtrl;

  @override
  void initState() {
    super.initState();
    _waveCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _waveCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<VoiceController>();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(context, ctrl),
              // Mic area
              Expanded(
                flex: 3,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildAIWaveform(ctrl),
                      const SizedBox(height: 40),
                      FadeInUp(
                        duration: const Duration(milliseconds: 600),
                        child: Text(
                          ctrl.isListening
                              ? AppStrings.listening
                              : ctrl.isProcessing
                                  ? AppStrings.processing
                                  : AppStrings.tapToSpeak,
                          style: TextStyle(
                            color: ctrl.isListening
                                ? AppColors.accent
                                : AppColors.textPrimary,
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ),
                      if (ctrl.currentText.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: FadeInDown(
                            duration: const Duration(milliseconds: 400),
                            child: Text(
                              '"${ctrl.currentText}"',
                              style: const TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 15,
                                  fontStyle: FontStyle.italic),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              // History
              Expanded(
                flex: 4,
                child: _buildHistorySection(ctrl),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, VoiceController ctrl) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimary, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          const Text(
            'Smart AI Assistant',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          ctrl.history.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.delete_sweep_outlined, color: AppColors.error),
                  onPressed: () => ctrl.clearHistory(),
                )
              : const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildAIWaveform(VoiceController ctrl) {
    return GestureDetector(
      onTap: ctrl.isListening || ctrl.isProcessing
          ? null
          : () => ctrl.startListening(),
      child: AnimatedBuilder(
        animation: _waveCtrl,
        builder: (context, child) {
          return Stack(
            alignment: Alignment.center,
            children: [
              if (ctrl.isListening)
                CustomPaint(
                  size: const Size(200, 200),
                  painter: WavePainter(
                    animationValue: _waveCtrl.value,
                    color: AppColors.primary,
                  ),
                ),
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: ctrl.isListening
                      ? AppColors.mainGradient
                      : const LinearGradient(
                          colors: [AppColors.surface, AppColors.surfaceVariant]),
                  boxShadow: [
                    BoxShadow(
                      color: (ctrl.isListening ? AppColors.primary : Colors.black)
                          .withOpacity(0.3),
                      blurRadius: 20,
                      spreadRadius: 2,
                    )
                  ],
                ),
                child: Icon(
                  ctrl.isListening ? Icons.mic_rounded : Icons.mic_none_rounded,
                  color: Colors.white,
                  size: 40,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHistorySection(VoiceController ctrl) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0x331E293B), // Glass slate
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              children: [
                Container(
                  width: 4,
                  height: 16,
                  decoration: BoxDecoration(
                    color: AppColors.accent,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Recent Commands',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w800,
                    fontSize: 17,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ctrl.history.isEmpty
                ? Center(
                    child: FadeIn(
                      child: const Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.history_rounded, color: AppColors.textHint, size: 48),
                          SizedBox(height: 12),
                          Text(AppStrings.noVoiceCommands,
                              style: TextStyle(color: AppColors.textHint)),
                        ],
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    itemCount: ctrl.history.length,
                    itemBuilder: (_, i) {
                      final style = [FadeInUp, FadeInLeft, FadeInRight][i % 3];
                      return style(
                        duration: const Duration(milliseconds: 500),
                        delay: Duration(milliseconds: i * 100),
                        child: _CommandTile(command: ctrl.history[i]),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class WavePainter extends CustomPainter {
  final double animationValue;
  final Color color;

  WavePainter({required this.animationValue, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    for (int i = 0; i < 3; i++) {
      final value = (animationValue + i / 3) % 1.0;
      final radius = (size.width / 2) * value;
      final opacity = 1.0 - value;

      canvas.drawCircle(
        Offset(size.width / 2, size.height / 2),
        radius,
        paint..color = color.withOpacity(opacity * 0.4),
      );
    }
  }

  @override
  bool shouldRepaint(WavePainter oldDelegate) => true;
}

class _CommandTile extends StatelessWidget {
  final dynamic command;
  const _CommandTile({required this.command});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.glassBorder, width: 0.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.person_outline_rounded, color: AppColors.textSecondary, size: 16),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  command.text,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Icon(Icons.auto_awesome_rounded, color: AppColors.accent, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    command.response,
                    style: const TextStyle(
                        color: AppColors.textSecondary, fontSize: 13, height: 1.4),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

