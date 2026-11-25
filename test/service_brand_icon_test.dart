import 'package:flutter_test/flutter_test.dart';
import 'package:password_management_apps/core/widgets/service_brand_icon.dart';

void main() {
  group('ServiceIconHelper Presets Tests', () {
    test('Contains all 11 required brand icon presets with valid assets', () {
      final presets = ServiceIconHelper.presets;
      expect(presets.length, 11);

      final keys = presets.map((p) => p.key).toSet();
      expect(keys, containsAll([
        'google',
        'steam',
        'discord',
        'riot_games',
        'epic_games',
        'shopee',
        'ubisoft',
        'genshin_impact',
        'roblox',
        'point_blank',
        'ea',
      ]));

      for (final p in presets) {
        expect(p.assetPath, startsWith('assets/icons/services/'));
        expect(p.assetPath, endsWith('.png'));
      }
    });

    test('Auto-detects icon key accurately from service name keywords', () {
      expect(ServiceIconHelper.detectIconKey('Google Play'), 'google');
      expect(ServiceIconHelper.detectIconKey('Gmail Work'), 'google');
      expect(ServiceIconHelper.detectIconKey('Steam Main'), 'steam');
      expect(ServiceIconHelper.detectIconKey('Discord Nitro'), 'discord');
      expect(ServiceIconHelper.detectIconKey('Riot Games Store'), 'riot_games');
      expect(ServiceIconHelper.detectIconKey('Valorant ID'), 'riot_games');
      expect(ServiceIconHelper.detectIconKey('League of Legends'), 'riot_games');
      expect(ServiceIconHelper.detectIconKey('Epic Games Store'), 'epic_games');
      expect(ServiceIconHelper.detectIconKey('Fortnite Crew'), 'epic_games');
      expect(ServiceIconHelper.detectIconKey('Shopee Pay'), 'shopee');
      expect(ServiceIconHelper.detectIconKey('Ubisoft Connect'), 'ubisoft');
      expect(ServiceIconHelper.detectIconKey('Genshin Impact Asia'), 'genshin_impact');
      expect(ServiceIconHelper.detectIconKey('Roblox Premium'), 'roblox');
      expect(ServiceIconHelper.detectIconKey('Point Blank Zepetto'), 'point_blank');
      expect(ServiceIconHelper.detectIconKey('EA App'), 'ea');
      expect(ServiceIconHelper.detectIconKey('Electronic Arts'), 'ea');
      expect(ServiceIconHelper.detectIconKey('Unknown Service'), isNull);
    });

    test('resolveIconKey respects priority rules', () {
      // 1. Explicit preset key takes precedence
      expect(
        ServiceIconHelper.resolveIconKey(iconKey: 'steam', serviceName: 'Google Account'),
        'steam',
      );

      // 2. Explicit 'none' forces initial fallback even if name matches a preset
      expect(
        ServiceIconHelper.resolveIconKey(iconKey: 'none', serviceName: 'Steam Main'),
        isNull,
      );

      // 3. Custom photo path is retained
      expect(
        ServiceIconHelper.resolveIconKey(iconKey: 'file:/path/photo.png', serviceName: 'Steam'),
        'file:/path/photo.png',
      );

      // 4. Null iconKey auto-detects from name
      expect(
        ServiceIconHelper.resolveIconKey(iconKey: null, serviceName: 'Discord'),
        'discord',
      );
    });
  });
}
