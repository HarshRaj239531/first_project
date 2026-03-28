import 'package:flutter/material.dart';

class AppColors {
  // Primary Palette (Neon & Deep)
  static const Color primary = Color(0xFF6366F1); // Indigo Neon
  static const Color accent = Color(0xFF06B6D4);  // Cyan Accent
  static const Color violet = Color(0xFF8B5CF6);
  static const Color pink = Color(0xFFEC4899);

  // Deep Backgrounds
  static const Color background = Color(0xFF0F172A); // Slate 900
  static const Color surface = Color(0xFF1E293B);    // Slate 800
  static const Color surfaceVariant = Color(0xFF334155);
  
  // Glassmorphism Foundations
  static const Color glassBase = Color(0x1A6366F1); // 10% Primary
  static const Color glassBorder = Color(0x33FFFFFF); // 20% White
  static const Color glassHighlight = Color(0x4DFFFFFF); // 30% White

  // Text
  static const Color textPrimary = Color(0xFFF8FAFC);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textHint = Color(0xFF64748B);

  // Status
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // Gradients (Premium)
  static const LinearGradient mainGradient = LinearGradient(
    colors: [primary, violet, pink],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [background, Color(0xFF020617)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient glassGradient = LinearGradient(
    colors: [Color(0x1AFFFFFF), Color(0x05FFFFFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
