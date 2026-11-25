import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:cryptography/cryptography.dart';
import '../../data/repositories/vault_repository.dart';

class BackupService {
  final _pbkdf2 = Pbkdf2(
    macAlgorithm: Hmac.sha256(),
    iterations: 100000,
    bits: 256,
  );
  final _aesGcm = AesGcm.with256bits();

  Future<File> exportEncryptedBackup({
    required VaultRepository repository,
    required String password,
  }) async {
    // 1. Gather all services and accounts
    final servicesWithAccounts = await repository.getServices();
    final servicesList = servicesWithAccounts.map((s) => {
      'id': s.service.id,
      'name': s.service.name,
      'category': s.service.category,
      'colorHex': s.service.colorHex,
      'url': s.service.url,
      'iconKey': s.service.iconKey,
      'createdAt': s.service.createdAt.toIso8601String(),
      'updatedAt': s.service.updatedAt.toIso8601String(),
    }).toList();

    final accountsList = servicesWithAccounts.expand((s) => s.accounts).map((a) => {
      'id': a.id,
      'serviceId': a.serviceId,
      'label': a.label,
      'username': a.username,
      'email': a.email,
      'password': a.password,
      'recoveryCode': a.recoveryCode,
      'note': a.note,
      'createdAt': a.createdAt.toIso8601String(),
      'updatedAt': a.updatedAt.toIso8601String(),
    }).toList();

    final payload = jsonEncode({
      'services': servicesList,
      'accounts': accountsList,
    });

    // 2. Derive key from user password
    final random = Random.secure();
    final saltBytes = List<int>.generate(16, (_) => random.nextInt(256));
    final nonce = _aesGcm.newNonce();

    final secretKey = await _pbkdf2.deriveKeyFromPassword(
      password: password,
      nonce: saltBytes,
    );

    // 3. Encrypt payload
    final secretBox = await _aesGcm.encrypt(
      utf8.encode(payload),
      secretKey: secretKey,
      nonce: nonce,
    );

    // 4. Construct wrapper envelope
    final envelope = {
      'app': 'Brankas',
      'version': 1,
      'exportedAt': DateTime.now().toIso8601String(),
      'kdf': {
        'algorithm': 'PBKDF2-HMAC-SHA256',
        'iterations': 100000,
        'salt': base64UrlEncode(saltBytes),
      },
      'cipher': {
        'algorithm': 'AES-256-GCM',
        'nonce': base64UrlEncode(secretBox.nonce),
        'ciphertext': base64UrlEncode(secretBox.cipherText),
        'mac': base64UrlEncode(secretBox.mac.bytes),
      },
    };

    final tempDir = Directory.systemTemp;
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final file = File('${tempDir.path}/brankas_backup_$timestamp.brankas');
    await file.writeAsString(jsonEncode(envelope));
    return file;
  }

  Future<int> importEncryptedBackup({
    required VaultRepository repository,
    required String filePath,
    required String password,
  }) async {
    final file = File(filePath);
    if (!await file.exists()) {
      throw Exception('File cadangan tidak ditemukan.');
    }

    final content = await file.readAsString();
    final Map<String, dynamic> envelope;
    try {
      envelope = jsonDecode(content) as Map<String, dynamic>;
    } catch (_) {
      throw Exception('Format file cadangan tidak valid.');
    }

    if (envelope['app'] != 'Brankas') {
      throw Exception('File ini bukan file cadangan Brankas yang sah.');
    }

    final version = envelope['version'] as int? ?? 1;
    if (version > 1) {
      throw Exception('Versi file cadangan ($version) lebih tinggi dari versi aplikasi saat ini.');
    }

    final kdf = envelope['kdf'] as Map<String, dynamic>;
    final cipher = envelope['cipher'] as Map<String, dynamic>;

    final saltBytes = base64Url.decode(kdf['salt'] as String);
    final nonceBytes = base64Url.decode(cipher['nonce'] as String);
    final cipherTextBytes = base64Url.decode(cipher['ciphertext'] as String);
    final macBytes = base64Url.decode(cipher['mac'] as String);

    // Derive key from password
    final secretKey = await _pbkdf2.deriveKeyFromPassword(
      password: password,
      nonce: saltBytes,
    );

    final secretBox = SecretBox(
      cipherTextBytes,
      nonce: nonceBytes,
      mac: Mac(macBytes),
    );

    final List<int> decryptedBytes;
    try {
      decryptedBytes = await _aesGcm.decrypt(secretBox, secretKey: secretKey);
    } catch (_) {
      throw Exception('Kata sandi cadangan salah atau file telah rusak.');
    }

    final decryptedJson = jsonDecode(utf8.decode(decryptedBytes)) as Map<String, dynamic>;
    final services = decryptedJson['services'] as List<dynamic>;
    final accounts = decryptedJson['accounts'] as List<dynamic>;

    // Restore to repository
    for (final s in services) {
      final sMap = s as Map<String, dynamic>;
      // Check if service already exists
      final existing = await repository.getServiceById(sMap['id'] as String);
      if (existing == null) {
        await repository.createService(
          id: sMap['id'] as String,
          name: sMap['name'] as String,
          category: sMap['category'] as String,
          colorHex: sMap['colorHex'] as String,
          url: sMap['url'] as String?,
          iconKey: sMap['iconKey'] as String?,
        );
      }
    }

    int importedCount = 0;
    for (final a in accounts) {
      final aMap = a as Map<String, dynamic>;
      await repository.createAccount(
        id: aMap['id'] as String,
        serviceId: aMap['serviceId'] as String,
        label: aMap['label'] as String,
        username: aMap['username'] as String?,
        email: aMap['email'] as String?,
        password: aMap['password'] as String,
        recoveryCode: aMap['recoveryCode'] as String?,
        note: aMap['note'] as String?,
      );
      importedCount++;
    }

    return importedCount;
  }
}
