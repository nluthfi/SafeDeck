import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:password_management_apps/data/database/database.dart';
import 'package:password_management_apps/data/repositories/vault_repository.dart';
import 'package:password_management_apps/features/services/widgets/service_options_bottom_sheet.dart';

void main() {
  testWidgets('Delete service flow from bottom sheet deletes service and triggers onDeleted callback',
      (WidgetTester tester) async {
    final db = AppDatabase.inMemory();
    final repo = VaultRepository(db);

    final serviceId = await repo.createService(
      name: 'Riot Games',
      category: 'Game',
      colorHex: '#DC2626',
    );

    final accountId = await repo.createAccount(
      serviceId: serviceId,
      label: 'Valorant ID',
      username: 'agent#123',
      password: 'StrongPassword#1',
    );

    final serviceWithAccounts = await repo.getServiceById(serviceId);
    expect(serviceWithAccounts, isNotNull);

    bool wasDeletedCallbackFired = false;

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          vaultRepositoryProvider.overrideWithValue(repo),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  ServiceOptionsBottomSheet.show(
                    context,
                    serviceWithAccounts: serviceWithAccounts!,
                    onDeleted: () => wasDeletedCallbackFired = true,
                  );
                },
                child: const Text('Buka Opsi'),
              ),
            ),
          ),
        ),
      ),
    );

    // Tap to open bottom sheet
    await tester.tap(find.text('Buka Opsi'));
    await tester.pumpAndSettle();

    // Verify bottom sheet is shown
    expect(find.text('Hapus Layanan & Semua Akun'), findsOneWidget);

    // Tap 'Hapus Layanan & Semua Akun'
    await tester.tap(find.text('Hapus Layanan & Semua Akun'));
    await tester.pumpAndSettle();

    // Verify ConfirmDialog is shown
    expect(find.text('Hapus Layanan Riot Games?'), findsOneWidget);
    expect(find.text('Ya, Hapus Semua Akun & Layanan'), findsOneWidget);

    // Tap confirm button
    await tester.tap(find.text('Ya, Hapus Semua Akun & Layanan'));
    await tester.pumpAndSettle();

    // Verify onDeleted callback was fired
    expect(wasDeletedCallbackFired, isTrue);

    // Verify service is actually removed from database
    final checkService = await repo.getServiceById(serviceId);
    expect(checkService, isNull);

    // Verify account was cascade deleted
    final checkAccount = await repo.getAccountById(accountId);
    expect(checkAccount, isNull);

    await db.close();
  });
}
