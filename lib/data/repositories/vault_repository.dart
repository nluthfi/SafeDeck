import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../core/widgets/strength_indicator.dart';
import '../database/database.dart';

class ServiceWithAccounts {
  const ServiceWithAccounts({
    required this.service,
    required this.accounts,
  });

  final Service service;
  final List<Account> accounts;

  int get accountCount => accounts.length;
}

class SecuritySummary {
  const SecuritySummary({
    required this.totalAccounts,
    required this.totalServices,
    required this.safeScorePercent,
  });

  final int totalAccounts;
  final int totalServices;
  final int safeScorePercent;
}

class SearchResults {
  const SearchResults({
    required this.services,
    required this.accounts,
  });

  final List<ServiceWithAccounts> services;
  final List<AccountWithService> accounts;
}

class AccountWithService {
  const AccountWithService({
    required this.account,
    required this.service,
  });

  final Account account;
  final Service service;
}

final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
});

final vaultRepositoryProvider = Provider<VaultRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return VaultRepository(db);
});

class VaultRepository {
  VaultRepository(this._db);

  final AppDatabase _db;
  final _uuid = const Uuid();

  // Watch all services along with their accounts
  Stream<List<ServiceWithAccounts>> watchServices({String? category}) {
    final query = _db.select(_db.services);
    if (category != null && category.isNotEmpty && category != 'Semua') {
      query.where((s) => s.category.equals(category));
    }
    query.orderBy([
      (s) => OrderingTerm.asc(s.sortOrder),
      (s) => OrderingTerm.asc(s.name),
    ]);

    return query.watch().asyncMap((services) async {
      final results = <ServiceWithAccounts>[];
      for (final service in services) {
        final accounts = await (_db.select(_db.accounts)
              ..where((a) => a.serviceId.equals(service.id))
              ..orderBy([(a) => OrderingTerm.asc(a.label)]))
            .get();
        results.add(ServiceWithAccounts(service: service, accounts: accounts));
      }
      return results;
    });
  }

  // Get all services once
  Future<List<ServiceWithAccounts>> getServices({String? category}) async {
    final query = _db.select(_db.services);
    if (category != null && category.isNotEmpty && category != 'Semua') {
      query.where((s) => s.category.equals(category));
    }
    query.orderBy([
      (s) => OrderingTerm.asc(s.sortOrder),
      (s) => OrderingTerm.asc(s.name),
    ]);

    final services = await query.get();
    final results = <ServiceWithAccounts>[];
    for (final service in services) {
      final accounts = await (_db.select(_db.accounts)
            ..where((a) => a.serviceId.equals(service.id))
            ..orderBy([(a) => OrderingTerm.asc(a.label)]))
          .get();
      results.add(ServiceWithAccounts(service: service, accounts: accounts));
    }
    return results;
  }

  // Get service by ID
  Future<ServiceWithAccounts?> getServiceById(String serviceId) async {
    final service = await (_db.select(_db.services)
          ..where((s) => s.id.equals(serviceId)))
        .getSingleOrNull();
    if (service == null) return null;

    final accounts = await (_db.select(_db.accounts)
          ..where((a) => a.serviceId.equals(service.id))
          ..orderBy([(a) => OrderingTerm.asc(a.label)]))
        .get();

    return ServiceWithAccounts(service: service, accounts: accounts);
  }

  // Watch accounts for a specific service
  Stream<List<Account>> watchAccountsForService(String serviceId) {
    return (_db.select(_db.accounts)
          ..where((a) => a.serviceId.equals(serviceId))
          ..orderBy([(a) => OrderingTerm.asc(a.label)]))
        .watch();
  }

  // Get account by ID
  Future<Account?> getAccountById(String accountId) {
    return (_db.select(_db.accounts)..where((a) => a.id.equals(accountId)))
        .getSingleOrNull();
  }

  // Watch single account by ID
  Stream<Account?> watchAccountById(String accountId) {
    return (_db.select(_db.accounts)..where((a) => a.id.equals(accountId)))
        .watchSingleOrNull();
  }

  // Create Service
  Future<String> createService({
    String? id,
    required String name,
    required String category,
    required String colorHex,
    String? url,
    String? iconKey,
    int? sortOrder,
  }) async {
    final serviceId = id ?? _uuid.v4();
    final now = DateTime.now();

    int order = sortOrder ?? 0;
    if (sortOrder == null) {
      final all = await (_db.selectOnly(_db.services)
            ..addColumns([_db.services.sortOrder.max()]))
          .getSingleOrNull();
      final maxOrder = all?.read(_db.services.sortOrder.max()) ?? 0;
      order = maxOrder + 1;
    }

    await _db.into(_db.services).insert(
          ServicesCompanion(
            id: Value(serviceId),
            name: Value(name),
            category: Value(category),
            colorHex: Value(colorHex),
            url: Value(url),
            iconKey: Value(iconKey),
            sortOrder: Value(order),
            createdAt: Value(now),
            updatedAt: Value(now),
          ),
        );
    return serviceId;
  }

