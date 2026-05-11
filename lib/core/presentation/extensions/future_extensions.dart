import 'dart:async';

import 'package:bot_toast/bot_toast.dart';

/// 异步操作结果
typedef AsyncResult<T> = ({Object? failure, T? data});

/// Future 的异常捕获扩展
extension FutureExtensions<T> on Future<T> {
  /// 捕获异常并返回结果或错误
  ///
  /// [showLoading] 是否显示全局 loading，默认 false
  /// [showError] 是否显示错误提示 toast，默认 false
  ///
  /// 使用示例：
  /// ```dart
  /// final (:data, :failure) = await _authRepo
  ///     .signIn(email, password)
  ///     .tryCatch(showLoading: true, showError: true);
  /// ```
  Future<AsyncResult<T>> tryCatch({
    bool showLoading = false,
    bool showError = false,
  }) async {
    CancelFunc? cancelLoading;
    try {
      if (showLoading) {
        cancelLoading = BotToast.showLoading();
      }
      final data = await this;
      return (failure: null, data: data);
    } catch (e) {
      if (showError) {
        BotToast.showText(text: e.toString());
      }
      return (failure: e, data: null);
    } finally {
      cancelLoading?.call();
    }
  }
}
