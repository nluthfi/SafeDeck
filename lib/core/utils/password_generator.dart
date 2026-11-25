import 'dart:math';

class PasswordGeneratorOptions {
  const PasswordGeneratorOptions({
    this.length = 16,
    this.includeUpper = true,
    this.includeLower = true,
    this.includeNumbers = true,
    this.includeSymbols = true,
    this.avoidAmbiguous = false,
  });

  final int length;
  final bool includeUpper;
  final bool includeLower;
  final bool includeNumbers;
  final bool includeSymbols;
  final bool avoidAmbiguous;

  PasswordGeneratorOptions copyWith({
    int? length,
    bool? includeUpper,
    bool? includeLower,
    bool? includeNumbers,
    bool? includeSymbols,
    bool? avoidAmbiguous,
  }) {
    return PasswordGeneratorOptions(
      length: length ?? this.length,
      includeUpper: includeUpper ?? this.includeUpper,
      includeLower: includeLower ?? this.includeLower,
      includeNumbers: includeNumbers ?? this.includeNumbers,
      includeSymbols: includeSymbols ?? this.includeSymbols,
      avoidAmbiguous: avoidAmbiguous ?? this.avoidAmbiguous,
    );
  }
}

class PasswordGenerator {
  static const String _upperChars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  static const String _lowerChars = 'abcdefghijklmnopqrstuvwxyz';
  static const String _numberChars = '0123456789';
  static const String _symbolChars = '!@#\$%^&*()_+-=[]{}|;:,.<>?';

  static const String _ambiguousChars = 'il1I0Oo';

  static String generate([PasswordGeneratorOptions options = const PasswordGeneratorOptions()]) {
    String upper = _upperChars;
    String lower = _lowerChars;
    String numbers = _numberChars;
    String symbols = _symbolChars;

    if (options.avoidAmbiguous) {
      upper = upper.replaceAll(RegExp('[$_ambiguousChars]'), '');
      lower = lower.replaceAll(RegExp('[$_ambiguousChars]'), '');
      numbers = numbers.replaceAll(RegExp('[$_ambiguousChars]'), '');
    }

    final pools = <String>[];
    final guaranteed = <String>[];
    final random = Random.secure();

    if (options.includeUpper && upper.isNotEmpty) {
      pools.add(upper);
      guaranteed.add(upper[random.nextInt(upper.length)]);
    }
    if (options.includeLower && lower.isNotEmpty) {
      pools.add(lower);
      guaranteed.add(lower[random.nextInt(lower.length)]);
    }
    if (options.includeNumbers && numbers.isNotEmpty) {
      pools.add(numbers);
      guaranteed.add(numbers[random.nextInt(numbers.length)]);
    }
    if (options.includeSymbols && symbols.isNotEmpty) {
      pools.add(symbols);
      guaranteed.add(symbols[random.nextInt(symbols.length)]);
    }

    if (pools.isEmpty) {
      // Fallback if user unchecks all
      pools.add(lower);
      guaranteed.add(lower[random.nextInt(lower.length)]);
    }

    final allChars = pools.join();
    final result = List<String>.from(guaranteed);

    while (result.length < options.length) {
      result.add(allChars[random.nextInt(allChars.length)]);
    }

    // Shuffle using Fisher-Yates with secure random
    for (int i = result.length - 1; i > 0; i--) {
      final n = random.nextInt(i + 1);
      final temp = result[i];
      result[i] = result[n];
      result[n] = temp;
    }

    return result.join();
  }
}