  // Reorder Services
  Future<void> reorderServices(List<String> serviceIds) async {
    await _db.transaction(() async {
      final allServices = await (_db.select(_db.services)
            ..orderBy([
              (s) => OrderingTerm.asc(s.sortOrder),
              (s) => OrderingTerm.asc(s.name),
            ]))
          .get();

      if (serviceIds.length == allServices.length) {
        for (int i = 0; i < serviceIds.length; i++) {
          await (_db.update(_db.services)..where((s) => s.id.equals(serviceIds[i])))
              .write(
            ServicesCompanion(
              sortOrder: Value(i),
              updatedAt: Value(DateTime.now()),
            ),
          );
        }
      } else {
        // Subset reordering (e.g. inside a category filter)
        final subsetItems =
            allServices.where((s) => serviceIds.contains(s.id)).toList();
        final availableOrders =
            subsetItems.map((s) => s.sortOrder).toList()..sort();

        for (int i = 0; i < serviceIds.length; i++) {
          final targetOrder =
              i < availableOrders.length ? availableOrders[i] : i;
          await (_db.update(_db.services)..where((s) => s.id.equals(serviceIds[i])))
              .write(
            ServicesCompanion(
              sortOrder: Value(targetOrder),
              updatedAt: Value(DateTime.now()),
            ),
          );
        }
      }
    });
  }

  // Update Service
  Future<void> updateService({
    required String id,
    required String name,
    required String category,
    required String colorHex,
    String? url,
    String? iconKey,
  }) async {
    final now = DateTime.now();
    await (_db.update(_db.services)..where((s) => s.id.equals(id))).write(
      ServicesCompanion(
        name: Value(name),
        category: Value(category),
        colorHex: Value(colorHex),
        url: Value(url),
        iconKey: Value(iconKey),
        updatedAt: Value(now),
      ),
    );
  }

  // Delete Service (cascades to accounts)
  Future<void> deleteService(String serviceId) async {
    await (_db.delete(_db.accounts)..where((a) => a.serviceId.equals(serviceId))).go();
    await (_db.delete(_db.services)..where((s) => s.id.equals(serviceId))).go();
  }

  // Create Account
  Future<String> createAccount({
    String? id,
    required String serviceId,
    required String label,
    String? username,
    String? email,
    required String password,
    String? recoveryCode,
    String? note,
  }) async {
    final accountId = id ?? _uuid.v4();
    final now = DateTime.now();
    await _db.into(_db.accounts).insert(
          AccountsCompanion(
            id: Value(accountId),
            serviceId: Value(serviceId),
            label: Value(label),
            username: Value(username),
            email: Value(email),
            password: Value(password),
            recoveryCode: Value(recoveryCode),
            note: Value(note),
            createdAt: Value(now),
            updatedAt: Value(now),
          ),
        );
    return accountId;
  }

  // Update Account
  Future<void> updateAccount({
    required String id,
    required String serviceId,
    required String label,
    String? username,
    String? email,
    required String password,
    String? recoveryCode,
    String? note,
  }) async {
    final now = DateTime.now();
    await (_db.update(_db.accounts)..where((a) => a.id.equals(id))).write(
      AccountsCompanion(
        serviceId: Value(serviceId),
        label: Value(label),
        username: Value(username),
        email: Value(email),
        password: Value(password),
        recoveryCode: Value(recoveryCode),
        note: Value(note),
        updatedAt: Value(now),
      ),
    );
  }

  // Delete Account
  Future<void> deleteAccount(String accountId) async {
    await (_db.delete(_db.accounts)..where((a) => a.id.equals(accountId))).go();
  }

