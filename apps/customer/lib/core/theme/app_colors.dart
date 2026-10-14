import 'package:flutter/material.dart';

/// Core colour palette sampled from the Style Sathi Figma designs.
///
/// The designs use a warm cream page, a mustard/gold accent for prices and
/// primary actions, near-black text, and light grey cards.
abstract final class AppColors {
  /// Page background (cream).
  static const Color background = Color(0xFFF7F4EF);

  /// Card / panel background used for the cart item and summary blocks.
  static const Color cardGrey = Color(0xFFE6E2DC);

  /// Background of the rounded search fields.
  static const Color fieldGrey = Color(0xFFF1EFEA);

  /// Primary accent (mustard gold).
  static const Color gold = Color(0xFFC9A227);

  /// Slightly darker gold for pressed/selected states.
  static const Color goldDark = Color(0xFFA9871C);

  /// Primary text colour.
  static const Color ink = Color(0xFF1B1B1B);

  /// Secondary / supporting text.
  static const Color inkMuted = Color(0xFF6E6A63);

  /// Hairline dividers.
  static const Color divider = Color(0xFFD8D3CB);

  /// Outlined button border colour.
  static const Color outline = Color(0xFF2B2B2B);

  /// Overlay used on top of placeholder product imagery so labels stay legible.
  static const Color scrim = Color(0x99000000);
}