import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Generate app icons from vector canvas', () async {
    const int baseSize = 1024;

    Future<List<int>> renderIconPng(int size) async {
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder, Rect.fromLTWH(0, 0, size.toDouble(), size.toDouble()));
      final scale = size / baseSize;
      canvas.scale(scale, scale);

      // Background Squircle
      final bgRect = RRect.fromRectAndRadius(
        const Rect.fromLTWH(32, 32, 960, 960),
        const Radius.circular(224),
      );
      final bgPaint = Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0F172A),
            Color(0xFF1E293B),
            Color(0xFF090D16),
          ],
        ).createShader(const Rect.fromLTWH(32, 32, 960, 960));
      canvas.drawRRect(bgRect, bgPaint);

      final bgStrokePaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4
        ..color = const Color(0xFF334155);
      canvas.drawRRect(bgRect, bgStrokePaint);

      // Outer ring
      final ringPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 20
        ..strokeCap = StrokeCap.round
        ..shader = const SweepGradient(
          colors: [
            Color(0x4D34D399),
            Color(0xCC10B981),
            Color(0x3306B6D4),
            Color(0x4D34D399),
          ],
        ).createShader(Rect.fromCircle(center: const Offset(512, 512), radius: 340));
      canvas.drawCircle(const Offset(512, 512), 340, ringPaint);

      // Glow behind checkmark
      final glowPaint = Paint()
        ..color = const Color(0xFF10B981).withValues(alpha: 0.18)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 36);
      canvas.drawCircle(const Offset(512, 512), 180, glowPaint);

      // First leaf
      final leaf1Path = Path()
        ..moveTo(640, 330)
        ..cubicTo(670, 260, 760, 250, 800, 240)
        ..cubicTo(790, 290, 770, 380, 700, 410)
        ..cubicTo(660, 430, 630, 380, 640, 330)
        ..close();
      final leaf1Paint = Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF6EE7B7),
            Color(0xFF10B981),
          ],
        ).createShader(const Rect.fromLTWH(630, 240, 170, 190));
      canvas.drawPath(leaf1Path, leaf1Paint);

      // Second small leaf
      final leaf2Path = Path()
        ..moveTo(670, 410)
        ..cubicTo(720, 400, 770, 430, 790, 470)
        ..cubicTo(740, 480, 690, 460, 670, 410)
        ..close();
      final leaf2Paint = Paint()..color = const Color(0xFF34D399);
      canvas.drawPath(leaf2Path, leaf2Paint);

      // Checkmark
      final checkPath = Path()
        ..moveTo(330, 520)
        ..lineTo(460, 650)
        ..cubicTo(475, 665, 500, 665, 515, 650)
        ..lineTo(730, 360)
        ..cubicTo(742, 345, 740, 322, 724, 310)
        ..cubicTo(708, 298, 685, 300, 672, 316)
        ..lineTo(488, 560)
        ..lineTo(388, 460)
        ..cubicTo(374, 446, 352, 446, 338, 460)
        ..cubicTo(324, 474, 324, 496, 338, 510)
        ..close();

      final checkPaint = Paint()
        ..shader = const LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          colors: [
            Color(0xFF059669),
            Color(0xFF10B981),
            Color(0xFF34D399),
            Color(0xFF6EE7B7),
          ],
        ).createShader(const Rect.fromLTWH(320, 300, 420, 365));
      canvas.drawPath(checkPath, checkPaint);

      // Dew drop
      final dropPaint = Paint()..color = const Color(0xFFE0F2FE);
      canvas.drawCircle(const Offset(710, 270), 18, dropPaint);

      final picture = recorder.endRecording();
      final img = await picture.toImage(size, size);
      final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
      return byteData!.buffer.asUint8List();
    }

    final outputs = {
      'assets/icons/app_icon.png': 1024,
      'android/app/src/main/res/mipmap-mdpi/ic_launcher.png': 48,
      'android/app/src/main/res/mipmap-hdpi/ic_launcher.png': 72,
      'android/app/src/main/res/mipmap-xhdpi/ic_launcher.png': 96,
      'android/app/src/main/res/mipmap-xxhdpi/ic_launcher.png': 144,
      'android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png': 192,
    };

    for (final entry in outputs.entries) {
      final bytes = await renderIconPng(entry.value);
      final file = File(entry.key);
      file.parent.createSync(recursive: true);
      file.writeAsBytesSync(bytes);
      expect(file.existsSync(), isTrue);
      expect(file.lengthSync(), greaterThan(0));
    }
  });
}
