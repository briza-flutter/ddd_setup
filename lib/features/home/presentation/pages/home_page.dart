import 'package:ddd_setup/features/home/presentation/provider/home_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.watch(homeVmProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        title: const Text('home_page'),
      ),
      body: Center(
        child: Column(
          children: [
            Text('home_page'),
            ElevatedButton(onPressed: vm.signOut, child: Text('Sign Out'))
          ],
        ),
      ),
    );
  }
}
