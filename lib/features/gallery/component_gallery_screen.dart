import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:material_ui/material_ui.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/account_card.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_header.dart';
import '../../core/widgets/app_switch.dart';
import '../../core/widgets/app_text_field.dart';
import '../../core/widgets/app_toast.dart';
import '../../core/widgets/bottom_nav_bar.dart';
import '../../core/widgets/category_chip.dart';
import '../../core/widgets/color_swatch_picker.dart';
import '../../core/widgets/confirm_dialog.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/field_card.dart';
import '../../core/widgets/service_brand_icon.dart';
import '../../core/widgets/service_card.dart';
import '../../core/widgets/settings_row.dart';
import '../../core/widgets/skeleton_card.dart';
import '../../core/widgets/strength_indicator.dart';

class ComponentGalleryScreen extends StatefulWidget {
  const ComponentGalleryScreen({super.key});

  @override
  State<ComponentGalleryScreen> createState() => _ComponentGalleryScreenState();
}

class _ComponentGalleryScreenState extends State<ComponentGalleryScreen> {
  Color _selectedColor = AppColors.serviceSwatches[0];
  int _selectedCategoryIndex = 0;
  bool _switchVal = true;
  int _bottomNavIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppHeader(
        title: 'Galeri Komponen',
        subtitle: 'Pratinjau Desain Tokens & Komponen',
        showBackButton: false,
      ),
      bottomNavigationBar: BrankasBottomNavBar(
        currentIndex: _bottomNavIndex,
        onTap: (i) => setState(() => _bottomNavIndex = i),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        children: [
          // Section: AppButton
          _buildSectionHeader('1. Tombol (AppButton)'),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              AppButton(
                text: 'Primary',
                variant: AppButtonVariant.primary,
                onPressed: () {},
              ),
              AppButton(
                text: 'Outline',
                variant: AppButtonVariant.outline,
                onPressed: () {},
              ),
              AppButton(
                text: 'Soft',
                variant: AppButtonVariant.soft,
                onPressed: () {},
              ),
              AppButton(
                text: 'Destructive',
                variant: AppButtonVariant.destructive,
                onPressed: () {},
              ),
              AppButton(
                text: 'Ghost',
                variant: AppButtonVariant.ghost,
                onPressed: () {},
              ),
              const AppButton(
                text: 'Loading',
                isLoading: true,
              ),
              const AppButton(
                text: 'Disabled',
                onPressed: null,
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Section: AppTextField
          _buildSectionHeader('2. Input Teks (AppTextField)'),
          const AppTextField(
            label: 'Nama Layanan',
            hintText: 'mis. Steam Gaming Platform',
          ),
          const SizedBox(height: 12),
          const AppTextField(
            label: 'Kata Sandi',
            hintText: 'Masukkan kata sandi...',
            variant: AppTextFieldVariant.password,
          ),
          const SizedBox(height: 12),
          const AppTextField(
            hintText: 'Cari layanan atau akun...',
            variant: AppTextFieldVariant.search,
          ),
          const SizedBox(height: 24),

          // Section: StrengthBadge & StrengthBar
          _buildSectionHeader('3. Indikator Kekuatan Password'),
          const Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              StrengthBadge(strength: PasswordStrength.weak),
              StrengthBadge(strength: PasswordStrength.fair),
              StrengthBadge(strength: PasswordStrength.strong),
              StrengthBadge(strength: PasswordStrength.veryStrong),
            ],
          ),
          const SizedBox(height: 12),
          const StrengthBar(score: 1),
          const SizedBox(height: 6),
          const StrengthBar(score: 2),
          const SizedBox(height: 6),
          const StrengthBar(score: 3),
          const SizedBox(height: 6),
          const StrengthBar(score: 4),
          const SizedBox(height: 24),

          // Section: CategoryChips
          _buildSectionHeader('4. Chip Kategori'),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                CategoryChip(
                  label: 'Semua',
                  count: 8,
                  isSelected: _selectedCategoryIndex == 0,
                  onTap: () => setState(() => _selectedCategoryIndex = 0),
                ),
                const SizedBox(width: 8),
                CategoryChip(
                  label: 'Game',
                  count: 3,
                  isSelected: _selectedCategoryIndex == 1,
                  onTap: () => setState(() => _selectedCategoryIndex = 1),
                ),
                const SizedBox(width: 8),
                CategoryChip(
                  label: 'Sosial',
                  count: 2,
                  isSelected: _selectedCategoryIndex == 2,
                  onTap: () => setState(() => _selectedCategoryIndex = 2),
                ),
                const SizedBox(width: 8),
                CategoryChip(
                  label: 'Kerja',
                  count: 2,
                  isSelected: _selectedCategoryIndex == 3,
                  onTap: () => setState(() => _selectedCategoryIndex = 3),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Section: ColorSwatchPicker
          _buildSectionHeader('5. Color Swatch Picker'),
          ColorSwatchPicker(
            selectedColor: _selectedColor,
            onColorSelected: (c) => setState(() => _selectedColor = c),
          ),
          const SizedBox(height: 24),

          // Section: ServiceCard & Brand Icons
          _buildSectionHeader('6. Kartu Layanan & Ikon Brand (ServiceCard)'),
          ServiceCard(
            name: 'Steam',
            category: 'Game Platform',
            accountCount: 4,
            color: _selectedColor,
            iconKey: 'steam',
            onTap: () {},
          ),
          const SizedBox(height: 12),
          Text(
            'Presisi Ikon Layanan (11 Brand Preset):',
            style: AppTypography.smallMedium,
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: ServiceIconHelper.presets.map((preset) {
              return Tooltip(
                message: preset.name,
                child: ServiceAvatar(
                  name: preset.name,
                  color: preset.defaultColor,
                  iconKey: preset.key,
                  size: 40,
                  borderRadius: 8,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),

          // Section: AccountCard
          _buildSectionHeader('7. Kartu Akun (AccountCard)'),
          AccountCard(
            label: 'Akun Utama (CS2 & Dota)',
            strength: PasswordStrength.veryStrong,
            username: 'luthfi_steam',
            email: 'luthfi.pro@gmail.com',
            onTap: () {},
            onCopyId: () {
              AppToast.show(context, title: 'ID Berhasil Disalin!');
            },
            onCopyPassword: () {
              AppToast.show(
                context,
                title: 'Kata Sandi Berhasil Disalin!',
                subtitle: 'Clipboard dibersihkan otomatis dalam 30 detik.',
              );
            },
          ),
          const SizedBox(height: 24),

          // Section: FieldCard
          _buildSectionHeader('8. Kartu Field (FieldCard)'),
          FieldCard(
            label: 'Nama Pengguna / ID',
            value: 'luthfi_steam',
            onCopy: () => AppToast.show(context, title: 'ID Disalin'),
          ),
          const SizedBox(height: 10),
          FieldCard(
            label: 'Kata Sandi',
            value: r'kP9#vL2$wQ8!mX4^',
            isPassword: true,
            onCopy: () => AppToast.show(context, title: 'Kata Sandi Disalin'),
            bottomWidget: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StrengthBar(score: 4),
                SizedBox(height: 6),
                Text(
                  'Sangat Kuat (16 Karakter: Angka & Simbol)',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.success,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Section: Settings & Dialogs
          _buildSectionHeader('9. Baris Pengaturan & Dialog'),
          Container(
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                SettingsRow(
                  title: 'Buka dengan Biometrik',
                  icon: const Icon(LucideIcons.fingerprint, color: AppColors.primary),
                  trailing: AppSwitch(
                    value: _switchVal,
                    onChanged: (v) => setState(() => _switchVal = v),
                  ),
                ),
                const Divider(),
                SettingsRow(
                  title: 'Kunci Otomatis',
                  icon: const Icon(LucideIcons.clock, color: AppColors.primary),
                  valueText: 'Segera',
                  onTap: () {},
                ),
                const Divider(),
                SettingsRow(
                  title: 'Tes Dialog Konfirmasi Hapus',
                  icon: const Icon(LucideIcons.trash2, color: AppColors.destructive),
                  isDestructive: true,
                  onTap: () {
                    ConfirmDialog.show(
                      context,
                      title: 'Hapus Akun Ini?',
                      message:
                          'Akun \'Akun Smurf & Casual\' beserta semua kata sandi akan dihapus permanen. Tindakan ini tidak dapat dibatalkan.',
                      confirmText: 'Ya, Hapus Akun Permanen',
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Section: Skeleton & Empty State
          _buildSectionHeader('10. Skeleton & Empty State'),
          const SkeletonCard(),
          const SizedBox(height: 16),
          EmptyState(
            title: 'Belum Ada Layanan',
            description:
                'Simpan akun game, media sosial, dan email Anda secara terpusat dan aman dalam satu brankas.',
            actionText: 'Tambah Layanan Pertama',
            tipText:
                'Tips: Anda bisa mengelompokkan beberapa akun (mis. Akun 1 & 2) di satu layanan.',
            onAction: () {},
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: AppTypography.h3.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
