import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/validators.dart';
import '../../../../shared_ui/widgets/q_primary_button.dart';
import '../controllers/login_controller.dart';
import 'register_page.dart';

/// Firebase email/password login screen.
class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _autoValidate = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loginState = ref.watch(loginControllerProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final minHeight = constraints.maxHeight.isFinite
                  ? (constraints.maxHeight - 64).clamp(0.0, double.infinity)
                  : 0.0;

              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: minHeight.toDouble()),
                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildHeader(context),
                        const SizedBox(height: 32),
                        _buildForm(context, loginState),
                        const Spacer(),
                        _buildFooter(context),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 96,
          width: 96,
          child: Image.asset(
            'assets/images/Qester_LOGO.png',
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Witaj ponownie 👋',
          style: theme.textTheme.displaySmall,
        ),
        const SizedBox(height: 8),
        Text(
          'Zaloguj się, aby kontynuować rozwiązywanie quizów.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.textSecondaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildForm(BuildContext context, LoginState loginState) {
    final controller = ref.read(loginControllerProvider.notifier);

    return Form(
      key: _formKey,
      autovalidateMode:
          _autoValidate ? AutovalidateMode.onUserInteraction : AutovalidateMode.disabled,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              labelText: 'Adres email',
              hintText: 'np. jan.kowalski@example.com',
              prefixIcon: Icon(Icons.alternate_email_rounded),
            ),
            validator: Validators.validateEmail,
            onChanged: (_) => controller.clearError(),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _passwordController,
            obscureText: !loginState.isPasswordVisible,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              labelText: 'Hasło',
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                icon: Icon(
                  loginState.isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: controller.togglePasswordVisibility,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Hasło jest wymagane';
              }
              if (value.length < 6) {
                return 'Hasło musi mieć co najmniej 6 znaków';
              }
              return null;
            },
            onChanged: (_) => controller.clearError(),
            onFieldSubmitted: (_) => _submit(),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: loginState.isLoading ? null : _sendResetLink,
              child: const Text('Nie pamiętasz hasła?'),
            ),
          ),
          const SizedBox(height: 8),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: loginState.errorMessage == null
                ? const SizedBox.shrink()
                : Container(
                    key: ValueKey(loginState.errorMessage),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.errorColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppTheme.errorColor.withValues(alpha: 0.4)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.error_outline, color: AppTheme.errorColor),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            loginState.errorMessage!,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: AppTheme.errorColor,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
          const SizedBox(height: 24),
          QPrimaryButton(
            text: 'Zaloguj się',
            isLoading: loginState.isLoading,
            onPressed: loginState.isLoading ? null : _submit,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Divider(
                  color: AppTheme.textSecondaryColor.withValues(alpha: 0.3),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  'lub',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondaryColor,
                      ),
                ),
              ),
              Expanded(
                child: Divider(
                  color: AppTheme.textSecondaryColor.withValues(alpha: 0.3),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          QSecondaryButton(
            text: 'Kontynuuj z Google',
            icon: Icons.g_mobiledata_rounded,
            isLoading: loginState.isLoading,
            onPressed: loginState.isLoading
                ? null
                : () => controller.signInWithGoogle(),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: loginState.isLoading
                ? null
                : () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const RegisterPage(),
                      ),
                    );
                  },
            child: const Text('Nie masz konta? Utwórz je'),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Logowanie obsługiwane przez Firebase Authentication.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13,
            color: AppTheme.textSecondaryColor,
          ),
        ),
        const SizedBox(height: 8),
        TextButton.icon(
          onPressed: _showFirebaseInfoDialog,
          icon: const Icon(Icons.info_outline, size: 18),
          label: const Text('Dowiedz się więcej'),
          style: TextButton.styleFrom(
            foregroundColor: AppTheme.textSecondaryColor,
          ),
        ),
      ],
    );
  }

  void _submit() {
    final formState = _formKey.currentState;
    if (formState == null) {
      return;
    }

    if (!formState.validate()) {
      setState(() {
        _autoValidate = true;
      });
      return;
    }

    FocusScope.of(context).unfocus();
    ref.read(loginControllerProvider.notifier).signIn(
          email: _emailController.text,
          password: _passwordController.text,
        );
  }

  Future<void> _sendResetLink() async {
    final messenger = ScaffoldMessenger.of(context);
    final controller = ref.read(loginControllerProvider.notifier);
    final result = await controller.sendPasswordReset(_emailController.text);

    if (!mounted) return;

    if (result == null) {
      messenger.showSnackBar(
        const SnackBar(
          content: Text('Wysłano link do resetu hasła. Sprawdź skrzynkę e-mail.'),
        ),
      );
    } else {
      messenger.showSnackBar(
        SnackBar(
          content: Text(result),
        ),
      );
    }
  }

  void _showFirebaseInfoDialog() {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Dlaczego Firebase?'),
          content: const Text(
            'Korzystamy z Firebase Authentication, aby bezpiecznie przechowywać konta '
            'użytkowników i obsługiwać logowanie na wielu platformach. Dodaj pliki '
            'konfiguracyjne (google-services.json / GoogleService-Info.plist), aby '
            'połączyć aplikację z własnym projektem Firebase.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Zamknij'),
            ),
          ],
        );
      },
    );
  }
}


