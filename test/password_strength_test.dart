import 'package:flutter_test/flutter_test.dart';
import 'package:password_management_apps/core/widgets/strength_indicator.dart';

void main() {
  group('PasswordStrengthEvaluator Tests', () {
    test('Empty password returns weak', () {
      final res = PasswordStrengthEvaluator.evaluate('');
      expect(res.strength, PasswordStrength.weak);
      expect(res.score, 0);
    });

    test('Short simple password returns weak', () {
      final res = PasswordStrengthEvaluator.evaluate('12345');
      expect(res.strength, PasswordStrength.weak);
      expect(res.score, 1);
      expect(res.label, 'Lemah');
    });

    test('8-character simple alphanumeric returns fair', () {
      final res = PasswordStrengthEvaluator.evaluate('Password123');
      expect(res.strength, PasswordStrength.fair);
      expect(res.score, 2);
      expect(res.label, 'Sedang');
    });

    test('12-character mixed case, number returns strong', () {
      final res = PasswordStrengthEvaluator.evaluate('SecurePassword2026');
      expect(res.strength, PasswordStrength.strong);
      expect(res.score, 3);
      expect(res.label, 'Kuat');
    });

    test('Complex with special characters returns very strong', () {
      final res = PasswordStrengthEvaluator.evaluate(r'Tr0ng#P@ss2026!kL');
      expect(res.strength, PasswordStrength.veryStrong);
      expect(res.score, 4);
      expect(res.label, 'Sangat Kuat');
    });
  });
}
