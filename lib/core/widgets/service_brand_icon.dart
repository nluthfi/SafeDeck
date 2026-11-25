import 'dart:io';
import 'package:flutter/material.dart';

/// Supported service brand icon presets
class BrandIconPreset {
  final String key;
  final String name;
  final Color defaultColor;
  final String assetPath;

  const BrandIconPreset({
    required this.key,
    required this.name,
    required this.defaultColor,
    required this.assetPath,
  });
}

class ServiceIconHelper {
  static const List<BrandIconPreset> presets = [
    BrandIconPreset(
      key: 'google',
      name: 'Google',
      defaultColor: Color(0xFF4285F4),
      assetPath: 'assets/icons/services/google.png',
    ),
    BrandIconPreset(
      key: 'steam',
      name: 'Steam',
      defaultColor: Color(0xFF1B2838),
      assetPath: 'assets/icons/services/steam.png',
    ),
    BrandIconPreset(
      key: 'discord',
      name: 'Discord',
      defaultColor: Color(0xFF5865F2),
      assetPath: 'assets/icons/services/discord.png',
    ),
    BrandIconPreset(
      key: 'riot_games',
      name: 'Riot Games',
      defaultColor: Color(0xFFDC2626),
      assetPath: 'assets/icons/services/riot_games.png',
    ),
    BrandIconPreset(
      key: 'epic_games',
      name: 'Epic Games',
      defaultColor: Color(0xFF0F172A),
      assetPath: 'assets/icons/services/epic_games.png',
    ),
    BrandIconPreset(
      key: 'shopee',
      name: 'Shopee',
      defaultColor: Color(0xFFEE4D2D),
      assetPath: 'assets/icons/services/shopee.png',
    ),
    BrandIconPreset(
      key: 'ubisoft',
      name: 'Ubisoft',
      defaultColor: Color(0xFF0070FF),
      assetPath: 'assets/icons/services/ubisoft.png',
    ),
    BrandIconPreset(
      key: 'genshin_impact',
      name: 'Genshin Impact',
      defaultColor: Color(0xFF0D9488),
      assetPath: 'assets/icons/services/genshin_impact.png',
    ),
    BrandIconPreset(
      key: 'roblox',
      name: 'Roblox',
      defaultColor: Color(0xFF334155),
      assetPath: 'assets/icons/services/roblox.png',
    ),
    BrandIconPreset(
      key: 'point_blank',
      name: 'Point Blank',
      defaultColor: Color(0xFFB91C1C),
      assetPath: 'assets/icons/services/point_blank.png',
    ),
    BrandIconPreset(
      key: 'ea',
      name: 'EA (Electronic Arts)',
      defaultColor: Color(0xFFE11D48),
      assetPath: 'assets/icons/services/ea.png',
    ),
  ];

  /// Get preset by key
  static BrandIconPreset? getPreset(String key) {
    for (final p in presets) {
      if (p.key == key) return p;
    }
    return null;
  }

  /// Auto-detect icon from service name
  static String? detectIconKey(String name) {
    final lower = name.toLowerCase().trim();
    if (lower.isEmpty) return null;

    if (lower.contains('google') || lower.contains('gmail') || lower.contains('youtube')) {
      return 'google';
    }
    if (lower.contains('steam') || lower.contains('valve')) {
      return 'steam';
    }
    if (lower.contains('discord')) {
      return 'discord';
    }
    if (lower.contains('riot') || lower.contains('valorant') || lower.contains('league of legends')) {
      return 'riot_games';
    }
    if (lower.contains('epic') || lower.contains('fortnite')) {
      return 'epic_games';
    }
    if (lower.contains('shopee')) {
      return 'shopee';
    }
    if (lower.contains('ubisoft') || lower.contains('uplay')) {
      return 'ubisoft';
    }
    if (lower.contains('genshin') || lower.contains('hoyoverse') || lower.contains('mihoyo')) {
      return 'genshin_impact';
    }
    if (lower.contains('roblox')) {
      return 'roblox';
    }
    if (lower.contains('point blank') || lower.contains('pointblank') || lower.contains('zepetto')) {
      return 'point_blank';
    }
    if (lower == 'ea' || lower.contains('electronic arts') || lower.contains('origin') || lower.startsWith('ea ')) {
      return 'ea';
    }

    return null;
  }

  /// Resolve icon key: explicit key takes precedence unless 'none', else fallback to name match.
  static String? resolveIconKey({String? iconKey, required String serviceName}) {
    if (iconKey == 'none') return null;
    if (iconKey != null && iconKey.isNotEmpty) return iconKey;
    return detectIconKey(serviceName);
  }
}

/// Image photo / asset based brand icon widget
class ServiceBrandIcon extends StatelessWidget {
  const ServiceBrandIcon({
    super.key,
    required this.iconKey,
    this.size = 24.0,
    this.color,
  });

  final String iconKey;
  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    // 1. Custom photo file from device storage
    if (iconKey.startsWith('file:')) {
      final path = iconKey.substring(5);
      final file = File(path);
      return ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Image.file(
          file,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => _fallbackDot(),
        ),
      );
    }

    // 2. Preset photo / logo image
    final preset = ServiceIconHelper.getPreset(iconKey);
    final assetPath = preset?.assetPath ?? 'assets/icons/services/$iconKey.png';

    return Image.asset(
      assetPath,
      width: size,
      height: size,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) => _fallbackDot(),
    );
  }

  Widget _fallbackDot() {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color ?? Colors.blue,
        shape: BoxShape.circle,
      ),
    );
  }
}

/// Unified Avatar Widget that supports real photo images or letter initials
class ServiceAvatar extends StatelessWidget {
  const ServiceAvatar({
    super.key,
    required this.name,
    required this.color,
    this.iconKey,
    this.size = 44.0,
    this.borderRadius = 10.0,
  });

  final String name;
  final Color color;
  final String? iconKey;
  final double size;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final resolvedKey = ServiceIconHelper.resolveIconKey(
      iconKey: iconKey,
      serviceName: name,
    );
    final initial = name.isNotEmpty ? name[0].toUpperCase() : '?';

    // Check if it's a custom user photo
    final isCustomFile = resolvedKey != null && resolvedKey.startsWith('file:');

    if (isCustomFile) {
      final path = resolvedKey.substring(5);
      final file = File(path);
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(color: color.withOpacity(0.35), width: 1.2),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius - 1),
          child: Image.file(
            file,
            width: size,
            height: size,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => _buildInitial(initial),
          ),
        ),
      );
    }

    return Container(
      width: size,
      height: size,
      padding: resolvedKey != null ? EdgeInsets.all(size * 0.16) : EdgeInsets.zero,
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: color.withOpacity(0.25), width: 1),
      ),
      child: Center(
        child: resolvedKey != null
            ? ServiceBrandIcon(
                iconKey: resolvedKey,
                size: size * 0.68,
                color: color,
              )
            : _buildInitial(initial),
      ),
    );
  }

  Widget _buildInitial(String initial) {
    return Text(
      initial,
      style: TextStyle(
        fontSize: size * 0.44,
        fontWeight: FontWeight.w700,
        color: color,
      ),
    );
  }
}
