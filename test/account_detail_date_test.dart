import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:password_management_apps/data/database/database.dart';
import 'package:password_management_apps/data/repositories/vault_repository.dart';
import 'package:password_management_apps/features/accounts/account_detail_screen.dart';

void main() {
  testWidgets('AccountDetailScreen renders date without LocaleDataException',
      (WidgetTester tester) async {
    final db = AppDatabase.inMemory();
    final repo = VaultRepository(db);

    final serviceId = await repo.createService(
      name: 'Google Play',
      category: 'Kerja',
      colorHex: '#0284C7',
    );

    final accountId = await repo.createAccount(
      serviceId: serviceId,
      label: 'Akun Kantor',
      username: 'luthfi@work.com',
      password: 'MyPassword#2026',
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          vaultRepositoryProvider.overrideWithValue(repo),
        ],
        child: MaterialApp(
          home: AccountDetailScreen(accountId: accountId),
        ),
      ),
    );

    // Pump to settle async stream
    await tester.pumpAndSettle();

    // Verify account details render properly
    expect(find.text('Akun Kantor'), findsOneWidget);
    expect(find.text('luthfi@work.com'), findsOneWidget);
    expect(find.text('Detail Akun'), findsWidgets);

    // Verify no exception occurred and date text is shown
    expect(find.textContaining('2026'), findsWidgets);

    await db.close();
  });
}
