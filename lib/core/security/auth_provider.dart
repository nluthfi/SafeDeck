import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'security_service.dart';

class AuthState {
  const AuthState({
    required this.isLocked,
    required this.hasMasterPin,
    required this.isBiometricEnabled,
    required this.isBiometricAvailable,
    required this.failedAttempts,
    this.lockoutUntil,
    required this.autoLockDuration,
    required this.clipboardDuration,
    required this.isLoading,
  });

  final bool isLocked;
  final bool hasMasterPin;
  final bool isBiometricEnabled;
  final bool isBiometricAvailable;
  final int failedAttempts;
  final DateTime? lockoutUntil;
  final String autoLockDuration;
  final int clipboardDuration;
  final bool isLoading;

  bool get isLockedOut {
    if (lockoutUntil == null) return false;
    return DateTime.now().isBefore(lockoutUntil!);
  }

  int get remainingLockoutSeconds {
    if (lockoutUntil == null) return 0;
    final diff = lockoutUntil!.difference(DateTime.now()).inSeconds;
    return diff > 0 ? diff : 0;
  }

  AuthState copyWith({
    bool? isLocked,
    bool? hasMasterPin,
    bool? isBiometricEnabled,
    bool? isBiometricAvailable,
    int? failedAttempts,
    DateTime? lockoutUntil,
    String? autoLockDuration,
    int? clipboardDuration,
    bool? isLoading,
  }) {
    return AuthState(
      isLocked: isLocked ?? this.isLocked,
      hasMasterPin: hasMasterPin ?? this.hasMasterPin,
      isBiometricEnabled: isBiometricEnabled ?? this.isBiometricEnabled,
      isBiometricAvailable: isBiometricAvailable ?? this.isBiometricAvailable,
      failedAttempts: failedAttempts ?? this.failedAttempts,
      lockoutUntil: lockoutUntil ?? this.lockoutUntil,
      autoLockDuration: autoLockDuration ?? this.autoLockDuration,
      clipboardDuration: clipboardDuration ?? this.clipboardDuration,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

final securityServiceProvider = Provider<SecurityService>((ref) {
  return SecurityService();
});

final authNotifierProvider =
    NotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);

class AuthNotifier extends Notifier<AuthState> {
  DateTime? _lastBackgroundTimestamp;
  Timer? _lockoutTimer;

  SecurityService get _security => ref.read(securityServiceProvider);

  @override
  AuthState build() {
    ref.onDispose(() {
      _lockoutTimer?.cancel();
    });

    // Schedule initial load
    Future.microtask(() => init());

    return const AuthState(
      isLocked: true,
      hasMasterPin: false,
      isBiometricEnabled: false,
      isBiometricAvailable: false,
      failedAttempts: 0,
      lockoutUntil: null,
      autoLockDuration: 'Segera',
      clipboardDuration: 30,
      isLoading: true,
    );
  }

  Future<void> init() async {
    final hasPin = await _security.hasMasterPin();
    final bioAvail = await _security.isBiometricAvailable();
    final bioEnabled = await _security.isBiometricEnabled();
    final autoLock = await _security.getAutoLockDuration();
    final clip = await _security.getClipboardDurationSeconds();

    state = state.copyWith(
      hasMasterPin: hasPin,
      isBiometricAvailable: bioAvail,
      isBiometricEnabled: bioEnabled,
      autoLockDuration: autoLock,
      clipboardDuration: clip,
      isLoading: false,
      isLocked: true,
    );

    // If master pin exists and biometric is enabled, auto prompt biometric
    if (hasPin && bioEnabled && bioAvail) {
      await unlockWithBiometric();
    }
  }

  Future<bool> unlockWithPin(String pin) async {
    if (state.isLockedOut) {
      return false;
    }

    final isValid = await _security.verifyMasterPin(pin);
    if (isValid) {
      state = state.copyWith(
        isLocked: false,
        failedAttempts: 0,
        lockoutUntil: null,
      );
      _lockoutTimer?.cancel();
      return true;
    } else {
      final newFailed = state.failedAttempts + 1;
      DateTime? lockout;
      if (newFailed >= 5) {
        lockout = DateTime.now().add(const Duration(seconds: 30));
        _startLockoutCountdown(30);
      }
      state = state.copyWith(
        failedAttempts: newFailed,
        lockoutUntil: lockout,
      );
      return false;
    }
  }

  void _startLockoutCountdown(int seconds) {
    _lockoutTimer?.cancel();
    _lockoutTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.remainingLockoutSeconds <= 0) {
        timer.cancel();
        state = state.copyWith(lockoutUntil: null, failedAttempts: 0);
      } else {
        // Trigger state rebuild for countdown
        state = state.copyWith();
      }
    });
  }

  Future<bool> unlockWithBiometric({
    String? localizedReason,
    String? signInTitle,
    String? signInHint,
    String? cancelButton,
  }) async {
    if (state.isLockedOut) return false;
    final success = await _security.authenticateWithBiometrics(
      localizedReason: localizedReason,
      signInTitle: signInTitle,
      signInHint: signInHint,
      cancelButton: cancelButton,
    );
    if (success) {
      state = state.copyWith(
        isLocked: false,
        failedAttempts: 0,
        lockoutUntil: null,
      );
      return true;
    }
    return false;
  }

  Future<void> setInitialPin(String pin) async {
    await _security.setMasterPin(pin);
    final bioAvail = await _security.isBiometricAvailable();
    if (bioAvail) {
      await _security.setBiometricEnabled(true);
    }
    state = state.copyWith(
      hasMasterPin: true,
      isBiometricAvailable: bioAvail,
      isBiometricEnabled: bioAvail,
      isLocked: false,
      failedAttempts: 0,
    );
  }

  Future<bool> changeMasterPin(String oldPin, String newPin) async {
    final validOld = await _security.verifyMasterPin(oldPin);
    if (!validOld) return false;

    await _security.setMasterPin(newPin);
    return true;
  }

  Future<void> toggleBiometric(bool enabled) async {
    await _security.setBiometricEnabled(enabled);
    state = state.copyWith(isBiometricEnabled: enabled);
  }

  Future<void> setAutoLockDuration(String duration) async {
    await _security.setAutoLockDuration(duration);
    state = state.copyWith(autoLockDuration: duration);
  }

  Future<void> setClipboardDuration(int seconds) async {
    await _security.setClipboardDurationSeconds(seconds);
    state = state.copyWith(clipboardDuration: seconds);
  }

  void lock() {
    state = state.copyWith(isLocked: true);
  }

  void onAppPaused() {
    _lastBackgroundTimestamp = DateTime.now();
    if (state.autoLockDuration == 'Segera') {
      lock();
    }
  }

  void onAppResumed() {
    if (_lastBackgroundTimestamp == null) return;

    final elapsed = DateTime.now().difference(_lastBackgroundTimestamp!);
    final requiredDuration = _security.parseAutoLockDuration(state.autoLockDuration);

    if (requiredDuration == Duration.zero || elapsed >= requiredDuration) {
      lock();
    }
    _lastBackgroundTimestamp = null;
  }
}
