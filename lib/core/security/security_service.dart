import 'dart:convert';
import 'dart:math';
import 'package:cryptography/cryptography.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';

class SecurityService {
  SecurityService({
    FlutterSecureStorage? secureStorage,
    LocalAuthentication? localAuth,
  })  : _secureStorage = secureStorage ?? const FlutterSecureStorage(),
        _localAuth = localAuth ?? LocalAuthentication();

  final FlutterSecureStorage _secureStorage;
  final LocalAuthentication _localAuth;

  static const String _keyPinHash = 'brankas_pin_hash';
  static const String _keyPinSalt = 'brankas_pin_salt';
  static const String _keyBiometricEnabled = 'brankas_biometric_enabled';
  static const String _keyAutoLockDuration = 'brankas_autolock_duration'; // 'Segera', '1 Menit', '5 Menit', '15 Menit'
  static const String _keyClipboardDuration = 'brankas_clipboard_duration'; // 30, 60, 120, 0 (never)
  static const String _keyAppLocale = 'brankas_app_locale'; // 'id', 'en', or null (system)

  final _pbkdf2 = Pbkdf2(
    macAlgorithm: Hmac.sha256(),
    iterations: 100000,
    bits: 256,
  );

  // Check if Master PIN is set
  Future<bool> hasMasterPin() async {
    final hash = await _secureStorage.read(key: _keyPinHash);
    return hash != null && hash.isNotEmpty;
  }

  // Set Master PIN
  Future<void> setMasterPin(String pin) async {
    // Generate random 16-byte salt
    final random = Random.secure();
    final saltBytes = List<int>.generate(16, (_) => random.nextInt(256));
    final saltBase64 = base64UrlEncode(saltBytes);

    final secretKey = await _pbkdf2.deriveKeyFromPassword(
      password: pin,
      nonce: saltBytes,
    );
    final hashBytes = await secretKey.extractBytes();
    final hashBase64 = base64UrlEncode(hashBytes);

    await _secureStorage.write(key: _keyPinSalt, value: saltBase64);
    await _secureStorage.write(key: _keyPinHash, value: hashBase64);
  }

  // Verify Master PIN
  Future<bool> verifyMasterPin(String pin) async {
    final savedHash = await _secureStorage.read(key: _keyPinHash);
    final savedSalt = await _secureStorage.read(key: _keyPinSalt);

    if (savedHash == null || savedSalt == null) {
      return false;
    }

    try {
      final saltBytes = base64Url.decode(savedSalt);
      final secretKey = await _pbkdf2.deriveKeyFromPassword(
        password: pin,
        nonce: saltBytes,
      );
      final hashBytes = await secretKey.extractBytes();
      final hashBase64 = base64UrlEncode(hashBytes);

      return hashBase64 == savedHash;
    } catch (_) {
      return false;
    }
  }

  // Check if biometric is available on this hardware
  Future<bool> isBiometricAvailable() async {
    try {
      final canCheck = await _localAuth.canCheckBiometrics;
      final isSupported = await _localAuth.isDeviceSupported();
      return canCheck || isSupported;
    } catch (_) {
      return false;
    }
  }

  // Check if biometric is enabled by user
  Future<bool> isBiometricEnabled() async {
    final val = await _secureStorage.read(key: _keyBiometricEnabled);
    if (val == null) {
      // Default enabled if device supports it
      return true;
    }
    return val == 'true';
  }

  // Enable/Disable biometric
  Future<void> setBiometricEnabled(bool enabled) async {
    await _secureStorage.write(
        key: _keyBiometricEnabled, value: enabled ? 'true' : 'false');
  }

  // Authenticate with biometric
  Future<bool> authenticateWithBiometrics({
    String? localizedReason,
    String? signInTitle,
    String? signInHint,
    String? cancelButton,
  }) async {
    try {
      final available = await isBiometricAvailable();
      if (!available) return false;

      return await _localAuth.authenticate(
        localizedReason: localizedReason ??
            'Pindai sidik jari atau biometrik untuk membuka SafeDeck',
        biometricOnly: false,
        persistAcrossBackgrounding: true,
        authMessages: <AuthMessages>[
          AndroidAuthMessages(
            signInTitle: signInTitle ?? 'Buka Kunci SafeDeck',
            signInHint: signInHint ?? 'Sentuh sensor sidik jari',
            cancelButton: cancelButton ?? 'Gunakan PIN',
          ),
        ],
      );
    } catch (e) {
      debugPrint('Biometric authentication error: $e');
      return false;
    }
  }

  // Auto-lock setting: 'Segera', '1 Menit', '5 Menit', '15 Menit'
  Future<String> getAutoLockDuration() async {
    final val = await _secureStorage.read(key: _keyAutoLockDuration);
    return val ?? 'Segera';
  }

  Future<void> setAutoLockDuration(String duration) async {
    await _secureStorage.write(key: _keyAutoLockDuration, value: duration);
  }

  Duration parseAutoLockDuration(String durationStr) {
    switch (durationStr) {
      case '1 Menit':
        return const Duration(minutes: 1);
      case '5 Menit':
        return const Duration(minutes: 5);
      case '15 Menit':
        return const Duration(minutes: 15);
      case 'Segera':
      default:
        return Duration.zero;
    }
  }

  // Clipboard setting in seconds: default 30
  Future<int> getClipboardDurationSeconds() async {
    final val = await _secureStorage.read(key: _keyClipboardDuration);
    return val != null ? int.tryParse(val) ?? 30 : 30;
  }

  Future<void> setClipboardDurationSeconds(int seconds) async {
    await _secureStorage.write(key: _keyClipboardDuration, value: seconds.toString());
  }

  // App locale preference: 'id', 'en', or null (follow system)
  Future<String?> getAppLocaleCode() async {
    final val = await _secureStorage.read(key: _keyAppLocale);
    if (val == 'id' || val == 'en') return val;
    return null;
  }

  Future<void> setAppLocaleCode(String? code) async {
    if (code == null || code.isEmpty) {
      await _secureStorage.delete(key: _keyAppLocale);
    } else {
      await _secureStorage.write(key: _keyAppLocale, value: code);
    }
  }

  // Copy with auto-clear
  Future<void> copyToClipboard(String text, {int seconds = 30}) async {
    await Clipboard.setData(ClipboardData(text: text));
    if (seconds > 0) {
      Future.delayed(Duration(seconds: seconds), () async {
        final current = await Clipboard.getData('text/plain');
        if (current?.text == text) {
          await Clipboard.setData(const ClipboardData(text: ''));
        }
      });
    }
  }
}
