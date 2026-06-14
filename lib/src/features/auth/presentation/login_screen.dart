import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/primary_button.dart';
import 'auth_controller.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  bool _isLogin = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  bool _isSubmitting = false;

  void _submit() {
    // Guard against double-tap: button widget is also disabled while
    // authState.isLoading, but a fast double-tap can race the state update.
    if (_isSubmitting) return;
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);
    HapticFeedback.lightImpact();
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    // Listen for the state transition to loading->data/error to release
    // the guard. We use a one-shot listener so we don't leak subscriptions.
    ref.listenManual<AsyncValue<dynamic>>(
      authControllerProvider,
      (prev, next) {
        if (next.isLoading == false && mounted) {
          setState(() => _isSubmitting = false);
        }
      },
    );

    if (_isLogin) {
      ref.read(authControllerProvider.notifier).login(email, password);
    } else {
      final name = _nameController.text.trim();
      ref.read(authControllerProvider.notifier).register(email, password, name);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final isLoading = authState.isLoading;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    ref.listen(authControllerProvider, (previous, next) {
      if (next is AsyncError) {
        final error = next.error;
        final message = error is ApiException
            ? error.message
            : 'An unexpected error occurred. Please try again.';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    });

    final maxWidth = Responsive.contentMaxWidth(context);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: isDark ? AppColors.darkBackgroundGradient : null,
          color: isDark ? null : AppColors.backgroundLight,
        ),
        child: Stack(
          children: [
            // ─── Decorative gradient blob ───────────────────────────
            Positioned(
              top: -120,
              right: -120,
              child: Container(
                width: 320,
                height: 320,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.primary.withValues(alpha: isDark ? 0.25 : 0.15),
                      AppColors.primary.withValues(alpha: 0),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: -100,
              left: -100,
              child: Container(
                width: 280,
                height: 280,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.secondary.withValues(alpha: isDark ? 0.25 : 0.12),
                      AppColors.secondary.withValues(alpha: 0),
                    ],
                  ),
                ),
              ),
            ),

            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: Responsive.pagePadding(context),
                    vertical: AppTheme.space8,
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: maxWidth),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: AppTheme.space8),

                          // ─── Brand mark ─────────────────────────────
                          Center(
                            child: Container(
                              width: 88,
                              height: 88,
                              decoration: BoxDecoration(
                                gradient: AppColors.brandGradient,
                                borderRadius:
                                    BorderRadius.circular(AppTheme.radius2xl),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primary
                                        .withValues(alpha: 0.3),
                                    blurRadius: 24,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.favorite_rounded,
                                color: Colors.white,
                                size: 40,
                              ),
                            )
                                .animate()
                                .scale(
                                  duration: 500.ms,
                                  curve: Curves.easeOutBack,
                                ),
                          ),
                          const SizedBox(height: AppTheme.space6),

                          // ─── Title ─────────────────────────────────
                          Text(
                            _isLogin ? 'Welcome back' : 'Create account',
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: -0.5,
                                ),
                          ).animate().fadeIn(delay: 150.ms, duration: 400.ms),
                          const SizedBox(height: AppTheme.space2),
                          Text(
                            _isLogin
                                ? 'Sign in to continue to Wedding Cards'
                                : 'Get started in less than a minute',
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant,
                                ),
                          ).animate().fadeIn(delay: 250.ms, duration: 400.ms),

                          const SizedBox(height: AppTheme.space10),

                          // ─── Form Card ────────────────────────────
                          Container(
                            padding: const EdgeInsets.all(AppTheme.space6),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface,
                              borderRadius:
                                  BorderRadius.circular(AppTheme.radius2xl),
                              border: Border.all(
                                color: isDark
                                    ? AppColors.slate800
                                    : AppColors.slate200,
                                width: 1,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                if (!_isLogin) ...[
                                  AppTextField(
                                    controller: _nameController,
                                    label: 'Full name',
                                    hint: 'John Doe',
                                    prefixIcon: Icons.person_outline_rounded,
                                    validator: Validators.validateRequired,
                                  )
                                      .animate()
                                      .slideY(
                                        begin: 0.1,
                                        duration: 300.ms,
                                      )
                                      .fadeIn(),
                                  const SizedBox(height: AppTheme.space4),
                                ],

                                AppTextField(
                                  controller: _emailController,
                                  label: 'Email',
                                  hint: 'you@example.com',
                                  keyboardType: TextInputType.emailAddress,
                                  prefixIcon: Icons.alternate_email_rounded,
                                  validator: Validators.validateEmail,
                                ).animate().fadeIn(delay: 100.ms, duration: 400.ms),
                                const SizedBox(height: AppTheme.space4),

                                AppTextField(
                                  controller: _passwordController,
                                  label: 'Password',
                                  obscureText: true,
                                  prefixIcon: Icons.lock_outline_rounded,
                                  validator: Validators.validatePassword,
                                ).animate().fadeIn(delay: 200.ms, duration: 400.ms),
                                const SizedBox(height: AppTheme.space6),

                                PrimaryButton(
                                  onPressed: (isLoading || _isSubmitting) ? null : _submit,
                                  label: _isLogin ? 'Sign in' : 'Create account',
                                  isLoading: isLoading || _isSubmitting,
                                ).animate().fadeIn(delay: 300.ms, duration: 400.ms),
                              ],
                            ),
                          ).animate().fadeIn(delay: 350.ms, duration: 500.ms).slideY(begin: 0.05),

                          const SizedBox(height: AppTheme.space6),

                          // ─── Toggle ─────────────────────────────────
                          TextButton(
                            onPressed: () {
                              setState(() => _isLogin = !_isLogin);
                            },
                            child: Text.rich(
                              TextSpan(
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant,
                                    ),
                                children: [
                                  TextSpan(
                                    text: _isLogin
                                        ? "Don't have an account? "
                                        : 'Already have an account? ',
                                  ),
                                  TextSpan(
                                    text: _isLogin ? 'Sign up' : 'Sign in',
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ).animate().fadeIn(delay: 500.ms, duration: 400.ms),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
