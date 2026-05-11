import 'package:bot_toast/bot_toast.dart';
import 'package:ddd_setup/app/di.dart';
import 'package:ddd_setup/app/router/app_router.dart';
import 'package:ddd_setup/features/auth/presentation/provider/auth_session_vm.dart';
import 'package:ddd_setup/i18/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /// 提前订阅，确保 AuthSessionVm 在首帧前完成本地认证态恢复，
    /// 同时触发 AuthRouterListenable 开始监听。
    ref.watch(authSessionVmProvider);
    final routerConfig = di.get<AppRouterConfig>();
    return MaterialApp.router(
      title: 'Flutter Demo',
      locale: const Locale('zh', 'CN'),
      supportedLocales: const [Locale('zh', 'CN')],
      routerConfig: routerConfig.router,
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      builder: BotToastInit(),
    );
  }
}
