import 'dart:convert';
import 'package:flutter/services.dart';

/// 用Prod.json 的值作为默认值
class EnvConfig {
  static Map<String, dynamic>? _envMap;

  /// 环境变量 dev、stag、prod
  /// 默认为 prod
  static const env = String.fromEnvironment('env', defaultValue: 'prod');
  static const isDev = env == 'dev';
  static const isProd = env == 'prod';
  static const isTest = env == 'stag';

  /// android flavor
  static const androidFlavor =
      String.fromEnvironment('androidFlavor', defaultValue: 'china');
  static bool isAndroidChina = androidFlavor == "china";

  static Future<void> init() async {
    try {
      final String jsonString = await rootBundle.loadString('env/$env.json');
      final r = json.decode(jsonString) as Map<String, dynamic>;
      _envMap = r;
    } catch (e) {
      throw Exception('Failed to load env config: $e');
    }
  }

  static T _getValue<T>(String key) {
    if (_envMap == null) {
      throw Exception(
          'EnvConfig not initialized. Call EnvConfig.init() first.');
    }
    return _envMap![key] as T;
  }

  static final baseUrl = _getValue<String>('baseUrl');
}
