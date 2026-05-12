# 主题与设计 token

主题数据放 `app/theme/app_theme.dart`——属于**项目装配**（品牌色、字号是这个 App 的，换项目都要改），不在 `core/`。

`MaterialApp` 在 `app/app.dart` 通过 `theme` / `darkTheme` / `themeMode` 注入，业务页面通过 `Theme.of(context)`（或 `context.theme`）读取。

## 两类 token 的访问方式

| 类型 | 来源 | 访问方式 | 示例 |
|---|---|---|---|
| **Material 标准色** | `ColorScheme`（由 seedColor 自动派生） | `context.colorScheme.primary` | 主色、表面色、错误色 |
| **自定义 token** | `AppTheme.*` 静态常量 | 直接 import | `AppTheme.success`、`AppTheme.spaceMd` |

```dart
// 用 ColorScheme（随主题自动切换 light/dark）
Container(color: context.colorScheme.primary)

// 用自定义 token（语义色、间距、圆角等）
Container(
  color: AppTheme.success,
  padding: const EdgeInsets.all(AppTheme.spaceMd),
)
```

> **为什么自定义 token 不放进 ColorScheme**：`ColorScheme` 是 Material 设计规范的标准色槽，硬塞 success/warning 等业务语义色会绕开 Material 主题派生机制。需要随主题切换的自定义色用 [ThemeExtension](https://api.flutter.dev/flutter/material/ThemeExtension-class.html)，模板用不到先简化。

## 修改品牌色

只改 `_brandSeed` 一处，整个 ColorScheme 自动重新派生：

```dart
static const _brandSeed = Color(0xFF0066FF);   // ← 改这里
```

## 主题切换已内置

`shared/providers/theme_vm.dart` 已实现 `ThemeMode` 全局状态 + SharedPreferences 持久化。`app/app.dart` 订阅了它，登录页右上角 `AppBar.actions` 图标按钮一键循环切换 system → light → dark。

```dart
// 任意 widget 内切换
ref.read(themeVmProvider.notifier).toggle();

// 或指定模式
ref.read(themeVmProvider.notifier).setMode(ThemeMode.dark);

// 读当前模式
final mode = ref.watch(themeVmProvider);   // ThemeMode
```

**为什么 theme_vm 在 `shared/` 而不是 `features/`**：主题无业务领域归属（不属于 auth / user / 任何业务）→ 应用层共享状态 → `shared/providers/`。判断标准见「全局状态放哪」一节。
