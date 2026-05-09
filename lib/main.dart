import 'package:bot_toast/bot_toast.dart';
import 'package:ddd_setup/config/di.dart';
import 'package:ddd_setup/config/env_config.dart';
import 'package:ddd_setup/i18/generated/l10n.dart';
import 'package:ddd_setup/presentation/provider/user_provider.dart';
import 'package:ddd_setup/presentation/router/router_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
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

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /// 提前订阅，确保 UserVm 在首帧前完成本地认证态恢复，
    /// 同时触发 AuthRouterListenable 开始监听。
    ref.watch(userVmProvider);
    final routerConfig = di.get<AppRouterConfig>();
    return MaterialApp.router(
      title: 'Flutter Demo',
      locale: const Locale('zh', 'CN'),
      supportedLocales: [const Locale('zh', 'CN')],
      routerConfig: routerConfig.router,
      localizationsDelegates: [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      builder: BotToastInit(),
    );
  }
}
