import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:material_ui/material_ui.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import '../l10n/locale_provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import 'service_brand_icon.dart';

class ServiceIconPicker extends StatelessWidget {
  const ServiceIconPicker({
    super.key,
    required this.selectedKey,
    required this.onIconSelected,
    required this.serviceName,
    required this.accentColor,
  });

  /// null = auto-detect, 'none' = explicit initial, `file:path` = custom photo, or preset key 'steam'
  final String? selectedKey;
  final ValueChanged<String?> onIconSelected;
  final String serviceName;
  final Color accentColor;

  Future<void> _pickCustomPhoto(BuildContext context) async {
    try {
      final files = await FilePicker.pickFiles(
        type: FileType.image,
      );

      if (files.isNotEmpty && files.first.path != null) {
        final srcFile = File(files.first.path!);
        final appDir = await getApplicationDocumentsDirectory();
        final iconsDir = Directory(p.join(appDir.path, 'custom_icons'));
        if (!await iconsDir.exists()) {
          await iconsDir.create(recursive: true);
        }

        final ext = p.extension(srcFile.path).isNotEmpty
            ? p.extension(srcFile.path)
            : '.png';
        final destPath = p.join(iconsDir.path, '${const Uuid().v4()}$ext');
        await srcFile.copy(destPath);

        onIconSelected('file:$destPath');
      }
    } catch (e) {
      debugPrint('Error picking custom icon photo: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Current active key: if null, what would auto-detection resolve to?
    final detectedKey = ServiceIconHelper.detectIconKey(serviceName);
    final activeKey = selectedKey ?? detectedKey;

    final isInitialSelected =
        selectedKey == 'none' || (selectedKey == null && detectedKey == null);
    final isCustomPhotoSelected =
        selectedKey != null && selectedKey!.startsWith('file:');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              context.l10n.iconPickerHeader,
              style: AppTypography.small.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textMuted,
                letterSpacing: 0.5,
              ),
            ),
            if (selectedKey != null)
              GestureDetector(
                onTap: () => onIconSelected(null),
                child: Text(
                  context.l10n.iconPickerAutoDetect,
                  style: AppTypography.caption.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 88,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              // 1. Initial Char (Tanpa Ikon)
              _IconOptionTile(
                isSelected: isInitialSelected,
                label: context.l10n.iconPickerInitial,
                onTap: () => onIconSelected('none'),
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: isInitialSelected
                        ? AppColors.primary.withOpacity(0.12)
                        : AppColors.surface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isInitialSelected
                          ? AppColors.primary
                          : AppColors.border,
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      serviceName.trim().isNotEmpty
                          ? serviceName.trim()[0].toUpperCase()
                          : 'A',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: isInitialSelected
                            ? AppColors.primary
                            : AppColors.textPrimary,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // 2. Pick Custom Photo button
              _IconOptionTile(
                isSelected: isCustomPhotoSelected,
                label: isCustomPhotoSelected
                    ? context.l10n.iconPickerCustomPhoto
                    : context.l10n.iconPickerPickPhoto,
                onTap: () => _pickCustomPhoto(context),
                child: isCustomPhotoSelected
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          File(selectedKey!.substring(5)),
                          width: 38,
                          height: 38,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppColors.border,
                            width: 1,
                          ),
                        ),
                        child: const Center(
                          child: Icon(
                            LucideIcons.imagePlus,
                            size: 18,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
              ),
              const SizedBox(width: 8),

              // 3. Preset Brand Photos
              ...ServiceIconHelper.presets.map((preset) {
                final isSelected =
                    activeKey == preset.key && selectedKey != 'none';

                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: _IconOptionTile(
                    isSelected: isSelected,
                    label: preset.name,
                    onTap: () => onIconSelected(preset.key),
                    child: Container(
                      width: 38,
                      height: 38,
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? preset.defaultColor.withOpacity(0.12)
                            : AppColors.surface,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isSelected
                              ? preset.defaultColor
                              : AppColors.border,
                          width: 1,
                        ),
                      ),
                      child: Center(
                        child: ServiceBrandIcon(
                          iconKey: preset.key,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }
}

class _IconOptionTile extends StatelessWidget {
  const _IconOptionTile({
    required this.isSelected,
    required this.label,
    required this.onTap,
    required this.child,
  });

  final bool isSelected;
  final String label;
  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 78,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primarySoft : AppColors.card,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                child,
                if (isSelected)
                  Positioned(
                    right: -4,
                    top: -4,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        LucideIcons.check,
                        size: 10,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: AppTypography.caption.copyWith(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? AppColors.primary : AppColors.textMuted,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
