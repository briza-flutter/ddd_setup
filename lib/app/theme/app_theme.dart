import 'package:flutter/material.dart';

/// 应用主题与设计 token。
///
/// 通过 [MaterialApp.theme] / [MaterialApp.darkTheme] 注入，
/// 业务页面通过 `Theme.of(context)` 或 `context.theme`（见 `BuildContextX`）访问。
///
/// 自定义 token（success/warning/spacing/radius 等）作为静态常量直接 import，
/// 不放进 ColorScheme 因为它不属于 Material 标准色槽。
///
/// 想加主题切换：在 `shared/providers/theme_vm.dart` 加 ThemeMode 状态，
/// app.dart 里 `ref.watch` 后传给 `MaterialApp.themeMode`。
class AppTheme {
  AppTheme._();

  // ─── 品牌色（种子）─────────────────────────────
  static const _brandSeed = Color(0xFF0066FF);

  // ─── 自定义颜色 token（ColorScheme 之外的语义色）─
  static const success = Color(0xFF22C55E);
  static const warning = Color(0xFFF59E0B);
  static const danger = Color(0xFFEF4444);

  // ─── 圆角 token ───────────────────────────────
  static const radiusSm = 4.0;
  static const radiusMd = 8.0;
  static const radiusLg = 16.0;

  // ─── 间距 token ───────────────────────────────
  static const spaceXs = 4.0;
  static const spaceSm = 8.0;
  static const spaceMd = 16.0;
  static const spaceLg = 24.0;
  static const spaceXl = 32.0;

  // ─── ThemeData 入口 ───────────────────────────
  static ThemeData get light => _build(Brightness.light);
  static ThemeData get dark => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final scheme = ColorScheme.fromSeed(
      seedColor: _brandSeed,
      brightness: brightness,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.surface,
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        centerTitle: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMd),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: spaceMd,
          vertical: spaceSm + 4,
        ),
      ),
    );
  }
}
