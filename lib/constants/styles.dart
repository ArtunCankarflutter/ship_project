import 'package:flutter/material.dart';

class AppColors {
  static const primary = Color(0xFF1565C0);
  static const primaryLight = Color(0xFF1976D2);
  
  static const ship1Background = Color(0xFFE3F2FD);
  static const ship1Accent = Color(0xFF1565C0);
  
  static const ship2Background = Color(0xFFE8F5E9);
  static const ship2Accent = Color(0xFF2E7D32);
}

class TextStyles {
  static const headerText = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    letterSpacing: 0.5,
  );

  static const subheaderText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );

  static const shipNameText = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.black87,
    letterSpacing: 0.5,
  );

  static const detailLabelText = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
  );

  static const detailValueText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: Colors.black87,
  );
}