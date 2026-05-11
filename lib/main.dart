import 'package:ddd_setup/app/app.dart';
import 'package:ddd_setup/app/di.dart';
import 'package:ddd_setup/app/env_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// 环境变量读取
  await EnvConfig.init();

  /// 手动创建 ProviderContainer，并注册到 DI，
  /// 让路由 / 拦截器等非 widget 层也能读取/写入 Riverpod 状态。
  final container = ProviderContainer();
  di.registerSingleton<ProviderContainer>(container);

  /// 依赖注入配置
  await configureDependencies();

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const MyApp(),
    ),
  );
}
