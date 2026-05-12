import 'package:flutter/material.dart';

/// 跨项目复用的 BuildContext 简写，避免每处都写 `Theme.of(context)`。
extension BuildContextX on BuildContext {
  // ─── 主题 ─────────────────────────────────────
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => theme.textTheme;
  ColorScheme get colorScheme => theme.colorScheme;

  // ─── 屏幕 / MediaQuery ────────────────────────
  MediaQueryData get mq => MediaQuery.of(this);
  Size get screenSize => mq.size;
  double get screenWidth => mq.size.width;
  double get screenHeight => mq.size.height;
  EdgeInsets get safePadding => mq.padding;
  EdgeInsets get viewInsets => mq.viewInsets;
  bool get isKeyboardOpen => viewInsets.bottom > 0;

  // ─── 键盘 ─────────────────────────────────────
  void hideKeyboard() => FocusScope.of(this).unfocus();
}
