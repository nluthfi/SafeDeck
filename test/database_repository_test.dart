import 'package:flutter_test/flutter_test.dart';
import 'package:password_management_apps/data/database/database.dart';
import 'package:password_management_apps/data/repositories/vault_repository.dart';

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

  test('Seed debug data populates 14 services and calculates security score', () async {
    await repo.seedDebugData();
    final services = await repo.getServices();
    expect(services.length, 14);

    final totalAccounts = services.fold<int>(0, (sum, s) => sum + s.accountCount);
    expect(totalAccounts, greaterThanOrEqualTo(20));

    final summary = await repo.watchSecuritySummary().first;
    expect(summary.totalServices, 14);
    expect(summary.totalAccounts, totalAccounts);
    expect(summary.safeScorePercent, greaterThan(80));
  });

  test('Create, search and cascade delete service', () async {
    final serviceId = await repo.createService(
      name: 'Custom Service',
      category: 'Kerja',
      colorHex: '#0284C7',
    );

    final accountId = await repo.createAccount(
      serviceId: serviceId,
      label: 'Main Account',
      username: 'user123',
      password: r'Str0ng#P@ssword2026',
    );

    final searchRes = await repo.search('Custom');
    expect(searchRes.services.length, 1);
    expect(searchRes.services.first.service.id, serviceId);

    final accountSearch = await repo.search('user123');
    expect(accountSearch.accounts.length, 1);
    expect(accountSearch.accounts.first.account.id, accountId);

    // Delete service should cascade delete account
    await repo.deleteService(serviceId);
    final deletedAcc = await repo.getAccountById(accountId);
    expect(deletedAcc, isNull);
  });

  test('Reorder services changes sequence correctly', () async {
    final s1 = await repo.createService(
      name: 'Alpha Service',
      category: 'Game',
      colorHex: '#0284C7',
      iconKey: 'steam',
    );
    final s2 = await repo.createService(
      name: 'Beta Service',
      category: 'Game',
      colorHex: '#DC2626',
      iconKey: 'riot_games',
    );
    final s3 = await repo.createService(
      name: 'Gamma Service',
      category: 'Sosial',
      colorHex: '#5865F2',
      iconKey: 'discord',
    );

    // Initial order should be s1, s2, s3 (by sortOrder asc)
    var services = await repo.getServices();
    expect(services.map((s) => s.service.id).toList(), [s1, s2, s3]);
    expect(services.first.service.iconKey, 'steam');

    // Reorder full list to s3, s1, s2
    await repo.reorderServices([s3, s1, s2]);
    services = await repo.getServices();
    expect(services.map((s) => s.service.id).toList(), [s3, s1, s2]);

    // Reorder subset within Game category: s2 moved before s1
    await repo.reorderServices([s2, s1]);
    final gameServices = await repo.getServices(category: 'Game');
    expect(gameServices.map((s) => s.service.id).toList(), [s2, s1]);
  });
}
