import 'package:ddd_setup/app/di.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'locale_vm.g.dart';

/// 应用语言（locale）的全局状态，跨 feature 通用。
///
/// **归属**：无业务领域归属 → `shared/providers/`（同 theme_vm）
/// **持久化**：SharedPreferences（启动期已 @preResolve 初始化，build 同步读）
@Riverpod(keepAlive: true)
class LocaleVm extends _$LocaleVm {
  static const _key = 'locale';

  /// 支持的语言列表 —— 同步注入到 MaterialApp.supportedLocales。
  static const supported = <Locale>[
    Locale('zh'),
    Locale('en'),
  ];

  @override
  Locale build() {
    final sp = di.get<SharedPreferences>();
    return _parse(sp.getString(_key));
  }

  Future<void> setLocale(Locale locale) async {
    state = locale;
    final sp = di.get<SharedPreferences>();
    await sp.setString(_key, locale.languageCode);
  }

  /// 循环切换：zh ↔ en。后续语言变多时改成 next/prev 即可。
  Future<void> toggle() async {
    final next = state.languageCode == 'zh'
        ? const Locale('en')
        : const Locale('zh');
    await setLocale(next);
  }

  Locale _parse(String? code) => switch (code) {
        'en' => const Locale('en'),
        _ => const Locale('zh'),
      };
}