  // Search across services and accounts
  Future<SearchResults> search(String query) async {
    final cleanQuery = query.trim().toLowerCase();
    if (cleanQuery.isEmpty) {
      return const SearchResults(services: [], accounts: []);
    }

    // Find services
    final allServices = await getServices();
    final matchedServices = allServices.where((s) {
      return s.service.name.toLowerCase().contains(cleanQuery) ||
          s.service.category.toLowerCase().contains(cleanQuery);
    }).toList();

    // Find accounts
    final allAccounts = await _db.select(_db.accounts).get();
    final serviceMap = {for (var s in allServices) s.service.id: s.service};

    final matchedAccounts = <AccountWithService>[];
    for (final acc in allAccounts) {
      final labelMatch = acc.label.toLowerCase().contains(cleanQuery);
      final userMatch = acc.username?.toLowerCase().contains(cleanQuery) ?? false;
      final emailMatch = acc.email?.toLowerCase().contains(cleanQuery) ?? false;

      if (labelMatch || userMatch || emailMatch) {
        final service = serviceMap[acc.serviceId];
        if (service != null) {
          matchedAccounts.add(AccountWithService(account: acc, service: service));
        }
      }
    }

    return SearchResults(
      services: matchedServices,
      accounts: matchedAccounts,
    );
  }

  // Calculate Security Summary
  Stream<SecuritySummary> watchSecuritySummary() {
    return watchServices().map((services) {
      final totalServices = services.length;
      final allAccounts = services.expand((s) => s.accounts).toList();
      final totalAccounts = allAccounts.length;

      if (totalAccounts == 0) {
        return SecuritySummary(
          totalAccounts: 0,
          totalServices: totalServices,
          safeScorePercent: 100,
        );
      }

      int totalScore = 0;
      for (final acc in allAccounts) {
        final eval = PasswordStrengthEvaluator.evaluate(acc.password);
        switch (eval.strength) {
          case PasswordStrength.veryStrong:
            totalScore += 100;
            break;
          case PasswordStrength.strong:
            totalScore += 90;
            break;
          case PasswordStrength.fair:
            totalScore += 65;
            break;
          case PasswordStrength.weak:
            totalScore += 30;
            break;
        }
      }

      final scorePercent = (totalScore / totalAccounts).round();
      return SecuritySummary(
        totalAccounts: totalAccounts,
        totalServices: totalServices,
        safeScorePercent: scorePercent.clamp(0, 100),
      );
    });
  }

