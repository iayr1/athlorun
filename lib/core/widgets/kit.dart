import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../config/themes/app_theme.dart';

/// Components from the asklepios UI Kit.

/// Logo mark exported from the kit ("Monotone health plus").
class KitLogoMark extends StatelessWidget {
  final double size;

  const KitLogoMark({super.key, this.size = 72});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/brand/logo_mark.svg',
      width: size,
      height: size,
    );
  }
}

/// The kit's "plus" glyph: two offset rounded strokes.
class KitPlusIcon extends StatelessWidget {
  final double size;
  final Color color;

  const KitPlusIcon({super.key, this.size = 24, this.color = Colors.white});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.square(size),
      painter: _PlusPainter(color),
    );
  }
}

class _PlusPainter extends CustomPainter {
  final Color color;

  _PlusPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    // Geometry from the logo SVG (72px box, glyph spans 18..54).
    final s = size.width / 36;
    canvas.translate(-18 * s, -18 * s);
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.5 * s;
    final a = Path()
      ..moveTo(18 * s, 36 * s)
      ..lineTo(29.25 * s, 36 * s)
      ..cubicTo(32.98 * s, 36 * s, 36 * s, 39.02 * s, 36 * s, 42.75 * s)
      ..lineTo(36 * s, 54 * s);
    final b = Path()
      ..moveTo(54 * s, 36 * s)
      ..lineTo(42.75 * s, 36 * s)
      ..cubicTo(39.02 * s, 36 * s, 36 * s, 32.98 * s, 36 * s, 29.25 * s)
      ..lineTo(36 * s, 18 * s);
    canvas.drawPath(a, paint);
    canvas.drawPath(b, paint);
  }

  @override
  bool shouldRepaint(covariant _PlusPainter old) => old.color != color;
}

/// Primary 56px button with label and trailing icon.
class KitButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final Widget? trailing;
  final bool loading;
  final Color background;
  final Color foreground;

  const KitButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.trailing,
    this.loading = false,
    this.background = AppPalette.blue60,
    this.foreground = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null && !loading;
    return SizedBox(
      height: 56,
      width: double.infinity,
      child: Material(
        color: enabled ? background : background.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: enabled ? onPressed : null,
          child: Center(
            child: loading
                ? SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: foreground,
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        label,
                        style: AppText.textMdBold.copyWith(color: foreground),
                      ),
                      if (trailing != null) ...[
                        const SizedBox(width: 12),
                        IconTheme(
                          data: IconThemeData(color: foreground, size: 24),
                          child: trailing!,
                        ),
                      ],
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

/// Square outlined icon button ("Button Icon FAB" outline variant).
class KitIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final Color borderColor;
  final Color iconColor;
  final double size;
  final String? tooltip;

  const KitIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.borderColor = AppPalette.gray40,
    this.iconColor = AppPalette.gray80,
    this.size = 48,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final button = Material(
      color: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: borderColor),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPressed,
        child: SizedBox(
          width: size,
          height: size,
          child: Icon(icon, color: iconColor, size: 24),
        ),
      ),
    );
    return tooltip == null ? button : Tooltip(message: tooltip!, child: button);
  }
}

/// Labelled input ("Input Text") with focus/error rings.
class KitTextField extends StatefulWidget {
  final String label;
  final String hint;
  final IconData icon;
  final TextEditingController controller;
  final bool obscure;
  final bool hasError;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;
  final ValueChanged<String>? onSubmitted;
  final ValueChanged<String>? onChanged;

  const KitTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.icon,
    required this.controller,
    this.obscure = false,
    this.hasError = false,
    this.keyboardType,
    this.textInputAction,
    this.autofillHints,
    this.onSubmitted,
    this.onChanged,
  });

  @override
  State<KitTextField> createState() => _KitTextFieldState();
}

