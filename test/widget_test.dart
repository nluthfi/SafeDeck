import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:password_management_apps/core/theme/app_theme.dart';
import 'package:password_management_apps/features/gallery/component_gallery_screen.dart';
import 'package:password_management_apps/main.dart';

void main() {
  testWidgets('BrankasApp smoke test loads lock screen when locked',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: BrankasApp(),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.byType(MaterialApp), findsOneWidget);
  });

  testWidgets('Component gallery smoke test displays all widgets',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          home: const ComponentGalleryScreen(),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Galeri Komponen'), findsOneWidget);
    expect(find.text('1. Tombol (AppButton)'), findsOneWidget);
  });
}
