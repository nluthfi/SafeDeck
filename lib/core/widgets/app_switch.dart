import 'package:material_ui/material_ui.dart';
import '../theme/app_colors.dart';

class AppSwitch extends StatelessWidget {
  const AppSwitch({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Switch.adaptive(
      value: value,
      onChanged: onChanged,
      activeColor: AppColors.primary,
      activeTrackColor: AppColors.primaryOutline,
      inactiveThumbColor: AppColors.textMuted,
      inactiveTrackColor: AppColors.border,
    );
  }
}
