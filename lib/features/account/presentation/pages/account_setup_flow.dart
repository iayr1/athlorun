import 'dart:async';
import 'dart:convert';

import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../config/themes/app_theme.dart';
import '../../../../core/services/biometric_service.dart';
import '../../../../core/services/cloud_sync.dart';
import '../../../../core/widgets/kit.dart';
import '../../../../core/widgets/kit_avatar.dart';

/// "Profile Setup & Account Completion" flow from the kit: avatar, profile
/// details, password (for accounts without one), notifications, fingerprint
/// unlock and phone verification.
class AccountSetupFlow extends StatefulWidget {
  final User user;
  final AccountDetails? initial;
  final VoidCallback onFinished;

  /// Persists the answers; defaults to [CloudSync.saveAccount].
  final Future<void> Function(AccountDetails, String name)? onSave;

  const AccountSetupFlow({
    super.key,
    required this.user,
    required this.onFinished,
    this.initial,
    this.onSave,
  });

  @override
  State<AccountSetupFlow> createState() => _AccountSetupFlowState();
}

enum _Step {
  avatar,
  profile,
  password,
  notifications,
  fingerprint,
  phone,
  code
}

class _AccountSetupFlowState extends State<AccountSetupFlow> {
  late AccountDetails _details = widget.initial ??
      const AccountDetails(
        avatarId: 0,
        accountType: 'Regular',
        notifications: {
          _Notify.insights: true,
          _Notify.medication: false,
          _Notify.recommendations: true,
        },
      );
  late final _name = TextEditingController(
    text: widget.user.displayName ?? CloudSync.instance.profile?.name ?? '',
  );
  late final _email = TextEditingController(text: widget.user.email ?? '');
  late final _job = TextEditingController(text: _details.jobPosition ?? '');
  late Country _country = _initialCountry();
  late final _phone = TextEditingController(
    text: _stripDialCode(_details.phone, _country),
  );

  late final List<_Step> _steps = [
    _Step.avatar,
    _Step.profile,
    // Google-only accounts can add a password for email sign-in.
    if (!widget.user.providerData.any((p) => p.providerId == 'password') &&
        widget.user.email != null)
      _Step.password,
    _Step.notifications,
    if (!kIsWeb) _Step.fingerprint,
    _Step.phone,
    _Step.code,
  ];
  int _index = 0;
  bool _saving = false;

  _Step get _step => _steps[_index];

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _job.dispose();
    _phone.dispose();
    super.dispose();
  }

  Country _initialCountry() {
    final phone = _details.phone;
    if (phone != null && phone.startsWith('+')) {
      final service = CountryService();
      // Longest dial code first so "+1 868" beats "+1".
      final countries = service.getAll()
        ..sort((a, b) => b.phoneCode.length.compareTo(a.phoneCode.length));
      for (final c in countries) {
        if (phone.startsWith('+${c.phoneCode}')) return c;
      }
    }
    final code =
        WidgetsBinding.instance.platformDispatcher.locale.countryCode ?? 'US';
    return Country.tryParse(code) ?? Country.parse('US');
  }

  static String _stripDialCode(String? phone, Country country) {
    if (phone == null) return '';
    final prefix = '+${country.phoneCode}';
    return phone.startsWith(prefix) ? phone.substring(prefix.length) : phone;
  }

  String get _e164 =>
      '+${_country.phoneCode}${_phone.text.replaceAll(RegExp(r'[^0-9]'), '')}';

  void _back() {
    if (_index == 0) {
      Navigator.of(context).maybePop();
    } else {
      setState(() => _index--);
    }
  }

  void _goTo(_Step step) => setState(() => _index = _steps.indexOf(step));

  Future<void> _next() async {
    FocusScope.of(context).unfocus();
    if (_step == _Step.profile) {
      _details = _details.copyWith(
        jobPosition: _job.text.trim(),
        phone: _phone.text.trim().isEmpty ? null : _e164,
      );
    }
    // The phone/code steps verify and then call _finish themselves.
    setState(() => _index++);
  }

  Future<void> _finish() async {
    setState(() => _saving = true);
    try {
      final save = widget.onSave ??
          ((d, n) => CloudSync.instance.saveAccount(d, name: n));
      await save(_details, _name.text.trim());
      widget.onFinished();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not save your profile: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final page = switch (_step) {
      _Step.avatar => _AvatarStep(
          details: _details,
          onChanged: (d) => setState(() => _details = d),
          onBack: _back,
          onContinue: _next,
        ),
      _Step.profile => _ProfileStep(
          details: _details,
          name: _name,
          email: _email,
          emailEditable: widget.user.email == null,
          job: _job,
          phone: _phone,
          country: _country,
          onCountryChanged: (c) => setState(() => _country = c),
          onChanged: (d) => setState(() => _details = d),
          onEditAvatar: () => _goTo(_Step.avatar),
          onBack: _back,
          onContinue: _name.text.trim().isEmpty ? null : _next,
        ),
      _Step.password => _PasswordStep(
          user: widget.user,
          onBack: _back,
          onDone: _next,
        ),
      _Step.notifications => _NotificationStep(
          values: _details.notifications,
          onChanged: (v) =>
              setState(() => _details = _details.copyWith(notifications: v)),
          onBack: _back,
          onDone: _next,
        ),
      _Step.fingerprint => _FingerprintStep(onBack: _back, onDone: _next),
      _Step.phone || _Step.code => _PhoneVerification(
          user: widget.user,
          country: _country,
          phone: _phone,
          onCountryChanged: (c) => setState(() => _country = c),
          showCode: _step == _Step.code,
          onCodeSent: () => _goTo(_Step.code),
          onBack: _back,
          onVerified: () {
            _details = _details.copyWith(phone: _e164, phoneVerified: true);
            _finish();
          },
          onSkip: _finish,
          busy: _saving,
        ),
    };
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      child: KeyedSubtree(key: ValueKey(_step), child: page),
    );
  }
}

