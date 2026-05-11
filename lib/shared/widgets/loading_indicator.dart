import 'package:flutter/material.dart';

/// 跨 feature 复用的 loading 组件。
class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}
