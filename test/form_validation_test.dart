import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:password_management_apps/data/database/database.dart';
import 'package:password_management_apps/data/repositories/vault_repository.dart';
import 'package:password_management_apps/features/services/edit_service_screen.dart';
import 'package:password_management_apps/features/accounts/edit_account_screen.dart';

void main() {
  late AppDatabase db;
  late VaultRepository repo;

  setUp(() {
    db = AppDatabase.inMemory();
    repo = VaultRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  testWidgets('EditServiceScreen validates empty service name',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          vaultRepositoryProvider.overrideWithValue(repo),
        ],
        child: const MaterialApp(
          home: EditServiceScreen(),
        ),
      ),
    );
    await tester.pump();

    final submitBtn = find.text('Simpan Layanan');
    expect(submitBtn, findsOneWidget);
    await tester.tap(submitBtn);
    await tester.pump();

    expect(find.text('Nama layanan wajib diisi'), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(milliseconds: 50));
  });

  testWidgets('EditAccountScreen validates empty label and password',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          vaultRepositoryProvider.overrideWithValue(repo),
        ],
        child: const MaterialApp(
          home: EditAccountScreen(),
        ),
      ),
    );
    await tester.pump();

    // Tap Selesai in app bar
    final doneBtn = find.text('Selesai');
    expect(doneBtn, findsOneWidget);
    await tester.tap(doneBtn);
    await tester.pump();

    expect(find.text('Label akun wajib diisi'), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(milliseconds: 50));
  });
}
