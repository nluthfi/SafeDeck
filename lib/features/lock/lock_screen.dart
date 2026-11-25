import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:material_ui/material_ui.dart';
import '../../core/l10n/locale_provider.dart';
import '../../core/security/auth_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_shadows.dart';
import '../../core/theme/app_typography.dart';

class LockScreen extends ConsumerStatefulWidget {
  const LockScreen({super.key, this.onSuccess});

  final VoidCallback? onSuccess;

  @override
  ConsumerState<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends ConsumerState<LockScreen> {
  String _enteredPin = '';
  String _initialPinSetup = '';
  bool _isConfirmingSetup = false;
  String? _errorMessage;
  bool _hasPromptedBiometric = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _tryAutoBiometric();
    });
  }

  Future<void> _tryAutoBiometric() async {
    if (_hasPromptedBiometric) return;
    final authState = ref.read(authNotifierProvider);
    if (authState.hasMasterPin &&
        authState.isBiometricEnabled &&
        authState.isBiometricAvailable &&
        !authState.isLockedOut) {
      _hasPromptedBiometric = true;
      final l10n = context.l10n;
      final success =
          await ref.read(authNotifierProvider.notifier).unlockWithBiometric(
                localizedReason: l10n.biometricReason,
                signInTitle: l10n.biometricSignInTitle,
                signInHint: l10n.biometricSignInHint,
                cancelButton: l10n.biometricCancelButton,
              );
      if (success && mounted) {
        widget.onSuccess?.call();
      }
    }
  }

  void _onDigitPressed(String digit) async {
    final authState = ref.read(authNotifierProvider);
    if (authState.isLockedOut) return;

    if (_enteredPin.length < 6) {
      setState(() {
        _enteredPin += digit;
        _errorMessage = null;
      });

      if (_enteredPin.length == 6) {
        await _handlePinCompleted();
      }
    }
  }

  void _onDeletePressed() {
    if (_enteredPin.isNotEmpty) {
      setState(() {
        _enteredPin = _enteredPin.substring(0, _enteredPin.length - 1);
        _errorMessage = null;
      });
    }
  }

  Future<void> _handlePinCompleted() async {
    final authState = ref.read(authNotifierProvider);
    final notifier = ref.read(authNotifierProvider.notifier);

    // Initial PIN Setup flow
    if (!authState.hasMasterPin) {
      if (!_isConfirmingSetup) {
        setState(() {
          _initialPinSetup = _enteredPin;
          _enteredPin = '';
          _isConfirmingSetup = true;
          _errorMessage = null;
        });
      } else {
        if (_enteredPin == _initialPinSetup) {
          await notifier.setInitialPin(_enteredPin);
          widget.onSuccess?.call();
        } else {
          setState(() {
            _enteredPin = '';
            _errorMessage = context.l10n.lockPinMismatch;
            _isConfirmingSetup = false;
            _initialPinSetup = '';
          });
        }
      }
      return;
    }

    // Normal Unlock flow
    final success = await notifier.unlockWithPin(_enteredPin);
    if (success) {
      widget.onSuccess?.call();
    } else {
      final updatedState = ref.read(authNotifierProvider);
      if (!mounted) return;
      final l10n = context.l10n;
      setState(() {
        _enteredPin = '';
        if (updatedState.isLockedOut) {
          _errorMessage =
              l10n.lockTooManyAttempts(updatedState.remainingLockoutSeconds);
        } else {
          final attemptsLeft = 5 - updatedState.failedAttempts;
          _errorMessage = attemptsLeft > 0
              ? l10n.lockWrongPinAttempts(attemptsLeft)
              : l10n.lockWrongPin;
        }
      });
    }
  }

  void _showForgotPinDialog() {
    final l10n = context.l10n;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(l10n.lockForgotPin, style: AppTypography.h3),
        content: Text(
          l10n.lockForgotPinMessage,
          style: AppTypography.small.copyWith(height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              l10n.understood,
              style: AppTypography.bodyMedium.copyWith(color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final l10n = context.l10n;

    String title = l10n.lockTitleUnlock;
    String subtitle = l10n.lockSubtitleUnlock;

    if (!authState.hasMasterPin) {
      if (!_isConfirmingSetup) {
        title = l10n.lockTitleCreate;
        subtitle = l10n.lockSubtitleCreate;
      } else {
        title = l10n.lockTitleConfirm;
        subtitle = l10n.lockSubtitleConfirm;
      }
    }

    if (authState.isLockedOut) {
      _errorMessage =
          l10n.lockTooManyAttemptsRetry(authState.remainingLockoutSeconds);
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Shield Icon
                Container(
                  width: 64,
                  height: 64,
                  decoration: const BoxDecoration(
                    color: AppColors.primarySoft,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(
                      LucideIcons.shieldCheck,
                      size: 32,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Title
                Text(
                  title,
                  style: AppTypography.h1.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 6),
                // Subtitle
                Text(
                  subtitle,
                  style: AppTypography.small.copyWith(
                    color: AppColors.textMuted,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),

                // 6 PIN Dots
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(6, (index) {
                    final isFilled = index < _enteredPin.length;
                    final isError = _errorMessage != null;

                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isFilled
                            ? (isError ? AppColors.destructive : AppColors.primary)
                            : Colors.transparent,
                        border: Border.all(
                          color: isError
                              ? AppColors.destructive
                              : (isFilled ? AppColors.primary : AppColors.border),
                          width: 2,
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 12),

                // Error or lockout text
                SizedBox(
                  height: 24,
                  child: _errorMessage != null
                      ? Text(
                          _errorMessage!,
                          style: AppTypography.captionMedium.copyWith(
                            color: AppColors.destructive,
                          ),
                          textAlign: TextAlign.center,
                        )
                      : null,
                ),

                const SizedBox(height: 16),

                // Keypad 3x4
                _buildKeypad(authState),

                const SizedBox(height: 16),

                // Forgot PIN Link
                if (authState.hasMasterPin) ...[
                  TextButton(
                    onPressed: _showForgotPinDialog,
                    child: Text(
                      l10n.lockForgotPin,
                      style: AppTypography.smallMedium.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildKeypad(AuthState authState) {
    return Column(
      children: [
        _buildKeyRow(['1', '2', '3']),
        const SizedBox(height: 12),
        _buildKeyRow(['4', '5', '6']),
        const SizedBox(height: 12),
        _buildKeyRow(['7', '8', '9']),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Left: Biometric Button
            SizedBox(
              width: 72,
              height: 72,
              child: (authState.hasMasterPin &&
                      (authState.isBiometricEnabled ||
                          authState.isBiometricAvailable))
                  ? InkWell(
                      onTap: () async {
                        final l10n = context.l10n;
                        final ok = await ref
                            .read(authNotifierProvider.notifier)
                            .unlockWithBiometric(
                              localizedReason: l10n.biometricReason,
                              signInTitle: l10n.biometricSignInTitle,
                              signInHint: l10n.biometricSignInHint,
                              cancelButton: l10n.biometricCancelButton,
                            );
                        if (ok && mounted) {
                          widget.onSuccess?.call();
                        } else if (mounted) {
                          setState(() {
                            _errorMessage = l10n.lockBiometricFailed;
                          });
                        }
                      },
                      borderRadius: BorderRadius.circular(36),
                      child: const Center(
                        child: Icon(
                          LucideIcons.fingerprint,
                          size: 30,
                          color: AppColors.primary,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
            // Center: 0
            _buildDigitKey('0'),
            // Right: Backspace
            SizedBox(
              width: 72,
              height: 72,
              child: InkWell(
                onTap: _onDeletePressed,
                borderRadius: BorderRadius.circular(36),
                child: const Center(
                  child: Icon(
                    LucideIcons.delete,
                    size: 24,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildKeyRow(List<String> digits) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: digits.map(_buildDigitKey).toList(),
    );
  }

  Widget _buildDigitKey(String digit) {
    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        color: AppColors.card,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.border, width: 1.2),
        boxShadow: AppShadows.sm,
      ),
      child: Material(
        color: Colors.transparent,
        shape: const CircleBorder(),
        child: InkWell(
          onTap: () => _onDigitPressed(digit),
          customBorder: const CircleBorder(),
          splashColor: AppColors.primarySoft,
          child: Center(
            child: Text(
              digit,
              style: AppTypography.title.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
                fontSize: 26,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