class _KitTextFieldState extends State<KitTextField> {
  final FocusNode _focus = FocusNode();
  late bool _hidden = widget.obscure;

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
    final ringColor = widget.hasError
        ? AppPalette.red50
        : _focus.hasFocus
            ? AppPalette.blue60
            : null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label, style: AppText.textSmExtraBold),
        const SizedBox(height: 8),
        AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: ringColor ?? Colors.white,
            ),
            boxShadow:
                ringColor == null ? null : AppPalette.focusRing(ringColor),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Icon(widget.icon, color: AppPalette.gray80, size: 24),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: widget.controller,
                  focusNode: _focus,
                  obscureText: _hidden,
                  keyboardType: widget.keyboardType,
                  textInputAction: widget.textInputAction,
                  autofillHints: widget.autofillHints,
                  onSubmitted: widget.onSubmitted,
                  onChanged: widget.onChanged,
                  cursorColor: AppPalette.blue60,
                  style: AppText.textMdSemiBold,
                  decoration: InputDecoration(
                    hintText: widget.hint,
                    hintStyle: AppText.textMdSemiBold.copyWith(
                      color: AppPalette.gray60,
                    ),
                    filled: false,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 18),
                  ),
                ),
              ),
              if (widget.obscure)
                GestureDetector(
                  onTap: () => setState(() => _hidden = !_hidden),
                  child: Icon(
                    _hidden
                        ? Icons.visibility_rounded
                        : Icons.visibility_off_rounded,
                    color: AppPalette.gray30,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Red error banner ("Alert Notification Main").
class KitAlert extends StatelessWidget {
  final String message;

  const KitAlert({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppPalette.red10,
        border: Border.all(color: AppPalette.red50),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning_rounded, color: AppPalette.red50, size: 20),
          const SizedBox(width: 8),
          Expanded(child: Text(message, style: AppText.textSmSemiBold)),
        ],
      ),
    );
  }
}

/// Navy rounded header used on auth screens.
class KitAuthHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final VoidCallback? onBack;

  const KitAuthHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(minHeight: 242 - 44 + top),
      decoration: const BoxDecoration(
        color: AppPalette.gray80,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
      ),
      padding: EdgeInsets.fromLTRB(16, top + 24, 16, 32),
      child: onBack == null
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 16),
                const KitPlusIcon(size: 48),
                const SizedBox(height: 12),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: AppText.headingSm.copyWith(color: Colors.white),
                ),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                KitIconButton(
                  icon: Icons.chevron_left_rounded,
                  borderColor: Colors.white,
                  iconColor: Colors.white,
                  onPressed: onBack,
                  tooltip: 'Back',
                ),
                const SizedBox(height: 24),
                Text(
                  title,
                  style: AppText.headingSm.copyWith(color: Colors.white),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    subtitle!,
                    style: AppText.paragraphMd.copyWith(
                      color: AppPalette.gray20,
                    ),
                  ),
                ],
              ],
            ),
    );
  }
}

/// Thin progress bar from the onboarding/assessment headers.
class KitProgressBar extends StatelessWidget {
  final double value;

  const KitProgressBar({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(2),
      child: SizedBox(
        height: 8,
        child: Stack(
          children: [
            const Positioned.fill(
              child: ColoredBox(color: AppPalette.gray20),
            ),
            AnimatedFractionallySizedBox(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              widthFactor: value.clamp(0, 1).toDouble(),
              child: const ColoredBox(
                color: AppPalette.gray80,
                child: SizedBox.expand(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Selectable list card ("Health Goal" component).
class KitOptionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const KitOptionTile({
    super.key,
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final fg = selected ? Colors.white : AppPalette.gray80;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      decoration: BoxDecoration(
        color: selected ? AppPalette.blue60 : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: selected ? AppPalette.blue60 : Colors.white,
        ),
        boxShadow: selected
            ? AppPalette.focusRing(AppPalette.blue60)
            : AppPalette.softShadow(),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: selected ? AppPalette.blue20 : AppPalette.gray40,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    label,
                    style: AppText.textMdBold.copyWith(color: fg),
                  ),
                ),
                Icon(
                  selected
                      ? Icons.check_box_rounded
                      : Icons.check_box_outline_blank_rounded,
                  color: selected ? Colors.white : AppPalette.gray80,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Large white card with icon tile, title, subtitle and chevron.
class KitActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback? onTap;

  const KitActionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.selected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: selected ? AppPalette.blue60 : Colors.white,
        ),
        boxShadow: selected
            ? AppPalette.focusRing(AppPalette.blue60)
            : AppPalette.softShadow(),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: selected ? AppPalette.blue10 : AppPalette.gray10,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: selected ? AppPalette.blue60 : AppPalette.gray80,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: AppText.textMdExtraBold),
                      const SizedBox(height: 8),
                      Text(subtitle, style: AppText.paragraphSm),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Icon(
                  Icons.chevron_right_rounded,
                  color: selected ? AppPalette.blue60 : AppPalette.gray30,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// "Already have an account? Sign In." style footer link.
class KitFooterLink extends StatelessWidget {
  final String prompt;
  final String action;
  final VoidCallback onTap;

  const KitFooterLink({
    super.key,
    required this.prompt,
    required this.action,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text.rich(
          TextSpan(
            text: '$prompt ',
            style: AppText.textSmSemiBold.copyWith(color: AppPalette.gray50),
            children: [
              TextSpan(
                text: action,
                style: AppText.textSmExtraBold.copyWith(
                  color: AppPalette.red50,
                  decoration: TextDecoration.underline,
                  decorationColor: AppPalette.red50,
                ),
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
