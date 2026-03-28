import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/validators.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/custom_text_field.dart';
import '../auth_controller.dart';
import 'package:provider/provider.dart';
import '../../../routes/app_routes.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final auth = context.read<AuthController>();
    await auth.signup(_nameCtrl.text.trim(), _emailCtrl.text.trim(), _passCtrl.text);
    if (mounted && auth.isLoggedIn) {
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Create Account')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(28),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.cardDark,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.surfaceVariant),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  AppStrings.signup,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                CustomTextField(
                  label: AppStrings.fullName,
                  prefixIcon: Icons.person_outline,
                  controller: _nameCtrl,
                  validator: Validators.name,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  label: AppStrings.email,
                  prefixIcon: Icons.email_outlined,
                  controller: _emailCtrl,
                  validator: Validators.email,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  label: AppStrings.password,
                  prefixIcon: Icons.lock_outline,
                  controller: _passCtrl,
                  validator: Validators.password,
                  isPassword: true,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  label: AppStrings.confirmPassword,
                  prefixIcon: Icons.lock_outline,
                  controller: _confirmCtrl,
                  validator: (v) => Validators.confirmPassword(v, _passCtrl.text),
                  isPassword: true,
                  textInputAction: TextInputAction.done,
                ),
                const SizedBox(height: 24),
                if (auth.errorMessage != null) ...[
                  Text(auth.errorMessage!,
                      style: const TextStyle(color: AppColors.error, fontSize: 13)),
                  const SizedBox(height: 12),
                ],
                CustomButton(
                  label: AppStrings.signup,
                  onPressed: _submit,
                  isLoading: auth.isLoading,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(AppStrings.alreadyHaveAccount,
                        style: TextStyle(color: AppColors.textHint)),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Text(
                        AppStrings.login,
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