  // Seed sample data for debug/initial run
  Future<void> seedDebugData({bool force = false}) async {
    final existingServices = await (_db.select(_db.services)).get();
    if (existingServices.isNotEmpty && !force) {
      return;
    }

    if (force) {
      await _db.delete(_db.accounts).go();
      await _db.delete(_db.services).go();
    }

    // 1. Steam
    final steamId = await createService(
      name: 'Steam',
      category: 'Game',
      colorHex: '#0284C7',
      url: 'https://store.steampowered.com',
      iconKey: 'steam',
    );
    await createAccount(
      serviceId: steamId,
      label: 'Akun Utama (CS2 & Dota)',
      username: 'luthfi_steam',
      email: 'luthfi.pro@gmail.com',
      password: r'Tr0ng#P@ss2026!kL',
      recoveryCode: 'R8492-X9812-KL09',
      note: 'Steam Guard aktif di HP Samsung. Jangan lupa simpan recovery code sebelum format HP.',
    );
    await createAccount(
      serviceId: steamId,
      label: 'Akun Smurf & Casual',
      username: 'smurf_casual',
      email: 'smurf@mail.com',
      password: r'Smurf#991!Casual2026',
      note: 'Hanya untuk main party santai bareng teman.',
    );
    await createAccount(
      serviceId: steamId,
      label: 'Akun Trading & Inventori',
      username: 'steam_trader_id',
      email: 'trader.steam@gmail.com',
      password: r'Tr@d3r_Inv$2026_Secure',
      recoveryCode: 'T9921-ZZ762-LK88',
      note: 'Simpan item skin langka dan trade hold guard.',
    );
    await createAccount(
      serviceId: steamId,
      label: 'Akun Cadangan Game Region US',
      username: 'us_region_buyer',
      email: 'us.buyer@gmail.com',
      password: r'US_G@m3s#Wallet2026',
      note: 'Khusus beli game bundle region US.',
    );

    // 2. Discord
    final discordId = await createService(
      name: 'Discord',
      category: 'Sosial',
      colorHex: '#4F46E5',
      url: 'https://discord.com',
      iconKey: 'discord',
    );
    await createAccount(
      serviceId: discordId,
      label: 'Akun Komunitas Game',
      username: 'luthfi#0001',
      email: 'luthfi.pro@gmail.com',
      password: r'Disc0rd#V@ult2026!Pro',
      note: 'Moderator di 5 server komunitas developer dan gaming.',
    );
    await createAccount(
      serviceId: discordId,
      label: 'Akun Bot Manager',
      username: 'bot_manager_discord',
      email: 'bot.dev@outlook.com',
      password: r'B0t_M@nager#T0k3n_2026',
      note: 'Khusus mengelola Discord Bot API key & server webhook.',
    );
    await createAccount(
      serviceId: discordId,
      label: 'Akun Kerja Freelance',
      username: 'luthfi_freelance',
      email: 'luthfi.work@gmail.com',
      password: r'Freelance#Work!2026_Dc',
      note: 'Komunikasi proyek klien luar negeri.',
    );

    // 3. Google
    final googleId = await createService(
      name: 'Google',
      category: 'Kerja',
      colorHex: '#DC2626',
      url: 'https://google.com',
      iconKey: 'google',
    );
    await createAccount(
      serviceId: googleId,
      label: 'Email Utama & Drive Cloud',
      username: 'luthfi.pro',
      email: 'luthfi.pro@gmail.com',
      password: r'G00gle#M@st3r!Pass992',
      recoveryCode: '8291 9921 4410 8821',
      note: 'Akun Gmail utama, foto backup, dan Play Store.',
    );
    await createAccount(
      serviceId: googleId,
      label: 'Akun Kerja / Kantor',
      username: 'luthfi_office',
      email: 'luthfi@company.com',
      password: r'W0rk#Corp2026_Pass91!',
      recoveryCode: '1092 8841 7721 9912',
      note: 'Google Workspace kantor, calendar meeting internal.',
    );
    await createAccount(
      serviceId: googleId,
      label: 'Akun Riset & Dev',
      username: 'dev_luthfi',
      email: 'dev.luthfi@gmail.com',
      password: r'D3v#GoogleCloud!2026',
      note: 'Akses Google Cloud Platform & Firebase console.',
    );

    // 4. Epic Games Store
    final epicId = await createService(
      name: 'Epic Games Store',
      category: 'Game',
      colorHex: '#0F172A',
      url: 'https://store.epicgames.com',
      iconKey: 'epic_games',
    );
    await createAccount(
      serviceId: epicId,
      label: 'Akun Unreal & Dev',
      username: 'epic_luthfi',
      email: 'luthfi.epic@gmail.com',
      password: r'Unre@l#Eng1ne_2026!',
      note: 'Asset library Unreal Engine 5 & claim mingguan.',
    );
    await createAccount(
      serviceId: epicId,
      label: 'Akun Free Games Vault',
      username: 'freebie_hunter',
      email: 'freebie@gmail.com',
      password: r'Fr33Bie#Epic_Claim2026',
      note: 'Koleksi ratusan game gratis mingguan.',
    );

    // 5. GitHub
    final gitHubId = await createService(
      name: 'GitHub',
      category: 'Kerja',
      colorHex: '#0284C7',
      url: 'https://github.com',
    );
    await createAccount(
      serviceId: gitHubId,
      label: 'Akun Personal Developer',
      username: 'luthfi-dev',
      email: 'dev@luthfi.pro',
      password: r'G1tHub#SSH_K3y!2026_Sec',
      recoveryCode: 'GH-8941-K992-L881',
      note: 'SSH key terhubung ke laptop kerja & desktop rumah.',
    );
    await createAccount(
      serviceId: gitHubId,
      label: 'Akun Kontributor Open Source',
      username: 'luthfi-oss',
      email: 'oss@luthfi.pro',
      password: r'OSS_C0ntrib#G1t2026!',
      note: 'PR & issue repository public.',
    );

    // 6. Spotify
    final spotifyId = await createService(
      name: 'Spotify',
      category: 'Hiburan',
      colorHex: '#16A34A',
      url: 'https://spotify.com',
    );
    await createAccount(
      serviceId: spotifyId,
      label: 'Akun Family Plan',
      username: 'luthfi_music',
      email: 'music.luthfi@gmail.com',
      password: r'Sp0t1fy#Music!2026_High',
      note: 'Plan Family admin, playlist coding lo-fi.',
    );
    await createAccount(
      serviceId: spotifyId,
      label: 'Akun Podcast Creator',
      username: 'podcast_host',
      email: 'pod@luthfi.pro',
      password: r'P0dc@st#Sp0t2026!Studio',
      note: 'Spotify for Podcasters management.',
    );

    // 7. Riot Games
    final riotId = await createService(
      name: 'Riot Games',
      category: 'Game',
      colorHex: '#DC2626',
      url: 'https://riotgames.com',
      iconKey: 'riot_games',
    );
    await createAccount(
      serviceId: riotId,
      label: 'Akun Valorant Immortal',
      username: 'luthfi#ID1',
      email: 'riot.luthfi@gmail.com',
      password: r'V@l0rant#Imm0rt@l2026!',
      note: 'Rank Immortal, 2FA via Riot Mobile.',
    );
    await createAccount(
      serviceId: riotId,
      label: 'Akun League of Legends',
      username: 'luthfi_lol',
      email: 'lol.luthfi@gmail.com',
      password: r'Le@gue#R1ot_2026!Game',
      note: 'Server SEA / Singapore.',
    );

    // 8. Shopee
    final shopeeId = await createService(
      name: 'Shopee',
      category: 'Keuangan',
      colorHex: '#EE4D2D',
      url: 'https://shopee.co.id',
      iconKey: 'shopee',
    );
    await createAccount(
      serviceId: shopeeId,
      label: 'Akun Belanja & SPayLater',
      username: 'luthfi_shop',
      email: 'shopee.luthfi@gmail.com',
      password: r'Sh0p33#V@ult2026!Safe',
      note: 'Terhubung ke SPayLater & SeaBank.',
    );

    // 9. Ubisoft
    final ubisoftId = await createService(
      name: 'Ubisoft Connect',
      category: 'Game',
      colorHex: '#0070FF',
      url: 'https://ubisoftconnect.com',
      iconKey: 'ubisoft',
    );
    await createAccount(
      serviceId: ubisoftId,
      label: 'Akun R6 Siege & Assassin Creed',
      username: 'ubi_luthfi',
      email: 'ubisoft.luthfi@gmail.com',
      password: r'Ub1s0ft#Conn3ct!2026',
      note: '2FA via Google Authenticator.',
    );

    // 10. Genshin Impact
    final genshinId = await createService(
      name: 'Genshin Impact',
      category: 'Game',
      colorHex: '#0D9488',
      url: 'https://hoyoverse.com',
      iconKey: 'genshin_impact',
    );
    await createAccount(
      serviceId: genshinId,
      label: 'Akun HoYoverse Utama (AR 60)',
      username: 'traveler_luthfi',
      email: 'genshin.luthfi@gmail.com',
      password: r'Pr1m0g3m#H0y02026!',
      note: 'Server Asia, UID 800192881.',
    );

    // 11. Roblox
    final robloxId = await createService(
      name: 'Roblox',
      category: 'Game',
      colorHex: '#334155',
      url: 'https://roblox.com',
      iconKey: 'roblox',
    );
    await createAccount(
      serviceId: robloxId,
      label: 'Akun Roblox Studio Dev',
      username: 'block_builder_id',
      email: 'roblox.dev@gmail.com',
      password: r'R0bl0x#Bl0ck!2026Studio',
      note: 'Creator Dashboard & game asset library.',
    );

    // 12. Point Blank
    final pbId = await createService(
      name: 'Point Blank',
      category: 'Game',
      colorHex: '#B91C1C',
      url: 'https://pointblank.id',
      iconKey: 'point_blank',
    );
    await createAccount(
      serviceId: pbId,
      label: 'Akun Mayor 1 Grade 4',
      username: 'pb_trooper_id',
      email: 'trooper.pb@gmail.com',
      password: r'P01ntBl@nk#Zepetto2026!',
      note: 'Clan Master, title sniper full unlock.',
    );

    // 13. EA (Electronic Arts)
    final eaId = await createService(
      name: 'EA App',
      category: 'Game',
      colorHex: '#E11D48',
      url: 'https://ea.com',
      iconKey: 'ea',
    );
    await createAccount(
      serviceId: eaId,
      label: 'Akun EA Play & Apex Legends',
      username: 'apex_champion_id',
      email: 'ea.luthfi@gmail.com',
      password: r'E@Sp0rts#Ap3x_2026!',
      note: 'Langganan EA Play Pro & cross-progression Apex.',
    );

    // 14. Netflix
    final netflixId = await createService(
      name: 'Netflix',
      category: 'Hiburan',
      colorHex: '#D97706',
      url: 'https://netflix.com',
    );
    await createAccount(
      serviceId: netflixId,
      label: 'Akun Keluarga Premium 4K',
      username: 'family_netflix',
      email: 'luthfi.family@gmail.com',
      password: r'N3tfl1x#Pr3m1um_4K!2026',
      note: 'Langganan 4 layar aktif per bulan.',
    );
    await createAccount(
      serviceId: netflixId,
      label: 'Akun Profile Pribadi',
      username: 'luthfi_watch',
      email: 'luthfi.personal@gmail.com',
      password: r'W@tch_N3t#Pers0nal2026',
      note: 'Profil PIN terkunci 1234.',
    );
  }
}
