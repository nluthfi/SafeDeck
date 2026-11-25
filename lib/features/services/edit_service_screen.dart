import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:material_ui/material_ui.dart';
import '../../core/l10n/locale_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_header.dart';
import '../../core/widgets/app_text_field.dart';
import '../../core/widgets/app_toast.dart';
import '../../core/widgets/color_swatch_picker.dart';
import '../../core/widgets/confirm_dialog.dart';
import '../../core/widgets/service_card.dart';
import '../../core/widgets/service_icon_picker.dart';
import '../../data/repositories/vault_repository.dart';

class EditServiceScreen extends ConsumerStatefulWidget {
  const EditServiceScreen({
    super.key,
    this.serviceId,
  });

  final String? serviceId;

  @override
  ConsumerState<EditServiceScreen> createState() => _EditServiceScreenState();
}

class _EditServiceScreenState extends ConsumerState<EditServiceScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _urlController;

  String _selectedCategory = 'Game';
  Color _selectedColor = AppColors.serviceSwatches[0];
  String? _selectedIconKey;
  bool _isLoading = false;
  bool _isInit = true;

  final List<String> _categories = [
    'Game',
    'Sosial Media',
    'Kerja & Bisnis',
    'Keuangan',
    'Hiburan',
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _urlController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit && widget.serviceId != null) {
      _loadExisting();
      _isInit = false;
    }
  }

  Future<void> _loadExisting() async {
    final repo = ref.read(vaultRepositoryProvider);
    final service = await repo.getServiceById(widget.serviceId!);
    if (service != null && mounted) {
      setState(() {
        _nameController.text = service.service.name;
        _urlController.text = service.service.url ?? '';
        _selectedCategory = service.service.category;
        _selectedIconKey = service.service.iconKey;
        final hex = service.service.colorHex.replaceAll('#', '');
        _selectedColor = Color(int.parse('FF$hex', radix: 16));
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _urlController.dispose();
    super.dispose();
  }

  String _colorToHex(Color color) {
    return '#${color.value.toRadixString(16).substring(2).toUpperCase()}';
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    final repo = ref.read(vaultRepositoryProvider);

    try {
      if (widget.serviceId == null) {
        await repo.createService(
          name: _nameController.text.trim(),
          category: _selectedCategory,
          colorHex: _colorToHex(_selectedColor),
          iconKey: _selectedIconKey,
          url: _urlController.text.trim().isNotEmpty
              ? _urlController.text.trim()
              : null,
        );
        if (mounted) {
          AppToast.show(context, title: context.l10n.editServiceAddedToast);
          Navigator.of(context).pop();
        }
      } else {
        await repo.updateService(
          id: widget.serviceId!,
          name: _nameController.text.trim(),
          category: _selectedCategory,
          colorHex: _colorToHex(_selectedColor),
          iconKey: _selectedIconKey,
          url: _urlController.text.trim().isNotEmpty
              ? _urlController.text.trim()
              : null,
        );
        if (mounted) {
          AppToast.show(context, title: context.l10n.editServiceUpdatedToast);
          Navigator.of(context).pop();
        }
      }
    } catch (e) {
      if (mounted) {
        AppToast.show(
          context,
          title: context.l10n.editServiceSaveFailed,
          subtitle: e.toString(),
          iconColor: AppColors.destructive,
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteService() async {
    final l10n = context.l10n;
    final confirmed = await ConfirmDialog.show(
      context,
      title: l10n.editServiceDeleteConfirmTitle(_nameController.text.trim()),
      message: l10n.editServiceDeleteConfirmMessage,
      confirmText: l10n.editServiceDeleteConfirmAction,
    );

    if (confirmed == true && mounted) {
      final repo = ref.read(vaultRepositoryProvider);
      await repo.deleteService(widget.serviceId!);
      if (mounted) {
        AppToast.show(context, title: l10n.editServiceDeletedToast);
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isEdit = widget.serviceId != null;

    return Scaffold(
      appBar: AppHeader(
        title: isEdit ? l10n.editServiceTitleEdit : l10n.editServiceTitleAdd,
        showBackButton: true,
        actions: [
          if (isEdit)
            IconButton(
              tooltip: l10n.editServiceDeleteTooltip,
              icon: const Icon(
                LucideIcons.trash2,
                color: AppColors.destructive,
                size: 20,
              ),
              onPressed: _deleteService,
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          children: [
            // Nama Layanan
            AppTextField(
              controller: _nameController,
              label: l10n.editServiceNameLabel,
              hintText: l10n.editServiceNameHint,
              onChanged: (_) => setState(() {}),
              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  return l10n.editServiceNameRequired;
                }
                return null;
              },
            ),
            const SizedBox(height: 18),

            // Kategori Layanan
            Text(
              l10n.editServiceCategoryLabel,
              style: AppTypography.smallMedium.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _categories.map((cat) {
                final isSelected = cat == _selectedCategory;
                return ChoiceChip(
                  label: Text(
                    localizeCategory(l10n, cat),
                    style: AppTypography.smallMedium.copyWith(
                      color: isSelected ? AppColors.primary : AppColors.textPrimary,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                  selected: isSelected,
                  selectedColor: AppColors.primarySoft,
                  backgroundColor: AppColors.background,
                  side: BorderSide(
                    color: isSelected ? AppColors.primaryOutline : AppColors.border,
                    width: 1.2,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  onSelected: (selected) {
                    if (selected) {
                      setState(() => _selectedCategory = cat);
                    }
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // Warna Identitas
            Text(
              l10n.editServiceColorLabel,
              style: AppTypography.smallMedium.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 10),
            ColorSwatchPicker(
              selectedColor: _selectedColor,
              onColorSelected: (c) => setState(() => _selectedColor = c),
            ),
            const SizedBox(height: 20),

            // Icon Picker (Opsional)
            ServiceIconPicker(
              selectedKey: _selectedIconKey,
              onIconSelected: (key) => setState(() => _selectedIconKey = key),
              serviceName: _nameController.text,
              accentColor: _selectedColor,
            ),
            const SizedBox(height: 20),

            // URL
            AppTextField(
              controller: _urlController,
              label: l10n.editServiceUrlLabel,
              hintText: 'https://store.epicgames.com',
              keyboardType: TextInputType.url,
            ),
            const SizedBox(height: 24),

            // Live Card Preview
            Text(
              l10n.editServicePreviewHeader,
              style: AppTypography.captionMedium.copyWith(
                color: AppColors.textMuted,
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(height: 8),
            ServiceCard(
              name: _nameController.text.trim().isNotEmpty
                  ? _nameController.text.trim()
                  : l10n.editServiceNameLabel,
              category: _selectedCategory,
              accountCount: 0,
              color: _selectedColor,
              iconKey: _selectedIconKey,
              url: _urlController.text.trim(),
            ),
            const SizedBox(height: 32),

            // Submit Button
            AppButton(
              text: isEdit ? l10n.editServiceSaveChanges : l10n.editServiceSaveNew,
              isLoading: _isLoading,
              onPressed: _save,
            ),
            if (isEdit) ...[
              const SizedBox(height: 12),
              AppButton(
                text: l10n.editServiceDeleteAllButton,
                variant: AppButtonVariant.destructive,
                isLoading: _isLoading,
                onPressed: _deleteService,
              ),
            ],
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
