import 'package:bot_toast/bot_toast.dart';
import 'package:ddd_setup/config/di.dart';
import 'package:ddd_setup/config/env_config.dart';
import 'package:ddd_setup/i18/generated/l10n.dart';
import 'package:ddd_setup/presentation/provider/user_provider.dart';
import 'package:ddd_setup/presentation/router/router_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// 环境变量读取
  await EnvConfig.init();

  /// 依赖注入配置
  await configureDependencies();

  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  _initProviders(WidgetRef ref) {
    ref.read(userVmProvider);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /// 初始化全局 provider
    _initProviders(ref);
    final routerConfig = di.get<AppRouterConfig>();
    return MaterialApp.router(
      title: 'Flutter Demo',
      routerConfig: routerConfig.router,
      localizationsDelegates: [S.delegate],
      builder: BotToastInit(),
    );
  }
}
