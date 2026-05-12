import 'dart:async';

import 'package:flutter/foundation.dart';

/// 简单防抖器：在最近一次调用 [run] 之后等待 [duration]，
/// 如果在等待期结束时仍未被新的调用覆盖，则执行传入的 [action]
///
/// 典型场景：搜索框输入即查询、表单字段联动校验。
///
/// ```dart
/// final _debouncer = Debouncer(duration: const Duration(milliseconds: 300));
/// _debouncer(() => search(text));
/// // 在 State.dispose 中调用 _debouncer.dispose();
/// ```
class Debouncer {
  final Duration duration;
  Timer? _timer;

  Debouncer({Duration? duration})
      : duration = duration ?? const Duration(milliseconds: 500);

  /// 普通防抖：只有在间隔内最后一次调用会被执行。
  void run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(duration, () {
      action();
      _timer = null;
    });
  }

  /// 首触发（leading）模式：第一次立即执行，随后在间隔期内阻止后续调用。
  void runLeading(VoidCallback action) {
    final shouldCall = _timer == null;
    _timer?.cancel();
    _timer = Timer(duration, () {
      _timer = null;
    });
    if (shouldCall) action();
  }

  /// 取消任何待执行的防抖任务。
  void cancel() {
    _timer?.cancel();
    _timer = null;
  }
}

/// 支持传参的防抖器，适用于像 `onChanged` 这种需要传入最新参数的回调场景。
class DebouncerWithArg<T> {
  final Duration duration;
  Timer? _timer;

  DebouncerWithArg({Duration? duration})
      : duration = duration ?? const Duration(milliseconds: 500);

  /// 普通防抖（带参数）：当计时器触发时，会将最新的 [value] 传给 [action] 并执行。
  void run(void Function(T value) action, T value) {
    _timer?.cancel();
    _timer = Timer(duration, () {
      action(value);
    });
  }

  /// 首触发（带参数）：如果允许则立即执行一次，然后在间隔期内阻止后续调用。
  void runLeading(void Function(T value) action, T value) {
    final shouldCall = _timer == null;
    _timer?.cancel();
    _timer = Timer(duration, () {
      _timer = null;
    });
    if (shouldCall) action(value);
  }

  /// 取消任何待执行的防抖任务。
  void cancel() {
    _timer?.cancel();
    _timer = null;
  }
}

/// 节流：连续触发只放过第一次，间隔 [interval] 内的后续触发返回 `false`。
///
/// 典型场景：按钮防连点、滚动加载、上报埋点频次控制。
///
/// ```dart
/// final _throttler = Throttler(interval: const Duration(seconds: 1));
/// onPressed: () {
///   if (!_throttler(() => submit())) return; // 1s 内重复点击直接忽略
/// }
/// ```
class Throttler {
  final Duration interval;
  DateTime? _lastFire;

  Throttler({this.interval = const Duration(seconds: 1)});

  bool call(VoidCallback action) {
    final now = DateTime.now();
    if (_lastFire != null && now.difference(_lastFire!) < interval) {
      return false;
    }
    _lastFire = now;
    action();
    return true;
  }

  void reset() => _lastFire = null;
}
