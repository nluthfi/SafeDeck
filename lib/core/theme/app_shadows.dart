import 'package:material_ui/material_ui.dart';

abstract class AppShadows {
  // Shadow Sm: offset (0, 1), blur 2, color #0F172A at 5.1% alpha
  static const List<BoxShadow> sm = [
    BoxShadow(
      color: Color(0x0D0F172A),
      offset: Offset(0, 1),
      blurRadius: 2,
      spreadRadius: 0,
    ),
  ];

  // Shadow Md: offset (0, 3) blur 8 spread -1, + offset (0, 1) blur 3
  static const List<BoxShadow> md = [
    BoxShadow(
      color: Color(0x140F172A),
      offset: Offset(0, 3),
      blurRadius: 8,
      spreadRadius: -1,
    ),
    BoxShadow(
      color: Color(0x080F172A),
      offset: Offset(0, 1),
      blurRadius: 3,
      spreadRadius: 0,
    ),
  ];

  // Shadow Lg: offset (0, 8) blur 20 spread -2, + offset (0, 2) blur 6
  static const List<BoxShadow> lg = [
    BoxShadow(
      color: Color(0x1F0F172A),
      offset: Offset(0, 8),
      blurRadius: 20,
      spreadRadius: -2,
    ),
    BoxShadow(
      color: Color(0x0A0F172A),
      offset: Offset(0, 2),
      blurRadius: 6,
      spreadRadius: 0,
    ),
  ];
}
