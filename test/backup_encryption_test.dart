import 'package:flutter_test/flutter_test.dart';
import 'package:password_management_apps/core/security/backup_service.dart';
import 'package:password_management_apps/data/database/database.dart';
import 'package:password_management_apps/data/repositories/vault_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppDatabase db;
  late VaultRepository repo;
  late BackupService backupService;

  setUp(() {
    db = AppDatabase.inMemory();
    repo = VaultRepository(db);
    backupService = BackupService();
  });

  tearDown(() async {
    await db.close();
  });

  test('Export and import encrypted backup (.brankas)', () async {
    await repo.createService(
      name: 'Test Service',
      category: 'Game',
      colorHex: '#0284C7',
    );
    final services = await repo.getServices();
    await repo.createAccount(
      serviceId: services.first.service.id,
      label: 'Main Account',
      password: r'S3cret#P@ssword2026',
    );

    const backupPassword = 'MySecretBackupPassword123!';
    final backupFile = await backupService.exportEncryptedBackup(
      repository: repo,
      password: backupPassword,
    );

    expect(await backupFile.exists(), isTrue);
    expect(backupFile.path.endsWith('.brankas'), isTrue);

    // Verify wrong password fails
    expect(
      () => backupService.importEncryptedBackup(
        repository: repo,
        filePath: backupFile.path,
        password: 'WrongPassword!',
      ),
      throwsException,
    );

    // Clean db and import with correct password
    final db2 = AppDatabase.inMemory();
    final repo2 = VaultRepository(db2);

    final importedCount = await backupService.importEncryptedBackup(
      repository: repo2,
      filePath: backupFile.path,
      password: backupPassword,
    );

    expect(importedCount, 1);
    final restoredServices = await repo2.getServices();
    expect(restoredServices.length, 1);
    expect(restoredServices.first.accounts.first.password, r'S3cret#P@ssword2026');

    await db2.close();
    if (await backupFile.exists()) {
      await backupFile.delete();
    }
  });
}