/// Notification preference keys stored in [AccountDetails.notifications].
abstract final class _Notify {
  static const insights = 'healthInsights';
  static const medication = 'medicationReminder';
  static const recommendations = 'recommendations';
}

// ---------------------------------------------------------------------------
// Shared layout
// ---------------------------------------------------------------------------

/// Back button and title row used across the flow.
class _TopBar extends StatelessWidget {
  final String? title;
  final VoidCallback onBack;
  final bool dark;

  const _TopBar({required this.onBack, this.title, this.dark = false});

  @override
  Widget build(BuildContext context) {
    final fg = dark ? Colors.white : AppPalette.gray80;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Row(
        children: [
          KitIconButton(
            icon: Icons.chevron_left_rounded,
            onPressed: onBack,
            tooltip: 'Back',
            borderColor: dark ? Colors.white54 : AppPalette.gray20,
            iconColor: fg,
          ),
          if (title != null) ...[
            const SizedBox(width: 16),
            Text(
              title!,
              style: AppText.textXlExtraBold.copyWith(color: fg),
            ),
          ],
        ],
      ),
    );
  }
}

class _StepScaffold extends StatelessWidget {
  final String? title;
  final VoidCallback onBack;
  final Widget child;
  final List<Widget> actions;

  const _StepScaffold({
    required this.onBack,
    required this.child,
    required this.actions,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPalette.gray10,
      body: SafeArea(
        child: Column(
          children: [
            _TopBar(title: title, onBack: onBack),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                child: child,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Column(
                children: [
                  for (final (i, a) in actions.indexed) ...[
                    if (i > 0) const SizedBox(height: 12),
                    a,
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Light-blue secondary button ("Skip thanks ✕", "Prefer to skip this").
class _SoftButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onTap;

  const _SoftButton({required this.label, required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: Material(
        color: AppPalette.blue10,
        borderRadius: BorderRadius.circular(12),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: AppText.textSmExtraBold.copyWith(
                  color: AppPalette.blue60,
                ),
              ),
              const SizedBox(width: 8),
              Icon(icon, size: 18, color: AppPalette.blue60),
            ],
          ),
        ),
      ),
    );
  }
}

/// Soft blob with icons scattered on it, standing in for kit illustrations.
class _Illustration extends StatelessWidget {
  final List<(Alignment, IconData, double, Color)> icons;

  static const height = 240.0;

  const _Illustration({required this.icons});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppPalette.gray20,
                borderRadius: BorderRadius.circular(height / 2),
              ),
            ),
          ),
          for (final (align, icon, size, color) in icons)
            Align(
              alignment: align,
              child: Icon(icon, size: size, color: color),
            ),
        ],
      ),
    );
  }
}

const _continueIcon = Icon(Icons.arrow_forward_rounded);

// ---------------------------------------------------------------------------
// Select Avatar
// ---------------------------------------------------------------------------

class _AvatarStep extends StatefulWidget {
  final AccountDetails details;
  final ValueChanged<AccountDetails> onChanged;
  final VoidCallback onBack;
  final VoidCallback onContinue;

  const _AvatarStep({
    required this.details,
    required this.onChanged,
    required this.onBack,
    required this.onContinue,
  });

  @override
  State<_AvatarStep> createState() => _AvatarStepState();
}

class _AvatarStepState extends State<_AvatarStep> {
  late final _pages = PageController(
    viewportFraction: 0.34,
    initialPage: widget.details.avatarId ?? 0,
  );
  bool _picking = false;

  @override
  void dispose() {
    _pages.dispose();
    super.dispose();
  }

