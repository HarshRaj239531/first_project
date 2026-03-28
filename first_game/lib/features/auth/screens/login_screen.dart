import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/validators.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/custom_text_field.dart';
import '../../auth/auth_controller.dart';
import 'package:provider/provider.dart';
import '../../../routes/app_routes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  late AnimationController _animCtrl;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _fadeAnim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut);
    _animCtrl.forward();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final auth = context.read<AuthController>();
    await auth.login(_emailCtrl.text.trim(), _passCtrl.text);
    if (mounted && auth.isLoggedIn) {
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: FadeTransition(
        opacity: _fadeAnim,
        child: Container(
          decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
          child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(28),
                child: Column(
                  children: [
                    // Logo / Title
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.4),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          )
                        ],
                      ),
                      child: const Icon(Icons.home_outlined, color: Colors.white, size: 36),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      AppStrings.appName,
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      AppStrings.appTagline,
                      style: TextStyle(color: AppColors.textHint, fontSize: 13),
                    ),
                    const SizedBox(height: 40),
                    // Glassmorphism card
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppColors.cardDark.withOpacity(0.85),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: AppColors.surfaceVariant),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 20,
                          )
                        ],
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              AppStrings.login,
                              style: TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 24),
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
                              textInputAction: TextInputAction.done,
                            ),
                            const SizedBox(height: 8),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {},
                                child: const Text(
                                  AppStrings.forgotPassword,
                                  style: TextStyle(color: AppColors.accent, fontSize: 13),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            if (auth.errorMessage != null) ...[
                              Text(
                                auth.errorMessage!,
                                style: const TextStyle(color: AppColors.error, fontSize: 13),
                              ),
                              const SizedBox(height: 12),
                            ],
                            CustomButton(
                              label: AppStrings.login,
                              onPressed: _submit,
                              isLoading: auth.isLoading,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(AppStrings.dontHaveAccount,
                            style: TextStyle(color: AppColors.textHint)),
                        GestureDetector(
                          onTap: () => Navigator.pushNamed(context, AppRoutes.signup),
                          child: const Text(
                            AppStrings.signup,
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
        ),
      ),
    );
  }
}
