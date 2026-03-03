import 'package:ddd_setup/presentation/pages/root/root_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RootPage extends ConsumerWidget {
  const RootPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(rootVmProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('root_page'),
      ),
    );
  }
}
