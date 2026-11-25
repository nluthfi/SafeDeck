import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:material_ui/material_ui.dart';
import '../theme/app_colors.dart';

class ColorSwatchPicker extends StatelessWidget {
  const ColorSwatchPicker({
    super.key,
    required this.selectedColor,
    required this.onColorSelected,
    this.swatches = AppColors.serviceSwatches,
  });

  final Color selectedColor;
  final ValueChanged<Color> onColorSelected;
  final List<Color> swatches;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: swatches.map((color) {
        final isSelected = color.value == selectedColor.value;
        return GestureDetector(
          onTap: () => onColorSelected(color),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? AppColors.textPrimary : Colors.transparent,
                width: isSelected ? 3.0 : 0,
              ),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.35),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: isSelected
                ? const Center(
                    child: Icon(
                      LucideIcons.check,
                      size: 20,
                      color: Colors.white,
                    ),
                  )
                : null,
          ),
        );
      }).toList(),
    );
  }
}
