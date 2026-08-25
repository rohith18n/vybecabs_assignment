import 'package:flutter/material.dart';

/// App Color Palette inspired by Vybe Design Language
class AppColors {
  AppColors._();

  // Primary Brand - Vybe Coral/Orange
  static const Color primary = Color(0xFFFF4E27); // Authentic Vybe Flame Orange
  static const Color primaryLight = Color(0xFFFF7A45);
  static const Color primaryDark = Color(0xFFD93812);

  // Secondary & Accents
  static const Color black = Color(0xFF0D0F12);
  static const Color darkPill = Color(0xFF1E1F24);
  static const Color secondary = Color(0xFF00E5FF); // Electric Cyan
  static const Color accent = Color(0xFFFF4E27);
  static const Color whatsapp = Color(0xFF25D366);

  // Status & Feedback
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // Dark Theme Palette
  static const Color darkBackground = Color(0xFF0F1015);
  static const Color darkSurface = Color(0xFF16171D);
  static const Color darkCard = Color(0xFF1C1D24);
  static const Color darkCardElevated = Color(0xFF242630);
  static const Color darkBorder = Color(0xFF292B35);
  static const Color darkDivider = Color(0xFF22242D);
  static const Color darkTextPrimary = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFF9E9EA7);
  static const Color darkTextMuted = Color(0xFF606470);

  // Light Theme Palette
  static const Color lightBackground = Color(0xFFF8F9FA);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightCardElevated = Color(0xFFF3F4F6);
  static const Color lightBorder = Color(0xFFE5E7EB);
  static const Color lightDivider = Color(0xFFF3F4F6);
  static const Color lightTextPrimary = Color(0xFF0D0F12);
  static const Color lightTextSecondary = Color(0xFF4B5563);
  static const Color lightTextMuted = Color(0xFF9CA3AF);
  static const Color lightChip = Color(0xFFF3F4F6);

  // Backwards compatibility aliases
  static const Color background = darkBackground;
  static const Color surface = darkSurface;
  static const Color card = darkCard;
  static const Color cardElevated = darkCardElevated;
  static const Color border = darkBorder;
  static const Color divider = darkDivider;
  static const Color textPrimary = darkTextPrimary;
  static const Color textSecondary = darkTextSecondary;
  static const Color textMuted = darkTextMuted;

  // Map elements
  static const Color polylinePickup = Color(0xFFFF4E27);
  static const Color polylineTrip = Color(0xFF0D0F12);
  static const Color polylineTripDark = Color(0xFF00E5FF);
  static const Color markerPickup = Color(0xFF10B981);
  static const Color markerDrop = Color(0xFFFF4E27);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFFFF5722), Color(0xFFFF3D00)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient vybeFlameGradient = LinearGradient(
    colors: [Color(0xFFFF6A3D), Color(0xFFFF4E27), Color(0xFFE03810)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkCardGradient = LinearGradient(
    colors: [Color(0xFF1C1D24), Color(0xFF14151B)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient lightCardGradient = LinearGradient(
    colors: [Color(0xFFFFFFFF), Color(0xFFF9FAFB)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
