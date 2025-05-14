import 'package:flutter/material.dart';

class PicpleTypography {
  static const String _fontFamily = 'Pretendard';

  // Headings
  static const TextStyle head1 = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w700, // Bold
    fontSize: 36,
    height: 64 / 36, // ≈ 1.78
  );

  static const TextStyle head2 = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w700,
    fontSize: 28,
    height: 44 / 28, // ≈ 1.57
  );

  // Titles
  static const TextStyle title1 = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w600, // SemiBold
    fontSize: 20,
    height: 32 / 20, // ≈ 1.6
  );

  static const TextStyle title2 = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w600,
    fontSize: 18,
    height: 28 / 18, // ≈ 1.56
  );

  // Body
  static const TextStyle body1SemiBold = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w600,
    fontSize: 16,
    height: 24 / 16, // 1.5
  );

  static const TextStyle body1 = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w400,
    fontSize: 16,
    height: 24 / 16, // 1.5
  );

  static const TextStyle body2SemiBold = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w600,
    fontSize: 14,
    height: 20 / 14, // ≈ 1.43
  );

  static const TextStyle body2 = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w400,
    fontSize: 14,
    height: 20 / 14, // ≈ 1.43
  );

  // Navigation / Caption
  static const TextStyle nav = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w400,
    fontSize: 12,
    height: 16 / 12, // ≈ 1.33
  );
}