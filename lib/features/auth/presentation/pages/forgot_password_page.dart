import 'package:flutter/material.dart';

import '../../../../config/themes/app_theme.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/widgets/kit.dart';

/// "Forgot Password" flow from the kit. Firebase sends a reset link by email.
class ForgotPasswordPage extends StatefulWidget {
  final String initialEmail;

  const ForgotPasswordPage({super.key, this.initialEmail = ''});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  late final _email = TextEditingController(text: widget.initialEmail);
  String? _error;
  bool _loading = false;

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    FocusScope.of(context).unfocus();
    if (!_email.text.contains('@')) {
      setState(() => _error = 'Enter the email address of your account.');
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await AuthService.instance.sendPasswordReset(_email.text);
      if (mounted) await _showSent();
    } on AuthFailure catch (e) {
      if (mounted) setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _showSent() {
    return showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Close',
      barrierColor: AppPalette.gray80.withValues(alpha: 0.75),
      pageBuilder: (context, _, __) => _SentDialog(
        email: _mask(_email.text.trim()),
        onResend: () {
          Navigator.pop(context);
          _send();
        },
      ),
    );
  }

  static String _mask(String email) {
    final at = email.indexOf('@');
    if (at <= 4) return email;
    return '${email.substring(0, 4)}${'*' * (at - 4)}${email.substring(at)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPalette.gray10,
      body: SingleChildScrollView(
        child: Column(
          children: [
            KitAuthHeader(
              title: 'Forgot Password?',
              subtitle: 'Then let’s submit password reset.',
              onBack: () => Navigator.of(context).maybePop(),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
              child: Column(
                children: [
                  const KitActionCard(
                    icon: Icons.mail_outline_rounded,
                    title: 'Send via Email',
                    subtitle: 'We’ll email you a secure reset link.',
                    selected: true,
                  ),
                  const SizedBox(height: 24),
                  KitTextField(
                    label: 'Email Address',
                    hint: 'Enter your email address...',
                    icon: Icons.mail_outline_rounded,
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.done,
                    autofillHints: const [AutofillHints.email],
                    onSubmitted: (_) => _send(),
                  ),
                  if (_error != null) ...[
                    const SizedBox(height: 12),
                    KitAlert(message: _error!),
                  ],
                  const SizedBox(height: 24),
                  KitButton(
                    label: 'Reset Password',
                    loading: _loading,
                    onPressed: _send,
                    trailing: const Icon(Icons.lock_outline_rounded),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SentDialog extends StatelessWidget {
  final String email;
  final VoidCallback onResend;

  const _SentDialog({required this.email, required this.onResend});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          const Spacer(),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Material(
              color: Colors.transparent,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      color: AppPalette.gray10,
                      height: 220,
                      width: double.infinity,
                      child: Image.asset(
                        'assets/onboarding/password_sent.png',
                        fit: BoxFit.cover,
                        alignment: Alignment.topLeft,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text('Reset Link Sent!', style: AppText.headingSm),
                  const SizedBox(height: 8),
                  Text(
                    'We’ve sent a password reset link to $email',
                    style: AppText.paragraphMd,
                  ),
                  const SizedBox(height: 24),
                  KitButton(
                    label: 'Re-Send Link',
                    onPressed: onResend,
                    trailing: const KitPlusIcon(),
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
          Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () => Navigator.pop(context),
              child: const SizedBox(
                width: 64,
                height: 64,
                child: Icon(Icons.close_rounded, color: AppPalette.gray80),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
