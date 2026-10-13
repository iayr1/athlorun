import 'dart:convert';

import 'package:flutter/material.dart';

import '../../config/themes/app_theme.dart';

/// Flat, monochrome bust avatars in the kit's style: 5 hair styles × 5
/// accessories = [count] premade avatars. Grey when idle, blue when selected.
class KitAvatar extends StatelessWidget {
  static const count = 25;

  final int id;
  final bool selected;
  final double size;

  const KitAvatar({
    super.key,
    required this.id,
    this.selected = false,
    this.size = 96,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: CustomPaint(painter: _AvatarPainter(id % count, selected)),
    );
  }
}

/// The user's picture: an uploaded image (base64 JPEG), a premade avatar,
/// or the first premade one as a fallback.
class KitProfilePicture extends StatelessWidget {
  final int? avatarId;
  final String? imageBase64;
  final double size;
  final bool selected;

  const KitProfilePicture({
    super.key,
    this.avatarId,
    this.imageBase64,
    this.size = 88,
    this.selected = true,
  });

  @override
  Widget build(BuildContext context) {
    final image = imageBase64;
    return ClipRRect(
      borderRadius: BorderRadius.circular(size * 0.22),
      child: Container(
        width: size,
        height: size,
        color: selected ? AppPalette.blue10 : AppPalette.gray20,
        child: image != null
            ? Image.memory(
                base64Decode(image),
                fit: BoxFit.cover,
                gaplessPlayback: true,
              )
            : KitAvatar(id: avatarId ?? 0, selected: selected, size: size),
      ),
    );
  }
}

class _AvatarPainter extends CustomPainter {
  final int id;
  final bool selected;

  _AvatarPainter(this.id, this.selected);

  int get _hair => id % 5;
  int get _extra => id ~/ 5;

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / 100;
    canvas.scale(s);

    final hair = Paint()
      ..color = selected ? AppPalette.gray80 : AppPalette.gray60;
    final skin = Paint()
      ..color = selected ? const Color(0xFF8AB4FF) : AppPalette.gray30;
    final shade = Paint()
      ..color = selected ? const Color(0xFF6A9CF8) : AppPalette.gray40;
    final cloth = Paint()
      ..color = selected ? AppPalette.blue60 : AppPalette.gray50;
    final ink = Paint()
      ..color = selected ? AppPalette.gray80 : AppPalette.gray60;

    // Hair behind the head (long styles).
    if (_hair == 1) {
      canvas.drawRRect(
        RRect.fromLTRBR(26, 24, 74, 92, const Radius.circular(22)),
        hair,
      );
    } else if (_hair == 4) {
      canvas.drawRRect(
        RRect.fromLTRBR(28, 24, 72, 70, const Radius.circular(20)),
        hair,
      );
    }

    // Shoulders, collar and neck.
    canvas.drawRRect(
      RRect.fromLTRBAndCorners(
        14,
        78,
        86,
        112,
        topLeft: const Radius.circular(30),
        topRight: const Radius.circular(30),
      ),
      cloth,
    );
    canvas.drawRect(const Rect.fromLTRB(43, 60, 57, 80), shade);
    canvas.drawPath(
      Path()
        ..moveTo(40, 78)
        ..lineTo(50, 90)
        ..lineTo(60, 78)
        ..close(),
      Paint()..color = Colors.white,
    );
    canvas.drawPath(
      Path()
        ..moveTo(43, 78)
        ..lineTo(50, 86)
        ..lineTo(57, 78)
        ..close(),
      shade,
    );

    // Face.
    canvas.drawOval(const Rect.fromLTRB(34, 28, 66, 68), skin);

    // Hair on top.
    switch (_hair) {
      case 0: // short
        canvas.drawPath(
          Path()
            ..moveTo(33, 46)
            ..cubicTo(30, 22, 70, 18, 67, 46)
            ..cubicTo(62, 34, 44, 30, 33, 46),
          hair,
        );
      case 1: // long, side parting
        canvas.drawPath(
          Path()
            ..moveTo(33, 50)
            ..cubicTo(30, 22, 70, 18, 67, 50)
            ..cubicTo(60, 34, 48, 32, 40, 38)
            ..cubicTo(37, 42, 35, 46, 33, 50),
          hair,
        );
      case 2: // bun
        canvas.drawCircle(const Offset(50, 20), 9, hair);
        canvas.drawPath(
          Path()
            ..moveTo(33, 44)
            ..cubicTo(32, 24, 68, 24, 67, 44)
            ..cubicTo(60, 34, 40, 34, 33, 44),
          hair,
        );
      case 3: // curly
        for (final (x, y, r) in const [
          (36.0, 36.0, 7.0),
          (42.0, 28.0, 8.0),
          (50.0, 25.0, 8.0),
          (58.0, 28.0, 8.0),
          (64.0, 36.0, 7.0),
          (33.0, 44.0, 5.0),
          (67.0, 44.0, 5.0),
        ]) {
          canvas.drawCircle(Offset(x, y), r, hair);
        }
      case 4: // bob with fringe
        canvas.drawPath(
          Path()
            ..moveTo(32, 46)
            ..cubicTo(30, 20, 70, 20, 68, 46)
            ..lineTo(64, 40)
            ..cubicTo(56, 38, 44, 38, 36, 40)
            ..close(),
          hair,
        );
    }

    // Eyes and mouth.
    canvas.drawCircle(const Offset(44, 50), 1.8, ink);
    canvas.drawCircle(const Offset(56, 50), 1.8, ink);
    canvas.drawArc(
      const Rect.fromLTRB(45, 54, 55, 61),
      0.3,
      2.5,
      false,
      Paint()
        ..color = ink.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.6
        ..strokeCap = StrokeCap.round,
    );

    // Accessory.
    final line = Paint()
      ..color = ink.color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6;
    switch (_extra) {
      case 1: // glasses
        canvas.drawCircle(const Offset(44, 50), 5, line);
        canvas.drawCircle(const Offset(56, 50), 5, line);
        canvas.drawLine(const Offset(49, 50), const Offset(51, 50), line);
      case 2: // earrings
        final gold = Paint()
          ..color = selected ? Colors.white : AppPalette.gray20;
        canvas.drawCircle(const Offset(34, 56), 2.5, gold);
        canvas.drawCircle(const Offset(66, 56), 2.5, gold);
      case 3: // beard
        canvas.drawPath(
          Path()
            ..moveTo(36, 54)
            ..cubicTo(38, 72, 62, 72, 64, 54)
            ..cubicTo(60, 62, 40, 62, 36, 54),
          hair,
        );
      case 4: // headband
        canvas.drawPath(
          Path()
            ..moveTo(33, 38)
            ..cubicTo(40, 30, 60, 30, 67, 38),
          Paint()
            ..color = selected ? Colors.white : AppPalette.gray20
            ..style = PaintingStyle.stroke
            ..strokeWidth = 4
            ..strokeCap = StrokeCap.round,
        );
    }
  }

  @override
  bool shouldRepaint(covariant _AvatarPainter old) =>
      old.id != id || old.selected != selected;
}
