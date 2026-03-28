import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../automation_controller.dart';

class AutomationScreen extends StatelessWidget {
  const AutomationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<AutomationController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text(AppStrings.automation)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        icon: const Icon(Icons.add),
        label: const Text(AppStrings.addRule),
      ),
      body: ctrl.isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(AppColors.primary),
              ),
            )
          : ctrl.rules.isEmpty
              ? const Center(
                  child: Text(AppStrings.noRules,
                      style: TextStyle(color: AppColors.textHint)))
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: ctrl.rules.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 10),
                  itemBuilder: (_, i) {
                    final rule = ctrl.rules[i];
                    return _RuleCard(
                      rule: rule,
                      onToggle: () =>
                          context.read<AutomationController>().toggleRule(rule.id),
                      onDelete: () =>
                          context.read<AutomationController>().removeRule(rule.id),
                    );
                  },
                ),
    );
  }
}

class _RuleCard extends StatelessWidget {
  final dynamic rule;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const _RuleCard({
    required this.rule,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: rule.isEnabled
              ? AppColors.primary.withOpacity(0.3)
              : AppColors.surfaceVariant,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: rule.isEnabled
                      ? AppColors.primary.withOpacity(0.15)
                      : AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.auto_awesome,
                    color: rule.isEnabled
                        ? AppColors.accent
                        : AppColors.textHint,
                    size: 18),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  rule.name,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
              Switch(value: rule.isEnabled, onChanged: (_) => onToggle()),
              IconButton(
                icon: const Icon(Icons.delete_outline,
                    color: AppColors.error, size: 18),
                onPressed: onDelete,
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(color: AppColors.surfaceVariant, height: 1),
          const SizedBox(height: 10),
          _InfoRow(label: 'Trigger', value: rule.trigger, icon: Icons.bolt_outlined),
          const SizedBox(height: 6),
          _InfoRow(label: 'Condition', value: rule.condition, icon: Icons.filter_alt_outlined),
          const SizedBox(height: 6),
          _InfoRow(label: 'Action', value: rule.action, icon: Icons.play_circle_outline),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _InfoRow({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 14, color: AppColors.textHint),
        const SizedBox(width: 6),
        Text('$label: ',
            style: const TextStyle(color: AppColors.textHint, fontSize: 12)),
        Expanded(
          child: Text(value,
              style: const TextStyle(
                  color: AppColors.textSecondary, fontSize: 12)),
        ),
      ],
    );
  }
}
