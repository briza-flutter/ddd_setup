import 'package:ddd_setup/app/router/routes.dart';
import 'package:ddd_setup/features/auth/presentation/provider/login_vm.dart';
import 'package:ddd_setup/i18/generated/l10n.dart';
import 'package:ddd_setup/shared/providers/locale_vm.dart';
import 'package:ddd_setup/shared/providers/theme_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.watch(loginVmProvider.notifier);
    final themeMode = ref.watch(themeVmProvider);
    final locale = ref.watch(localeVmProvider);
    final s = S.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(s.loginPageTitle),
        actions: [
          IconButton(
            tooltip: s.switchLanguage,
            icon: Text(
              locale.languageCode.toUpperCase(),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            onPressed: () => ref.read(localeVmProvider.notifier).toggle(),
          ),
          IconButton(
            tooltip: '${s.switchTheme} (${themeMode.name})',
            icon: Icon(switch (themeMode) {
              ThemeMode.system => Icons.brightness_auto,
              ThemeMode.light => Icons.light_mode,
              ThemeMode.dark => Icons.dark_mode,
            }),
            onPressed: () => ref.read(themeVmProvider.notifier).toggle(),
          ),
        ],
      ),
      body: Form(
        key: vm.formKey,
        child: Column(
          children: [
            TextFormField(
              controller: vm.phoneController,
              validator: vm.validatePhone,
              decoration: InputDecoration(hintText: s.phoneHint),
            ),
            TextFormField(
              validator: vm.validatePassword,
              controller: vm.passwordController,
              decoration: InputDecoration(hintText: s.passwordHint),
            ),
            ElevatedButton(
              onPressed: () async {
                final success = await vm.login();
                if (success && context.mounted) {
                  context.go(Routes.home);
                }
              },
              child: Text(s.loginButton),
            )
          ],
        ),
      ),
    );
  }
}