  Future<void> _upload() async {
    setState(() => _picking = true);
    try {
      final file = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 256,
        maxHeight: 256,
        imageQuality: 75,
      );
      if (file == null) return;
      final bytes = await file.readAsBytes();
      if (bytes.length > 5 * 1024 * 1024) {
        throw 'The image is larger than 5 MB.';
      }
      widget
          .onChanged(widget.details.copyWith(avatarImage: base64Encode(bytes)));
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Couldn’t use that image: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _picking = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final selected = widget.details.avatarId ?? 0;
    final uploaded = widget.details.avatarImage;
    return _StepScaffold(
      title: 'Select Avatar',
      onBack: widget.onBack,
      actions: [
        KitButton(
          label: 'Continue',
          onPressed: widget.onContinue,
          trailing: _continueIcon,
        ),
      ],
      child: Column(
        children: [
          const Icon(Icons.arrow_drop_down_rounded,
              size: 40, color: AppPalette.blue60),
          SizedBox(
            height: 140,
            child: OverflowBox(
              maxWidth: MediaQuery.sizeOf(context).width,
              child: PageView.builder(
                controller: _pages,
                itemCount: KitAvatar.count,
                onPageChanged: (i) {
                  HapticFeedback.selectionClick();
                  widget.onChanged(widget.details.copyWith(
                    avatarId: i,
                    clearAvatarImage: true,
                  ));
                },
                itemBuilder: (context, i) {
                  final isSelected = uploaded == null && i == selected;
                  return GestureDetector(
                    onTap: () => _pages.animateToPage(
                      i,
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeOutCubic,
                    ),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      margin: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 4),
                      decoration: BoxDecoration(
                        color:
                            isSelected ? AppPalette.blue10 : AppPalette.gray20,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected
                              ? AppPalette.blue60
                              : Colors.transparent,
                          width: 2,
                        ),
                        boxShadow: isSelected
                            ? AppPalette.focusRing(AppPalette.blue60)
                            : null,
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Semantics(
                        label: 'Avatar ${i + 1}',
                        selected: isSelected,
                        child: KitAvatar(id: i, selected: isSelected),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text('Select Avatar 🙌', style: AppText.textXlExtraBold),
          const SizedBox(height: 8),
          const Text(
            'We have ${KitAvatar.count} premade avatars for your convenience. '
            'Kindly choose one of them!',
            textAlign: TextAlign.center,
            style: AppText.paragraphSm,
          ),
          const SizedBox(height: 32),
          GestureDetector(
            onTap: _picking ? null : _upload,
            child: CustomPaint(
              painter: const _DashedBorderPainter(),
              child: SizedBox.square(
                dimension: 80,
                child: uploaded != null
                    ? Stack(
                        fit: StackFit.expand,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(4),
                            child: KitProfilePicture(
                              imageBase64: uploaded,
                              size: 72,
                            ),
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: GestureDetector(
                              onTap: () => widget.onChanged(widget.details
                                  .copyWith(clearAvatarImage: true)),
                              child: const CircleAvatar(
                                radius: 11,
                                backgroundColor: AppPalette.gray80,
                                child: Icon(Icons.close_rounded,
                                    size: 14, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      )
                    : Center(
                        child: _picking
                            ? const SizedBox.square(
                                dimension: 22,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2.5),
                              )
                            : const Icon(Icons.file_upload_outlined,
                                color: AppPalette.gray80),
                      ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text('Or upload your image locally', style: AppText.textSmExtraBold),
          const SizedBox(height: 6),
          Text(
            'Max size: 5mb. Format: jpg, png',
            style: AppText.paragraphSm.copyWith(color: AppPalette.gray40),
          ),
        ],
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  const _DashedBorderPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppPalette.blue60
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Offset.zero & size,
        const Radius.circular(16),
      ));
    for (final metric in path.computeMetrics()) {
      for (var d = 0.0; d < metric.length; d += 8) {
        canvas.drawPath(metric.extractPath(d, d + 4), paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ---------------------------------------------------------------------------
// Profile Setup
// ---------------------------------------------------------------------------

class _ProfileStep extends StatelessWidget {
  final AccountDetails details;
  final TextEditingController name;
  final TextEditingController email;
  final bool emailEditable;
  final TextEditingController job;
  final TextEditingController phone;
  final Country country;
  final ValueChanged<Country> onCountryChanged;
  final ValueChanged<AccountDetails> onChanged;
  final VoidCallback onEditAvatar;
  final VoidCallback onBack;
  final VoidCallback? onContinue;

  const _ProfileStep({
    required this.details,
    required this.name,
    required this.email,
    required this.emailEditable,
    required this.job,
    required this.phone,
    required this.country,
    required this.onCountryChanged,
    required this.onChanged,
    required this.onEditAvatar,
    required this.onBack,
    required this.onContinue,
  });

  static const _accountTypes = ['Regular', 'Athlete', 'Coach'];

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;
    return Scaffold(
      backgroundColor: AppPalette.gray10,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: 168 + top + 44,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          height: 168 + top,
                          decoration: const BoxDecoration(
                            color: AppPalette.gray80,
                            borderRadius: BorderRadius.vertical(
                              bottom: Radius.circular(32),
                            ),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: const KitStrokeScatter(
                            color: Color(0x14FFFFFF),
                            strokes: [
                              KitStroke(Offset(120, 40), -30, 48),
                              KitStroke(Offset(300, 70), 60, 56),
                              KitStroke(Offset(40, 150), 150, 44),
                              KitStroke(Offset(230, 170), -100, 40),
                            ],
                          ),
                        ),
                        Positioned(
                          top: top,
                          left: 0,
                          right: 0,
                          child: _TopBar(
                            title: 'Profile Setup',
                            onBack: onBack,
                            dark: true,
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: GestureDetector(
                              onTap: onEditAvatar,
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    child: KitProfilePicture(
                                      avatarId: details.avatarId,
                                      imageBase64: details.avatarImage,
                                    ),
                                  ),
                                  Positioned(
                                    bottom: -10,
                                    left: 0,
                                    right: 0,
                                    child: Center(
                                      child: Container(
                                        padding: const EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                          color: AppPalette.gray80,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 2,
                                          ),
                                        ),
                                        child: const Icon(
                                          Icons.edit_square,
                                          size: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        KitTextField(
                          label: 'Full Name',
                          hint: 'Your name',
                          icon: Icons.person_outline_rounded,
                          controller: name,
                          textInputAction: TextInputAction.next,
                          autofillHints: const [AutofillHints.name],
                          onChanged: (_) => onChanged(details),
                        ),
                        const SizedBox(height: 16),
                        const _FieldLabel('Phone Number'),
                        _PhoneInput(
                          country: country,
                          controller: phone,
                          onCountryChanged: onCountryChanged,
                        ),
                        const SizedBox(height: 16),
                        const _FieldLabel('Location'),
                        _SelectField(
                          icon: Icons.location_on_outlined,
                          value: details.location,
                          hint: 'Select your country',
                          onTap: () => showCountryPicker(
                            context: context,
                            onSelect: (c) => onChanged(
                              details.copyWith(
                                location: '${c.flagEmoji} ${c.name}',
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        if (emailEditable)
                          KitTextField(
                            label: 'Email Address',
                            hint: 'you@example.com',
                            icon: Icons.mail_outline_rounded,
                            controller: email,
                            keyboardType: TextInputType.emailAddress,
                          )
                        else ...[
                          const _FieldLabel('Email Address'),
                          _SelectField(
                            icon: Icons.mail_outline_rounded,
                            value: email.text,
                            hint: '',
                            trailing: const Icon(
                              Icons.verified_rounded,
                              color: AppPalette.green,
                              size: 20,
                            ),
                          ),
                        ],
                        const SizedBox(height: 16),
                        KitTextField(
                          label: 'Job Position',
                          hint: 'e.g. Weekend runner',
                          icon: Icons.work_outline_rounded,
                          controller: job,
                          textInputAction: TextInputAction.done,
                        ),
                        const SizedBox(height: 16),
                        const _FieldLabel('Account Type'),
                        Row(
                          children: [
                            for (final (i, t) in _accountTypes.indexed) ...[
                              if (i > 0) const SizedBox(width: 8),
                              Expanded(
                                child: _ChoiceChip(
                                  label: t,
                                  selected: details.accountType == t,
                                  onTap: () => onChanged(
                                    details.copyWith(accountType: t),
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: KitButton(
                label: 'Continue',
                onPressed: onContinue,
                trailing: _continueIcon,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;

  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(text, style: AppText.textSmExtraBold),
      );
}

/// White field that opens a picker (or just shows a value).
class _SelectField extends StatelessWidget {
  final IconData icon;
  final String? value;
  final String hint;
  final VoidCallback? onTap;
  final Widget? trailing;

  const _SelectField({
    required this.icon,
    required this.value,
    required this.hint,
    this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final empty = value == null || value!.isEmpty;
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          child: Row(
            children: [
              Icon(icon, color: AppPalette.gray80),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  empty ? hint : value!,
                  style: AppText.textMdSemiBold.copyWith(
                    color: empty ? AppPalette.gray60 : AppPalette.gray80,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              trailing ??
                  (onTap == null
                      ? const SizedBox.shrink()
                      : const Icon(Icons.keyboard_arrow_down_rounded,
                          color: AppPalette.gray80)),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChoiceChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _ChoiceChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final fg = selected ? Colors.white : AppPalette.gray80;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        height: 48,
        decoration: BoxDecoration(
          color: selected ? AppPalette.blue60 : Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: selected ? AppPalette.focusRing(AppPalette.blue60) : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                label,
                style: AppText.textSmExtraBold.copyWith(color: fg),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 6),
            Icon(
              selected
                  ? Icons.radio_button_checked_rounded
                  : Icons.check_box_outline_blank_rounded,
              size: 16,
              color: fg,
            ),
          ],
        ),
      ),
    );
  }
}

/// Country dial code + number, with a focus ring like [KitTextField].
class _PhoneInput extends StatefulWidget {
  final Country country;
  final TextEditingController controller;
  final ValueChanged<Country> onCountryChanged;

  const _PhoneInput({
    required this.country,
    required this.controller,
    required this.onCountryChanged,
  });

  @override
  State<_PhoneInput> createState() => _PhoneInputState();
}

class _PhoneInputState extends State<_PhoneInput> {
  final _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    _focus.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final focused = _focus.hasFocus;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      padding: const EdgeInsets.only(left: 8, right: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: focused ? AppPalette.blue60 : Colors.white,
        ),
        boxShadow: focused ? AppPalette.focusRing(AppPalette.blue60) : null,
      ),
      child: Row(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () => showCountryPicker(
              context: context,
              showPhoneCode: true,
              onSelect: widget.onCountryChanged,
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                color: AppPalette.gray10,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Text(widget.country.flagEmoji,
                      style: const TextStyle(fontSize: 18)),
                  const Icon(Icons.keyboard_arrow_down_rounded,
                      size: 18, color: AppPalette.gray80),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text('(+${widget.country.phoneCode})', style: AppText.textMdSemiBold),
          const SizedBox(width: 4),
          Expanded(
            child: TextField(
              controller: widget.controller,
              focusNode: _focus,
              keyboardType: TextInputType.phone,
              autofillHints: const [AutofillHints.telephoneNumberNational],
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9 \-]')),
              ],
              cursorColor: AppPalette.blue60,
              style: AppText.textMdSemiBold,
              decoration: InputDecoration(
                hintText: '012 456 789',
                hintStyle:
                    AppText.textMdSemiBold.copyWith(color: AppPalette.gray40),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 18),
              ),
            ),
          ),
          const Icon(Icons.smartphone_rounded, color: AppPalette.gray40),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Password Setup
// ---------------------------------------------------------------------------

class _PasswordStep extends StatefulWidget {
  final User user;
  final VoidCallback onBack;
  final VoidCallback onDone;

  const _PasswordStep({
    required this.user,
    required this.onBack,
    required this.onDone,
  });

  @override
  State<_PasswordStep> createState() => _PasswordStepState();
}

class _PasswordStepState extends State<_PasswordStep> {
  static const _minLength = 10;

  final _password = TextEditingController();
  bool _saving = false;
  String? _error;

  @override
  void dispose() {
    _password.dispose();
    super.dispose();
  }

  /// 0–4: length, mixed case, digit, symbol.
  int get _strength {
    final p = _password.text;
    if (p.isEmpty) return 0;
    var s = 0;
    if (p.length >= _minLength) s++;
    if (p.contains(RegExp(r'[a-z]')) && p.contains(RegExp(r'[A-Z]'))) s++;
    if (p.contains(RegExp(r'[0-9]'))) s++;
    if (p.contains(RegExp(r'[^A-Za-z0-9]'))) s++;
    return s == 0 ? 1 : s;
  }

  Future<void> _save() async {
    if (_password.text.length < _minLength) return;
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await widget.user.linkWithCredential(EmailAuthProvider.credential(
        email: widget.user.email!,
        password: _password.text,
      ));
      widget.onDone();
    } on FirebaseAuthException catch (e) {
      setState(() => _error = switch (e.code) {
            'provider-already-linked' => null,
            'weak-password' => 'That password is too weak.',
            'requires-recent-login' =>
              'Please sign in again to add a password.',
            _ => e.message ?? 'Couldn’t save the password.',
          });
      if (e.code == 'provider-already-linked') widget.onDone();
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final strength = _strength;
    final short =
        _password.text.isNotEmpty && _password.text.length < _minLength;
    const labels = ['', 'Weak', 'Fair', 'Good', 'Great!'];
    return Scaffold(
      backgroundColor: AppPalette.gray10,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _TopBar(onBack: widget.onBack),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('Password Setup', style: AppText.headingSm),
                    const SizedBox(height: 8),
                    Text(
                      'Add a password so you can also sign in with '
                      '${widget.user.email}.',
                      style: AppText.paragraphSm,
                    ),
                    const SizedBox(height: 24),
                    _PasswordInput(
                      controller: _password,
                      hasError: short,
                      onChanged: (_) => setState(() => _error = null),
                      onSubmitted: (_) => _save(),
                    ),
                    const SizedBox(height: 16),
                    Text.rich(
                      TextSpan(
                        text: 'Password Strength: ',
                        style: AppText.paragraphSm,
                        children: [
                          TextSpan(
                            text: labels[strength],
                            style: AppText.textSmExtraBold,
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        for (var i = 0; i < 4; i++) ...[
                          if (i > 0) const SizedBox(width: 6),
                          Expanded(
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 180),
                              height: 6,
                              decoration: BoxDecoration(
                                color: i < strength
                                    ? (strength <= 1
                                        ? AppPalette.red50
                                        : AppPalette.blue60)
                                    : AppPalette.blue20,
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    if (short || _error != null) ...[
                      const SizedBox(height: 16),
                      KitAlert(
                        message: _error ??
                            'Needs to be $_minLength character minimum!',
                      ),
                    ],
                    const SizedBox(height: 16),
                    KitButton(
                      label: 'Continue',
                      loading: _saving,
                      onPressed:
                          _password.text.length >= _minLength ? _save : null,
                      trailing: _continueIcon,
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: _saving ? null : widget.onDone,
                      child: Text(
                        'Skip for now',
                        style: AppText.textSmSemiBold
                            .copyWith(color: AppPalette.gray60),
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

class _PasswordInput extends StatefulWidget {
  final TextEditingController controller;
  final bool hasError;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;

  const _PasswordInput({
    required this.controller,
    required this.hasError,
    required this.onChanged,
    required this.onSubmitted,
  });

  @override
  State<_PasswordInput> createState() => _PasswordInputState();
}

class _PasswordInputState extends State<_PasswordInput> {
  bool _hidden = true;

  @override
  Widget build(BuildContext context) {
    final ring = widget.hasError ? AppPalette.red50 : AppPalette.blue60;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ring, width: 1.5),
        boxShadow: AppPalette.focusRing(ring),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: widget.controller,
              autofocus: true,
              obscureText: _hidden,
              obscuringCharacter: '*',
              autofillHints: const [AutofillHints.newPassword],
              onChanged: widget.onChanged,
              onSubmitted: widget.onSubmitted,
              cursorColor: AppPalette.blue60,
              style: AppText.textXlExtraBold.copyWith(letterSpacing: 4),
              decoration: InputDecoration(
                hintText: 'Password',
                hintStyle: AppText.textMdSemiBold.copyWith(
                  color: AppPalette.gray40,
                  letterSpacing: 0,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 18),
              ),
            ),
          ),
          IconButton(
            tooltip: _hidden ? 'Show password' : 'Hide password',
            onPressed: () => setState(() => _hidden = !_hidden),
            icon: Icon(
              _hidden
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              color: AppPalette.gray30,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Notification Setup
// ---------------------------------------------------------------------------

class _NotificationStep extends StatefulWidget {
  final Map<String, bool> values;
  final ValueChanged<Map<String, bool>> onChanged;
  final VoidCallback onBack;
  final VoidCallback onDone;

  const _NotificationStep({
    required this.values,
    required this.onChanged,
    required this.onBack,
    required this.onDone,
  });

  @override
  State<_NotificationStep> createState() => _NotificationStepState();
}

class _NotificationStepState extends State<_NotificationStep> {
  static const _rows = [
    (
      _Notify.insights,
      'Health Insights',
      Icons.mail_rounded,
      AppPalette.blue60
    ),
    (
      _Notify.medication,
      'Medication Reminder',
      Icons.notifications_rounded,
      AppPalette.cyan,
    ),
    (
      _Notify.recommendations,
      'AI Recommendation',
      Icons.folder_special_rounded,
      AppPalette.purple60,
    ),
  ];

  bool _asking = false;

  /// Saves [values] and, if any are on, asks the OS for permission.
  Future<void> _apply(Map<String, bool> values) async {
    widget.onChanged(values);
    if (values.values.any((v) => v) && !kIsWeb) {
      setState(() => _asking = true);
      try {
        await Permission.notification.request();
      } catch (_) {
        // Not supported on this platform; preferences are still saved.
      } finally {
        if (mounted) setState(() => _asking = false);
      }
    }
    widget.onDone();
  }

  @override
  Widget build(BuildContext context) {
    final allOn = _rows.every((r) => widget.values[r.$1] ?? false);
    return _StepScaffold(
      onBack: widget.onBack,
      actions: [
        KitButton(
          label: 'Allow All',
          loading: _asking,
          onPressed: () => _apply({for (final r in _rows) r.$1: true}),
          trailing: const Icon(Icons.check_rounded),
        ),
        if (!allOn)
          TextButton(
            onPressed: _asking ? null : () => _apply(widget.values),
            child: Text(
              'Save my choices',
              style: AppText.textSmSemiBold.copyWith(color: AppPalette.gray60),
            ),
          ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _Illustration(
            icons: [
              (
                Alignment(0, 0),
                Icons.phone_iphone_rounded,
                150,
                AppPalette.gray80
              ),
              (
                Alignment(0.55, -0.45),
                Icons.notifications_active_rounded,
                56,
                AppPalette.blue60
              ),
              (Alignment(-0.6, 0.5), Icons.eco_rounded, 48, AppPalette.gray50),
              (
                Alignment(0.7, 0.6),
                Icons.auto_awesome_rounded,
                24,
                AppPalette.gray50
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text('Notification Setup', style: AppText.headingSm),
          const SizedBox(height: 16),
          for (final (key, label, icon, color) in _rows)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(icon, size: 20, color: color),
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: Text(label, style: AppText.textMdBold)),
                  Switch(
                    value: widget.values[key] ?? false,
                    activeThumbColor: Colors.white,
                    activeTrackColor: AppPalette.blue60,
                    inactiveThumbColor: Colors.white,
                    inactiveTrackColor: AppPalette.gray20,
                    trackOutlineColor:
                        const WidgetStatePropertyAll(Colors.transparent),
                    onChanged: (v) =>
                        widget.onChanged({...widget.values, key: v}),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Fingerprint Setup
// ---------------------------------------------------------------------------

class _FingerprintStep extends StatefulWidget {
  final VoidCallback onBack;
  final VoidCallback onDone;

  const _FingerprintStep({required this.onBack, required this.onDone});

  @override
  State<_FingerprintStep> createState() => _FingerprintStepState();
}

enum _BioState { checking, unavailable, ready, scanning, enabled }

class _FingerprintStepState extends State<_FingerprintStep>
    with SingleTickerProviderStateMixin {
  late final AnimationController _scan = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1600),
  )..repeat(reverse: true);

  _BioState _state = _BioState.checking;
  String? _error;

  @override
  void initState() {
    super.initState();
    _check();
  }

  Future<void> _check() async {
    final service = BiometricService.instance;
    final available = await service.isAvailable();
    final enabled = available && await service.isEnabled();
    if (!mounted) return;
    setState(() => _state = !available
        ? _BioState.unavailable
        : enabled
            ? _BioState.enabled
            : _BioState.ready);
  }

  @override
  void dispose() {
    _scan.dispose();
    super.dispose();
  }

  Future<void> _enroll() async {
    setState(() {
      _state = _BioState.scanning;
      _error = null;
    });
    try {
      final ok = await BiometricService.instance
          .authenticate('Confirm your fingerprint to secure athlorun');
      if (ok) {
        await BiometricService.instance.setEnabled(true);
        HapticFeedback.mediumImpact();
      }
      if (mounted) {
        setState(() => _state = ok ? _BioState.enabled : _BioState.ready);
      }
    } on PlatformException catch (e) {
      if (mounted) {
        setState(() {
          _state = _BioState.ready;
          _error = e.message ?? 'Fingerprint scan failed.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final status = switch (_state) {
      _BioState.checking => 'Checking your device…',
      _BioState.unavailable => 'No fingerprint set up on this device',
      _BioState.ready => _error ?? 'Tap Continue, then touch the sensor',
      _BioState.scanning => 'Touch the sensor…',
      _BioState.enabled => 'Fingerprint unlock is on',
    };
    final canEnroll = _state == _BioState.ready;
    return _StepScaffold(
      title: 'Fingerprint Setup',
      onBack: widget.onBack,
      actions: [
        if (_state != _BioState.enabled)
          _SoftButton(
            label: 'Skip thanks',
            icon: Icons.close_rounded,
            onTap: widget.onDone,
          ),
        KitButton(
          label: 'Continue',
          loading: _state == _BioState.scanning,
          onPressed: canEnroll
              ? _enroll
              : (_state == _BioState.checking ? null : widget.onDone),
          trailing: _continueIcon,
        ),
      ],
      child: Column(
        children: [
          SizedBox(
            height: 260,
            width: 260,
            child: Stack(
              children: [
                const Positioned.fill(
                  child: CustomPaint(painter: _CornerFramePainter()),
                ),
                Center(
                  child: AnimatedBuilder(
                    animation: _scan,
                    builder: (_, __) {
                      final y = _state == _BioState.enabled ? 1.0 : _scan.value;
                      return ShaderMask(
                        blendMode: BlendMode.srcIn,
                        shaderCallback: (rect) => LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: const [
                            AppPalette.blue60,
                            AppPalette.blue60,
                            AppPalette.gray80,
                          ],
                          stops: [0, y, y],
                        ).createShader(rect),
                        child: const Icon(Icons.fingerprint_rounded, size: 200),
                      );
                    },
                  ),
                ),
                if (_state != _BioState.enabled)
                  AnimatedBuilder(
                    animation: _scan,
                    builder: (_, __) => Positioned(
                      left: 16,
                      right: 16,
                      top: 30 + _scan.value * 200,
                      child: Container(height: 4, color: AppPalette.blue60),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text('Scan Your Fingerprint 👆', style: AppText.textXlExtraBold),
          const SizedBox(height: 8),
          const Text(
            'Scan your biometric fingerprint to make your account more '
            'secure. You’ll use it to unlock athlorun.',
            textAlign: TextAlign.center,
            style: AppText.paragraphSm,
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _state == _BioState.enabled
                  ? AppPalette.green.withValues(alpha: 0.12)
                  : AppPalette.gray20,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              status,
              style: AppText.labelXs.copyWith(
                letterSpacing: 0,
                fontSize: 12,
                color: _state == _BioState.enabled
                    ? AppPalette.green
                    : AppPalette.gray60,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CornerFramePainter extends CustomPainter {
  const _CornerFramePainter();

  @override
  void paint(Canvas canvas, Size size) {
    const len = 44.0;
    final paint = Paint()
      ..color = AppPalette.gray80
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.square;
    final w = size.width;
    final h = size.height;
    for (final (a, b, c) in [
      (const Offset(0, len), Offset.zero, const Offset(len, 0)),
      (Offset(w - len, 0), Offset(w, 0), Offset(w, len)),
      (Offset(w, h - len), Offset(w, h), Offset(w - len, h)),
      (Offset(len, h), Offset(0, h), Offset(0, h - len)),
    ]) {
      canvas.drawPath(
        Path()
          ..moveTo(a.dx, a.dy)
          ..lineTo(b.dx, b.dy)
          ..lineTo(c.dx, c.dy),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ---------------------------------------------------------------------------
// OTP Setup / OTP Security
// ---------------------------------------------------------------------------

/// Phone number entry and the SMS code, verified with Firebase phone auth
/// and linked to the signed-in account.
class _PhoneVerification extends StatefulWidget {
  final User user;
  final Country country;
  final TextEditingController phone;
  final ValueChanged<Country> onCountryChanged;
  final bool showCode;
  final VoidCallback onCodeSent;
  final VoidCallback onBack;
  final VoidCallback onVerified;
  final VoidCallback onSkip;
  final bool busy;

  const _PhoneVerification({
    required this.user,
    required this.country,
    required this.phone,
    required this.onCountryChanged,
    required this.showCode,
    required this.onCodeSent,
    required this.onBack,
    required this.onVerified,
    required this.onSkip,
    required this.busy,
  });

  @override
  State<_PhoneVerification> createState() => _PhoneVerificationState();
}

class _PhoneVerificationState extends State<_PhoneVerification> {
  static const _codeLength = 6;
  static const _resendAfter = 30;

  // Kept across the phone → code step switch.
  static String? _verificationId;
  static int? _resendToken;
  static ConfirmationResult? _webConfirmation;

  final _code = TextEditingController();
  final _codeFocus = FocusNode();
  bool _sending = false;
  bool _verifying = false;
  String? _error;
  int _resendIn = 0;
  Timer? _ticker;

  String get _e164 => '+${widget.country.phoneCode}'
      '${widget.phone.text.replaceAll(RegExp(r'[^0-9]'), '')}';

  @override
  void initState() {
    super.initState();
    if (widget.showCode) _startResendTimer();
  }

  @override
  void dispose() {
    _ticker?.cancel();
    _code.dispose();
    _codeFocus.dispose();
    super.dispose();
  }

  void _startResendTimer() {
    _ticker?.cancel();
    setState(() => _resendIn = _resendAfter);
    _ticker = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return t.cancel();
      setState(() => _resendIn--);
      if (_resendIn <= 0) t.cancel();
    });
  }

  String _message(FirebaseAuthException e) => switch (e.code) {
        'invalid-phone-number' => 'That phone number doesn’t look right.',
        'invalid-verification-code' => 'That code is incorrect.',
        'session-expired' ||
        'code-expired' =>
          'The code expired. Tap Resend for a new one.',
        'credential-already-in-use' ||
        'account-exists-with-different-credential' =>
          'This number is already linked to another account.',
        'too-many-requests' => 'Too many attempts. Please try again later.',
        'operation-not-allowed' =>
          'Phone sign-in isn’t enabled for this app yet.',
        _ => e.message ?? 'Phone verification failed (${e.code}).',
      };

  Future<void> _send({bool resend = false}) async {
    if (widget.phone.text.replaceAll(RegExp(r'[^0-9]'), '').length < 6) {
      setState(() => _error = 'Enter your phone number.');
      return;
    }
    setState(() {
      _sending = true;
      _error = null;
    });
    try {
      if (kIsWeb) {
        _webConfirmation = await widget.user.linkWithPhoneNumber(_e164);
        _afterSent();
        return;
      }
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: _e164,
        forceResendingToken: resend ? _resendToken : null,
        // Android can verify without the user typing the code.
        verificationCompleted: _link,
        verificationFailed: (e) {
          if (mounted) {
            setState(() {
              _sending = false;
              _error = _message(e);
            });
          }
        },
        codeSent: (id, token) {
          _verificationId = id;
          _resendToken = token;
          _afterSent();
        },
        codeAutoRetrievalTimeout: (id) => _verificationId = id,
      );
    } on FirebaseAuthException catch (e) {
      if (mounted) setState(() => _error = _message(e));
    } finally {
      if (mounted && kIsWeb) setState(() => _sending = false);
    }
  }

  void _afterSent() {
    if (!mounted) return;
    setState(() => _sending = false);
    _code.clear();
    if (widget.showCode) {
      _startResendTimer();
    } else {
      widget.onCodeSent();
    }
  }

  Future<void> _verify() async {
    if (_code.text.length != _codeLength) return;
    setState(() {
      _verifying = true;
      _error = null;
    });
    try {
      if (kIsWeb) {
        await _webConfirmation!.confirm(_code.text);
        widget.onVerified();
        return;
      }
      await _link(PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: _code.text,
      ));
    } on FirebaseAuthException catch (e) {
      if (mounted) setState(() => _error = _message(e));
    } finally {
      if (mounted) setState(() => _verifying = false);
    }
  }

  Future<void> _link(PhoneAuthCredential credential) async {
    try {
      await widget.user.linkWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      // Already has a phone: replace it instead.
      if (e.code == 'provider-already-linked') {
        await widget.user.updatePhoneNumber(credential);
      } else {
        if (mounted) {
          setState(() {
            _sending = false;
            _error = _message(e);
          });
        }
        return;
      }
    }
    if (mounted) widget.onVerified();
  }

  @override
  Widget build(BuildContext context) {
    return widget.showCode ? _buildCode() : _buildPhone();
  }

  Widget _skip() => TextButton(
        onPressed: widget.busy ? null : widget.onSkip,
        child: Text(
          'Skip for now',
          style: AppText.textSmSemiBold.copyWith(color: AppPalette.gray60),
        ),
      );

  Widget _buildPhone() {
    return Scaffold(
      backgroundColor: AppPalette.gray10,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _TopBar(title: 'OTP Setup', onBack: widget.onBack),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const _Illustration(
                      icons: [
                        (
                          Alignment(-0.3, 0.1),
                          Icons.face_3_rounded,
                          150,
                          AppPalette.red50
                        ),
                        (
                          Alignment(0.45, -0.3),
                          Icons.key_rounded,
                          72,
                          AppPalette.purple60
                        ),
                        (
                          Alignment(0.75, -0.75),
                          Icons.auto_awesome_rounded,
                          24,
                          AppPalette.gray50
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    const Text(
                      'We will send a one time SMS message.\n'
                      'Carrier rates may apply.',
                      textAlign: TextAlign.center,
                      style: AppText.paragraphSm,
                    ),
                    const SizedBox(height: 24),
                    _PhoneInput(
                      country: widget.country,
                      controller: widget.phone,
                      onCountryChanged: widget.onCountryChanged,
                    ),
                    if (_error != null) ...[
                      const SizedBox(height: 12),
                      KitAlert(message: _error!),
                    ],
                    const SizedBox(height: 16),
                    KitButton(
                      label: 'Continue',
                      loading: _sending || widget.busy,
                      onPressed: _send,
                      trailing: _continueIcon,
                    ),
                    const SizedBox(height: 8),
                    _skip(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCode() {
    final digits = _code.text;
    return Scaffold(
      backgroundColor: AppPalette.gray10,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _TopBar(title: 'OTP Security', onBack: widget.onBack),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Please enter the $_codeLength digit code we sent to\n'
                      '$_e164 🙏',
                      textAlign: TextAlign.center,
                      style: AppText.paragraphSm,
                    ),
                    const SizedBox(height: 32),
                    GestureDetector(
                      onTap: _codeFocus.requestFocus,
                      child: Stack(
                        children: [
                          // Invisible field that drives the boxes.
                          Opacity(
                            opacity: 0,
                            child: TextField(
                              controller: _code,
                              focusNode: _codeFocus,
                              autofocus: true,
                              keyboardType: TextInputType.number,
                              autofillHints: const [AutofillHints.oneTimeCode],
                              maxLength: _codeLength,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              onChanged: (v) {
                                setState(() => _error = null);
                                if (v.length == _codeLength) _verify();
                              },
                            ),
                          ),
                          Row(
                            children: [
                              for (var i = 0; i < _codeLength; i++) ...[
                                if (i > 0) const SizedBox(width: 8),
                                Expanded(
                                  child: _CodeBox(
                                    digit: i < digits.length ? digits[i] : null,
                                    active: i == digits.length - 1 ||
                                        (digits.isEmpty && i == 0),
                                    error: _error != null,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    if (_error != null) ...[
                      KitAlert(message: _error!),
                      const SizedBox(height: 16),
                    ],
                    Center(
                      child: Text.rich(
                        TextSpan(
                          text: 'Didn’t see any OTP code? ',
                          style: AppText.paragraphSm,
                          children: [
                            WidgetSpan(
                              alignment: PlaceholderAlignment.baseline,
                              baseline: TextBaseline.alphabetic,
                              child: GestureDetector(
                                onTap: _resendIn > 0 || _sending
                                    ? null
                                    : () => _send(resend: true),
                                child: Text(
                                  _resendIn > 0
                                      ? 'Resend in ${_resendIn}s'
                                      : 'Resend.',
                                  style: AppText.textSmSemiBold.copyWith(
                                    color: _resendIn > 0
                                        ? AppPalette.gray40
                                        : AppPalette.red50,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    KitButton(
                      label: 'Continue',
                      loading: _verifying || widget.busy,
                      onPressed: digits.length == _codeLength ? _verify : null,
                      trailing: _continueIcon,
                    ),
                    const SizedBox(height: 8),
                    _skip(),
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

class _CodeBox extends StatelessWidget {
  final String? digit;
  final bool active;
  final bool error;

  const _CodeBox({
    required this.digit,
    required this.active,
    required this.error,
  });

  @override
  Widget build(BuildContext context) {
    final filledActive = active && digit != null;
    final ring = error ? AppPalette.red50 : AppPalette.blue60;
    return AspectRatio(
      aspectRatio: 0.85,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: filledActive ? ring : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: active ? ring : Colors.white,
            width: 1.5,
          ),
          boxShadow:
              active ? AppPalette.focusRing(ring) : AppPalette.softShadow(),
        ),
        child: Text(
          digit ?? '0',
          style: AppText.headingSm.copyWith(
            color: filledActive
                ? Colors.white
                : digit == null
                    ? AppPalette.gray20
                    : AppPalette.gray80,
          ),
        ),
      ),
    );
  }
}
