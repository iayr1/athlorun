import 'package:flutter/material.dart';

import '../../../../config/themes/app_theme.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/widgets/kit.dart';

/// "Sign Up" screen from the kit, backed by Firebase Auth.
class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  String? _error;
  bool _mismatch = false;
  bool _loading = false;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    FocusScope.of(context).unfocus();
    final mismatch = _password.text != _confirm.text;
    setState(() {
      _mismatch = mismatch;
      _error = mismatch ? 'ERROR: Password do not match!' : null;
    });
    if (mismatch) return;
    if (_name.text.trim().isEmpty || !_email.text.contains('@')) {
      setState(() => _error = 'Enter your name and a valid email address.');
      return;
    }
    setState(() => _loading = true);
    try {
      await AuthService.instance.signUpWithEmail(
        _email.text,
        _password.text,
        displayName: _name.text,
      );
      // AuthGate takes over; close this page if it is on top.
      if (mounted) Navigator.of(context).popUntil((r) => r.isFirst);
    } on AuthFailure catch (e) {
      if (mounted) setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPalette.gray10,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const KitAuthHeader(title: 'Sign Up For Free!'),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 32, 16, 24),
              child: AutofillGroup(
                child: Column(
                  children: [
                    KitTextField(
                      label: 'Full Name',
                      hint: 'Enter your name...',
                      icon: Icons.person_outline_rounded,
                      controller: _name,
                      textInputAction: TextInputAction.next,
                      autofillHints: const [AutofillHints.name],
                    ),
                    const SizedBox(height: 16),
                    KitTextField(
                      label: 'Email Address',
                      hint: 'Enter your email address...',
                      icon: Icons.mail_outline_rounded,
                      controller: _email,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      autofillHints: const [AutofillHints.email],
                    ),
                    const SizedBox(height: 16),
                    KitTextField(
                      label: 'Password',
                      hint: 'At least 6 characters...',
                      icon: Icons.lock_outline_rounded,
                      controller: _password,
                      obscure: true,
                      textInputAction: TextInputAction.next,
                      autofillHints: const [AutofillHints.newPassword],
                    ),
                    const SizedBox(height: 16),
                    KitTextField(
                      label: 'Password Confirmation',
                      hint: 'Repeat your password...',
                      icon: Icons.lock_outline_rounded,
                      controller: _confirm,
                      obscure: true,
                      hasError: _mismatch,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => _signUp(),
                    ),
                    if (_error != null) ...[
                      const SizedBox(height: 12),
                      KitAlert(message: _error!),
                    ],
                    const SizedBox(height: 24),
                    KitButton(
                      label: 'Sign Up',
                      loading: _loading,
                      onPressed: _signUp,
                      trailing: const KitPlusIcon(),
                    ),
                    const SizedBox(height: 32),
                    KitFooterLink(
                      prompt: 'Already have an account?',
                      action: 'Sign In.',
                      onTap: () => Navigator.of(context).maybePop(),
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
