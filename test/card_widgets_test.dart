import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:password_management_apps/core/theme/app_colors.dart';
import 'package:password_management_apps/core/widgets/account_card.dart';
import 'package:password_management_apps/core/widgets/service_brand_icon.dart';
import 'package:password_management_apps/core/widgets/service_card.dart';
import 'package:password_management_apps/core/widgets/strength_indicator.dart';

void main() {
  testWidgets('ServiceCard renders info correctly and triggers onTap',
      (WidgetTester tester) async {
    bool tapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ServiceCard(
            name: 'Steam',
            category: 'Game Platform',
            accountCount: 4,
            color: AppColors.primary,
            onTap: () => tapped = true,
          ),
        ),
      ),
    );

    expect(find.text('Steam'), findsOneWidget);
    expect(find.text('Game Platform'), findsOneWidget);
    expect(find.text('4 akun tersimpan'), findsOneWidget);

    await tester.tap(find.text('Steam'));
    await tester.pump();
    expect(tapped, isTrue);
  });

  testWidgets('AccountCard renders username and copy buttons trigger',
      (WidgetTester tester) async {
    bool copiedId = false;
    bool copiedPassword = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AccountCard(
            label: 'Akun Utama',
            strength: PasswordStrength.veryStrong,
            username: 'luthfi_steam',
            email: 'luthfi.pro@gmail.com',
            onCopyId: () => copiedId = true,
            onCopyPassword: () => copiedPassword = true,
          ),
        ),
      ),
    );

    expect(find.text('Akun Utama'), findsOneWidget);
    expect(find.text('luthfi_steam'), findsOneWidget);
    expect(find.text('Sangat Kuat'), findsOneWidget);

    await tester.tap(find.text('Salin ID'));
    await tester.pump();
    expect(copiedId, isTrue);

    await tester.tap(find.text('Salin Password'));
    await tester.pump();
    expect(copiedPassword, isTrue);
  });

  test('ServiceIconHelper detects and resolves all 11 required brands', () {
    expect(ServiceIconHelper.detectIconKey('Google'), 'google');
    expect(ServiceIconHelper.detectIconKey('Riot Games'), 'riot_games');
    expect(ServiceIconHelper.detectIconKey('Steam'), 'steam');
    expect(ServiceIconHelper.detectIconKey('Epic Games Store'), 'epic_games');
    expect(ServiceIconHelper.detectIconKey('Discord Community'), 'discord');
    expect(ServiceIconHelper.detectIconKey('Shopee Indonesia'), 'shopee');
    expect(ServiceIconHelper.detectIconKey('Ubisoft Connect'), 'ubisoft');
    expect(ServiceIconHelper.detectIconKey('Genshin Impact'), 'genshin_impact');
    expect(ServiceIconHelper.detectIconKey('Roblox Studio'), 'roblox');
    expect(ServiceIconHelper.detectIconKey('Point Blank Zepetto'), 'point_blank');
    expect(ServiceIconHelper.detectIconKey('EA App'), 'ea');

    // Optional / fallback:
    expect(ServiceIconHelper.resolveIconKey(iconKey: 'none', serviceName: 'Steam'), isNull);
    expect(ServiceIconHelper.resolveIconKey(iconKey: null, serviceName: 'Bank Mandiri'), isNull);
    expect(ServiceIconHelper.resolveIconKey(iconKey: 'google', serviceName: 'Custom Name'), 'google');
  });

  testWidgets('ServiceCard renders ServiceAvatar with brand icon and fallback initial',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              ServiceCard(
                name: 'Steam',
                category: 'Game',
                accountCount: 2,
                color: Colors.blue,
                iconKey: 'steam',
              ),
              ServiceCard(
                name: 'Kustom',
                category: 'Lainnya',
                accountCount: 1,
                color: Colors.purple,
                iconKey: 'none',
              ),
            ],
          ),
        ),
      ),
    );

    expect(find.byType(ServiceBrandIcon), findsOneWidget);
    expect(find.text('K'), findsOneWidget); // Fallback initial for 'Kustom'
  });

  testWidgets('ServiceCard triggers onLongPress properly',
      (WidgetTester tester) async {
    bool longPressed = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ServiceCard(
            name: 'Discord',
            category: 'Sosial',
            accountCount: 1,
            color: Colors.blue,
            onLongPress: () => longPressed = true,
          ),
        ),
      ),
    );

    await tester.longPress(find.text('Discord'));
    await tester.pump();
    expect(longPressed, isTrue);
  });
}
