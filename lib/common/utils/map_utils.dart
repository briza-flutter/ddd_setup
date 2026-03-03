/// Map 嵌套取值工具类
class MapUtils {
  MapUtils._();

  /// 通过点分隔路径获取嵌套 Map 中的值
  ///
  /// ```dart
  /// final map = {"data": {"user": {"token": "abc123"}}};
  /// final token = MapUtils.getNestedValue(map, "data.user.token"); // "abc123"
  /// ```
  static T? getNestedValue<T>(Map<String, dynamic>? map, String path) {
    if (map == null || path.isEmpty) return null;

    final keys = path.split('.');
    dynamic current = map;

    for (final key in keys) {
      if (current is Map<String, dynamic> && current.containsKey(key)) {
        current = current[key];
      } else {
        return null;
      }
    }

    return current is T ? current : null;
  }
}

/// Map 扩展方法，支持通过点路径取值
extension NestedMapExtension on Map<String, dynamic> {
  /// 通过点分隔路径获取嵌套值
  ///
  /// ```dart
  /// final map = {"data": {"user": {"token": "abc123"}}};
  /// final token = map.nested<String>("data.user.token"); // "abc123"
  /// ```
  T? nested<T>(String path) => MapUtils.getNestedValue<T>(this, path);
}
