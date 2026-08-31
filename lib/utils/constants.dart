import 'dart:ui';

import 'package:flutter/material.dart';

// ==========================================
// TEMA & WARNA (APPLE GLASSMORPHISM STYLE)
// ==========================================
const Color kPrimary = Color(0xFF3525CD);
const Color kBackground = Color(0xFFF4F6F9);
const Color kSurface = Color(0xFFFFFFFF);
const Color kOutline = Color(0xFFEAEEF4);
const Color kTextMain = Color(0xFF0F172A);
const Color kTextVariant = Color(0xFF64748B);
const Color kError = Color(0xFFEF4444);

// Rank Colors (8 tiers)
const Color kRoyalCrown = Color(0xFFDC2626);
const Color kCrown = Color(0xFFE11D48);
const Color kDiamond = Color(0xFF0EA5E9);
const Color kPlatinum = Color(0xFF8B5CF6);
const Color kGold = Color(0xFFF59E0B);
const Color kSilver = Color(0xFF94A3B8);
const Color kBronze = Color(0xFFD97706);
const Color kStartUp = Color(0xFF6B7280);

const List<BoxShadow> kAppleShadow = [
  BoxShadow(
    color: Color(0x0A000000),
    blurRadius: 24,
    offset: Offset(0, 8),
    spreadRadius: 0,
  ),
];

/// Subtle radial gradient for the Scaffold background.
/// Places a faint primary glow at the top-right to elevate glassmorphism depth.
const RadialGradient kBackgroundGradient = RadialGradient(
  center: Alignment.topRight,
  radius: 1.2,
  colors: [
    Color(0x0A3525CD), // kPrimary at ~4% opacity
    kBackground,
  ],
  stops: [0.0, 0.6],
);

class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
      };
}

Color getRankColor(String rank) {
  switch (rank.toLowerCase()) {
    case 'royal crown':
      return kRoyalCrown;
    case 'crown':
      return kCrown;
    case 'diamond':
      return kDiamond;
    case 'platinum':
      return kPlatinum;
    case 'gold':
      return kGold;
    case 'silver':
      return kSilver;
    case 'bronze':
      return kBronze;
    default:
      return kStartUp;
  }
}
