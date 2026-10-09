import 'package:flutter/material.dart';

import '../../../../config/themes/app_theme.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/widgets/kit.dart';
import 'forgot_password_page.dart';
import 'sign_up_page.dart';

/// "Sign In" screen from the kit, backed by Firebase Auth.
class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  String? _error;
  bool _loading = false;
  bool _googleLoading = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    FocusScope.of(context).unfocus();
    if (!_email.text.contains('@') || _password.text.isEmpty) {
      setState(() => _error = 'Enter your email and password.');
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await AuthService.instance.signInWithEmail(_email.text, _password.text);
      // AuthGate reacts to the auth state change.
    } on AuthFailure catch (e) {
      if (mounted) setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _google() async {
    setState(() {
      _googleLoading = true;
      _error = null;
    });
    try {
      await AuthService.instance.signInWithGoogle();
    } on AuthFailure catch (e) {
      if (mounted) setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _googleLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPalette.gray10,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const KitAuthHeader(title: 'Sign In'),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 32, 16, 24),
              child: AutofillGroup(
                child: Column(
                  children: [
                    KitTextField(
                      label: 'Email Address',
                      hint: 'Enter your email address...',
                      icon: Icons.mail_outline_rounded,
                      controller: _email,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      autofillHints: const [AutofillHints.email],
                    ),
                    const SizedBox(height: 24),
                    KitTextField(
                      label: 'Password',
                      hint: 'Enter your password...',
                      icon: Icons.lock_outline_rounded,
                      controller: _password,
                      obscure: true,
                      hasError: _error != null && _password.text.isNotEmpty,
                      textInputAction: TextInputAction.done,
                      autofillHints: const [AutofillHints.password],
                      onSubmitted: (_) => _signIn(),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => ForgotPasswordPage(
                              initialEmail: _email.text,
                            ),
                          ),
                        ),
                        child: const Text('Forgot Password?'),
                      ),
                    ),
                    if (_error != null) ...[
                      KitAlert(message: _error!),
                      const SizedBox(height: 16),
                    ] else
                      const SizedBox(height: 8),
                    KitButton(
                      label: 'Sign In',
                      loading: _loading,
                      onPressed: _signIn,
                      trailing: const KitPlusIcon(),
                    ),
                    const SizedBox(height: 32),
                    const _OrDivider(),
                    const SizedBox(height: 32),
                    _GoogleButton(loading: _googleLoading, onTap: _google),
                    const SizedBox(height: 32),
                    KitFooterLink(
                      prompt: 'Don’t have an account?',
                      action: 'Sign Up.',
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const SignUpPage()),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OrDivider extends StatelessWidget {
  const _OrDivider();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(child: Divider(color: AppPalette.gray30, height: 1)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Text('OR', style: AppText.labelXs),
        ),
        Expanded(child: Divider(color: AppPalette.gray30, height: 1)),
      ],
    );
  }
}

/// Social sign-in tile (56×56 outlined) — Google only.
class _GoogleButton extends StatelessWidget {
  final bool loading;
  final VoidCallback onTap;

  const _GoogleButton({required this.loading, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Continue with Google',
      child: Material(
        color: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AppPalette.gray40),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: loading ? null : onTap,
          child: SizedBox(
            width: 56,
            height: 56,
            child: Center(
              child: loading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2.4),
                    )
                  : Text(
                      'G',
                      style: AppText.textXlExtraBold.copyWith(
                        color: AppPalette.gray60,
                        fontSize: 22,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
