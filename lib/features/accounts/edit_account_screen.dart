import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:material_ui/material_ui.dart';
import '../../core/l10n/locale_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/password_generator.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_header.dart';
import '../../core/widgets/app_text_field.dart';
import '../../core/widgets/app_toast.dart';
import '../../core/widgets/service_brand_icon.dart';
import '../../core/widgets/strength_indicator.dart';
import '../../data/repositories/vault_repository.dart';

class EditAccountScreen extends ConsumerStatefulWidget {
  const EditAccountScreen({
    super.key,
    this.accountId,
    this.initialServiceId,
  });

  final String? accountId;
  final String? initialServiceId;

  @override
  ConsumerState<EditAccountScreen> createState() => _EditAccountScreenState();
}

class _EditAccountScreenState extends ConsumerState<EditAccountScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _labelController;
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _recoveryCodeController;
  late TextEditingController _noteController;

  String? _selectedServiceId;
  bool _isLoading = false;
  bool _isInit = true;

  @override
  void initState() {
    super.initState();
    _selectedServiceId = widget.initialServiceId;
    _labelController = TextEditingController();
    _usernameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _recoveryCodeController = TextEditingController();
    _noteController = TextEditingController();

    _passwordController.addListener(() {
      setState(() {});
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit && widget.accountId != null) {
      _loadExisting();
      _isInit = false;
    }
  }

  Future<void> _loadExisting() async {
    final repo = ref.read(vaultRepositoryProvider);
    final account = await repo.getAccountById(widget.accountId!);
    if (account != null && mounted) {
      setState(() {
        _selectedServiceId = account.serviceId;
        _labelController.text = account.label;
        _usernameController.text = account.username ?? '';
        _emailController.text = account.email ?? '';
        _passwordController.text = account.password;
        _recoveryCodeController.text = account.recoveryCode ?? '';
        _noteController.text = account.note ?? '';
      });
    }
  }

  @override
  void dispose() {
    _labelController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _recoveryCodeController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _generateStrongPassword() {
    final newPassword = PasswordGenerator.generate(
      const PasswordGeneratorOptions(
        length: 16,
        includeUpper: true,
        includeLower: true,
        includeNumbers: true,
        includeSymbols: true,
      ),
    );
    setState(() {
      _passwordController.text = newPassword;
    });
    AppToast.show(
      context,
      title: context.l10n.editAccountGeneratedToast,
      duration: const Duration(seconds: 2),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedServiceId == null) {
      AppToast.show(
        context,
        title: context.l10n.editAccountSelectServiceFirst,
        iconColor: AppColors.warning,
      );
      return;
    }

    setState(() => _isLoading = true);
    final repo = ref.read(vaultRepositoryProvider);

    try {
      if (widget.accountId == null) {
        await repo.createAccount(
          serviceId: _selectedServiceId!,
          label: _labelController.text.trim(),
          username: _usernameController.text.trim().isNotEmpty
              ? _usernameController.text.trim()
              : null,
          email: _emailController.text.trim().isNotEmpty
              ? _emailController.text.trim()
              : null,
          password: _passwordController.text,
          recoveryCode: _recoveryCodeController.text.trim().isNotEmpty
              ? _recoveryCodeController.text.trim()
              : null,
          note: _noteController.text.trim().isNotEmpty
              ? _noteController.text.trim()
              : null,
        );
        if (mounted) {
          AppToast.show(context, title: context.l10n.editAccountAddedToast);
          Navigator.of(context).pop();
        }
      } else {
        await repo.updateAccount(
          id: widget.accountId!,
          serviceId: _selectedServiceId!,
          label: _labelController.text.trim(),
          username: _usernameController.text.trim().isNotEmpty
              ? _usernameController.text.trim()
              : null,
          email: _emailController.text.trim().isNotEmpty
              ? _emailController.text.trim()
              : null,
          password: _passwordController.text,
          recoveryCode: _recoveryCodeController.text.trim().isNotEmpty
              ? _recoveryCodeController.text.trim()
              : null,
          note: _noteController.text.trim().isNotEmpty
              ? _noteController.text.trim()
              : null,
        );
        if (mounted) {
          AppToast.show(context, title: context.l10n.editAccountUpdatedToast);
          Navigator.of(context).pop();
        }
      }
    } catch (e) {
      if (mounted) {
        AppToast.show(
          context,
          title: context.l10n.editAccountSaveFailed,
          subtitle: e.toString(),
          iconColor: AppColors.destructive,
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isEdit = widget.accountId != null;
    final servicesAsync = ref.watch(vaultRepositoryProvider).watchServices();
    final pwdEval = PasswordStrengthEvaluator.evaluate(_passwordController.text);
    final strengthLabel = localizeStrengthLabel(
      l10n,
      pwdEval.strength,
      isEmpty: pwdEval.score == 0,
    );
    final strengthDetail = localizeStrengthDetail(
      l10n,
      pwdEval,
      _passwordController.text.length,
    );

    return Scaffold(
      appBar: AppHeader(
        title: isEdit ? l10n.editAccountTitleEdit : l10n.editAccountTitleAdd,
        showBackButton: true,
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _save,
            child: Text(
              l10n.done,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          children: [
            // Pilih Layanan Dropdown
            Text(
              l10n.editAccountSelectService,
              style: AppTypography.smallMedium.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            StreamBuilder<List<ServiceWithAccounts>>(
              stream: servicesAsync,
              builder: (context, snapshot) {
                final services = snapshot.data ?? [];
                if (_selectedServiceId == null && services.isNotEmpty) {
                  _selectedServiceId = services.first.service.id;
                }

                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.border, width: 1.2),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedServiceId,
                      isExpanded: true,
                      hint: Text(l10n.editAccountSelectServiceHint),
                      icon: const Icon(LucideIcons.chevronDown,
                          size: 18, color: AppColors.textLight),
                      items: services.map((s) {
                        Color color = AppColors.primary;
                        try {
                          final hex = s.service.colorHex.replaceAll('#', '');
                          color = Color(int.parse('FF$hex', radix: 16));
                        } catch (_) {}

                        return DropdownMenuItem<String>(
                          value: s.service.id,
                          child: Row(
                            children: [
                              ServiceAvatar(
                                name: s.service.name,
                                color: color,
                                iconKey: s.service.iconKey,
                                size: 24,
                                borderRadius: 6,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  '${s.service.name} (${localizeCategory(l10n, s.service.category)})',
                                  style: AppTypography.body.copyWith(
                                    color: AppColors.textPrimary,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (val) {
                        setState(() => _selectedServiceId = val);
                      },
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 18),

            // Label Akun
            AppTextField(
              controller: _labelController,
              label: l10n.editAccountLabelField,
              hintText: l10n.editAccountLabelHint,
              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  return l10n.editAccountLabelRequired;
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // ID / Username
            AppTextField(
              controller: _usernameController,
              label: l10n.editAccountUsernameField,
              hintText: l10n.editAccountUsernameHint,
            ),
            const SizedBox(height: 16),

            // Email
            AppTextField(
              controller: _emailController,
              label: l10n.editAccountEmailField,
              hintText: l10n.editAccountEmailHint,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),

            // Kata Sandi
            AppTextField(
              controller: _passwordController,
              label: l10n.editAccountPasswordField,
              hintText: l10n.editAccountPasswordHint,
              variant: AppTextFieldVariant.password,
              validator: (v) {
                if (v == null || v.isEmpty) {
                  return l10n.editAccountPasswordRequired;
                }
                return null;
              },
            ),
            const SizedBox(height: 10),

            // Buat Password Kuat Otomatis Button
            InkWell(
              onTap: _generateStrongPassword,
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(LucideIcons.sparkles,
                        size: 16, color: AppColors.primary),
                    const SizedBox(width: 8),
                    Text(
                      l10n.editAccountGenerateButton,
                      style: AppTypography.smallMedium.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Strength bar
            StrengthBar(score: pwdEval.score),
            const SizedBox(height: 6),
            Text(
              l10n.editAccountStrengthPrefix(strengthLabel, strengthDetail),
              style: AppTypography.captionMedium.copyWith(
                color: pwdEval.color,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 18),

            // Kode Pemulihan 2FA
            AppTextField(
              controller: _recoveryCodeController,
              label: l10n.editAccountRecoveryField,
              hintText: 'mis. R8492-X9812-KL09',
            ),
            const SizedBox(height: 16),

            // Catatan
            AppTextField(
              controller: _noteController,
              label: l10n.editAccountNoteField,
              hintText: l10n.editAccountNoteHint,
              maxLines: 3,
            ),
            const SizedBox(height: 28),

            // Submit Button
            AppButton(
              text: isEdit ? l10n.editServiceSaveChanges : l10n.editAccountSaveNew,
              isLoading: _isLoading,
              onPressed: _save,
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
