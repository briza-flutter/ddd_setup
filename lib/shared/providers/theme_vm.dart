import 'package:ddd_setup/app/di.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_vm.g.dart';

/// 主题模式（system/light/dark）的全局状态，跨 feature 通用。
///
/// **归属**：主题没有业务领域归属 → 放 `shared/providers/`（不放 features，也不放 core，因为 core 不能依赖 SharedPreferences 这种"启动期单例"）。
///
/// **持久化**：写 SharedPreferences，下次启动自动恢复。
/// `build()` 同步读 SP（已通过 DI `@preResolve` 在启动期初始化），无需等待。
@Riverpod(keepAlive: true)
class ThemeVm extends _$ThemeVm {
  static const _key = 'theme_mode';
  late final SharedPreferences sp = di.get<SharedPreferences>();
  @override
  ThemeMode build() {
    return _parse(sp.getString(_key));
  }

  Future<void> setMode(ThemeMode mode) async {
    state = mode;
    await sp.setString(_key, mode.name);
  }

  /// 循环切换：system → light → dark → system。
  Future<void> toggle() async {
    final next = switch (state) {
      ThemeMode.system => ThemeMode.light,
      ThemeMode.light => ThemeMode.dark,
      ThemeMode.dark => ThemeMode.system,
    };
    await setMode(next);
  }

  ThemeMode _parse(String? raw) => switch (raw) {
        'light' => ThemeMode.light,
        'dark' => ThemeMode.dark,
        _ => ThemeMode.system,
      };
}
