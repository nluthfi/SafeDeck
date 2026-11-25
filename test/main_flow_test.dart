import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:password_management_apps/core/security/auth_provider.dart';
import 'package:password_management_apps/core/security/security_service.dart';
import 'package:password_management_apps/data/database/database.dart';
import 'package:password_management_apps/data/repositories/vault_repository.dart';
import 'package:password_management_apps/features/lock/lock_screen.dart';
import 'package:password_management_apps/features/services/services_screen.dart';

// Test mock security service in memory
class TestSecurityService extends SecurityService {
  String? _hash;

  @override
  Future<bool> hasMasterPin() async => _hash != null;

  @override
  Future<void> setMasterPin(String pin) async {
    _hash = 'testhash_$pin';
  }

  @override
  Future<bool> verifyMasterPin(String pin) async {
    return _hash == 'testhash_$pin';
  }

  @override
  Future<bool> isBiometricAvailable() async => false;

  @override
  Future<bool> isBiometricEnabled() async => false;

  @override
  Future<String> getAutoLockDuration() async => 'Segera';

  @override
  Future<int> getClipboardDurationSeconds() async => 30;
}

void main() {
  testWidgets('Main flow: Setup PIN -> Unlock -> View Services',
      (WidgetTester tester) async {
    final testSecurity = TestSecurityService();
    final testDb = AppDatabase.inMemory();
    final testRepo = VaultRepository(testDb);
    await testRepo.seedDebugData();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          securityServiceProvider.overrideWithValue(testSecurity),
          vaultRepositoryProvider.overrideWithValue(testRepo),
        ],
        child: const MaterialApp(
          home: LockScreen(),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    // Verify initial lock screen asks to create master PIN
    expect(find.text('Buat PIN Master 6-Digit'), findsOneWidget);

    // Enter 6-digit PIN: 1 2 3 4 5 6
    for (final digit in ['1', '2', '3', '4', '5', '6']) {
      await tester.tap(find.text(digit).first);
      await tester.pump();
    }

    // Now it asks for confirmation
    expect(find.text('Konfirmasi PIN Master'), findsOneWidget);

    // Enter confirmation PIN: 1 2 3 4 5 6
    for (final digit in ['1', '2', '3', '4', '5', '6']) {
      await tester.tap(find.text(digit).first);
      await tester.pump();
    }

    // Now master PIN is created
    expect(await testSecurity.hasMasterPin(), isTrue);

    // Pump ServicesScreen to verify services display
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          securityServiceProvider.overrideWithValue(testSecurity),
          vaultRepositoryProvider.overrideWithValue(testRepo),
        ],
        child: const MaterialApp(
          home: ServicesScreen(),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('SafeDeck'), findsOneWidget);
    expect(find.text('Steam'), findsOneWidget);
    expect(find.text('Discord'), findsOneWidget);
    expect(find.text('Google'), findsOneWidget);

    await testDb.close();
  });
}
