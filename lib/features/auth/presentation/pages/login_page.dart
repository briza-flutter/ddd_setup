import 'package:ddd_setup/app/router/routes.dart';
import 'package:ddd_setup/features/auth/presentation/provider/login_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.watch(loginVmProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        title: const Text('login_page'),
      ),
      body: Form(
        key: vm.formKey,
        child: Column(
          children: [
            TextFormField(
              controller: vm.phoneController,
              validator: vm.validatePhone,
              decoration: const InputDecoration(hintText: "phone number"),
            ),
            TextFormField(
              validator: vm.validatePassword,
              controller: vm.passwordController,
              decoration: const InputDecoration(hintText: "password"),
            ),
            ElevatedButton(
              onPressed: () async {
                final success = await vm.login();
                if (success && context.mounted) {
                  context.go(Routes.home);
                }
              },
              child: Text("login"),
            )
          ],
        ),
      ),
    );
  }
}
