import 'package:flutter_test/flutter_test.dart';
import 'package:password_management_apps/core/utils/password_generator.dart';

void main() {
  group('PasswordGenerator Tests', () {
    test('Generates password with default 16 characters', () {
      final pwd = PasswordGenerator.generate();
      expect(pwd.length, 16);
      expect(RegExp(r'[A-Z]').hasMatch(pwd), isTrue);
      expect(RegExp(r'[a-z]').hasMatch(pwd), isTrue);
      expect(RegExp(r'[0-9]').hasMatch(pwd), isTrue);
    });

    test('Generates requested length between 8 and 64', () {
      final pwd8 = PasswordGenerator.generate(
        const PasswordGeneratorOptions(length: 8),
      );
      expect(pwd8.length, 8);

      final pwd32 = PasswordGenerator.generate(
        const PasswordGeneratorOptions(length: 32),
      );
      expect(pwd32.length, 32);
    });

    test('Avoids ambiguous characters when option enabled', () {
      const options = PasswordGeneratorOptions(
        length: 64,
        avoidAmbiguous: true,
      );
      for (int i = 0; i < 10; i++) {
        final pwd = PasswordGenerator.generate(options);
        expect(pwd.contains('i'), isFalse);
        expect(pwd.contains('l'), isFalse);
        expect(pwd.contains('1'), isFalse);
        expect(pwd.contains('0'), isFalse);
        expect(pwd.contains('O'), isFalse);
        expect(pwd.contains('o'), isFalse);
      }
    });
  });
}
