import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import 'gesture_controller.dart';

class GestureScreen extends StatelessWidget {
  const GestureScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<GestureController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(AppStrings.gestureControl),
        actions: [
          if (ctrl.history.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline, color: AppColors.textHint),
              onPressed: () => context.read<GestureController>().clearHistory(),
            ),
        ],
      ),
      body: Column(
        children: [
          // Camera placeholder
          Container(
            height: 240,
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.cardDark,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.surfaceVariant),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.videocam_outlined,
                      size: 52,
                      color: AppColors.textHint.withOpacity(0.5),
                    ),
                    const SizedBox(height: 12),
                    const Text('Camera Preview',
                        style: TextStyle(color: AppColors.textHint)),
                    const SizedBox(height: 4),
                    const Text('(Use real camera plugin for live feed)',
                        style: TextStyle(
                            color: AppColors.textHint, fontSize: 11)),
                  ],
                ),
                if (ctrl.isDetecting)
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation(AppColors.accent)),
                          SizedBox(height: 12),
                          Text('Detecting...',
                              style: TextStyle(color: AppColors.accent)),
                        ],
                      ),
                    ),
                  ),
                if (ctrl.lastGesture != null && !ctrl.isDetecting)
                  Positioned(
                    bottom: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${ctrl.lastGesture!.typeLabel}  →  ${ctrl.lastGesture!.action}',
                        style: const TextStyle(
                            color: Colors.white, fontSize: 12),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          // Simulate button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: ctrl.isDetecting
                    ? null
                    : () => context.read<GestureController>().detectGesture(),
                icon: const Icon(Icons.pan_tool, size: 18),
                label: Text(ctrl.isDetecting
                    ? 'Detecting...'
                    : AppStrings.startCamera),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          // History
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    AppStrings.gestureHistory,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ctrl.history.isEmpty
                      ? const Center(
                          child: Text('No gestures detected yet.',
                              style: TextStyle(color: AppColors.textHint)))
                      : ListView.builder(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: ctrl.history.length,
                          itemBuilder: (_, i) {
                            final g = ctrl.history[i];
                            return Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.cardDark,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                    color: AppColors.surfaceVariant),
                              ),
                              child: Row(
                                children: [
                                  Text(g.typeLabel,
                                      style: const TextStyle(
                                          color: AppColors.accent,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600)),
                                  const SizedBox(width: 8),
                                  const Icon(Icons.arrow_forward,
                                      size: 14,
                                      color: AppColors.textHint),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(g.action,
                                        style: const TextStyle(
                                            color: AppColors.textPrimary,
                                            fontSize: 12)),
                                  ),
                                  Text(g.deviceTarget,
                                      style: const TextStyle(
                                          color: AppColors.textHint,
                                          fontSize: 11)),
                                ],
                              ),
                            );
                          },
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
