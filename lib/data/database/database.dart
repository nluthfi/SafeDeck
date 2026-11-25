import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'database.g.dart';

class Services extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get category => text()();
  TextColumn get colorHex => text()();
  TextColumn get url => text().nullable()();
  TextColumn get iconKey => text().nullable()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class Accounts extends Table {
  TextColumn get id => text()();
  TextColumn get serviceId =>
      text().references(Services, #id, onDelete: KeyAction.cascade)();
  TextColumn get label => text()();
  TextColumn get username => text().nullable()();
  TextColumn get email => text().nullable()();
  TextColumn get password => text()();
  TextColumn get recoveryCode => text().nullable()();
  TextColumn get note => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [Services, Accounts])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? e]) : super(e ?? _defaultExecutor());

  AppDatabase.inMemory() : super(NativeDatabase.memory());

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.addColumn(services, services.iconKey);
          }
          if (from < 3) {
            await m.addColumn(services, services.sortOrder);
          }
        },
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON;');
        },
      );

  static QueryExecutor _defaultExecutor() {
    return LazyDatabase(() async {
      try {
        const secureStorage = FlutterSecureStorage();
        String? dbKey = await secureStorage.read(key: 'brankas_vault_key');
        if (dbKey == null) {
          final randomBytes =
              List<int>.generate(32, (_) => Random.secure().nextInt(256));
          dbKey = base64UrlEncode(randomBytes);
          await secureStorage.write(key: 'brankas_vault_key', value: dbKey);
        }

        final dbFolder = await getApplicationDocumentsDirectory();
        final file = File(p.join(dbFolder.path, 'brankas_vault.db'));

        return NativeDatabase.createInBackground(
          file,
          setup: (rawDb) {
            try {
              // Apply SQLCipher encryption key
              rawDb.execute("PRAGMA key = '$dbKey';");
            } catch (_) {
              // Fallback if SQLCipher pragma is not supported on some platforms
            }
          },
        );
      } catch (_) {
        // Fallback for desktop/test run without platform secure storage
        return NativeDatabase.memory();
      }
    });
  }
}
