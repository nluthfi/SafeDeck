import 'package:flutter_test/flutter_test.dart';
import 'package:cryptography/cryptography.dart';
import 'dart:convert';

void main() {
  test('PBKDF2 derives deterministic key for same PIN and salt', () async {
    final pbkdf2 = Pbkdf2(
      macAlgorithm: Hmac.sha256(),
      iterations: 10000,
      bits: 256,
    );

    final salt = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16];
    const pin = '123456';

    final key1 = await pbkdf2.deriveKeyFromPassword(password: pin, nonce: salt);
    final bytes1 = await key1.extractBytes();

    final key2 = await pbkdf2.deriveKeyFromPassword(password: pin, nonce: salt);
    final bytes2 = await key2.extractBytes();

    expect(base64UrlEncode(bytes1), equals(base64UrlEncode(bytes2)));

    // Different PIN should yield different hash
    final keyWrong = await pbkdf2.deriveKeyFromPassword(password: '654321', nonce: salt);
    final bytesWrong = await keyWrong.extractBytes();
    expect(base64UrlEncode(bytes1), isNot(equals(base64UrlEncode(bytesWrong))));
  });
}
