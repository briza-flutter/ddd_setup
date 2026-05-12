// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name =
        (locale.countryCode?.isEmpty ?? false)
            ? locale.languageCode
            : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Flutter Demo`
  String get appTitle {
    return Intl.message('Flutter Demo', name: 'appTitle', desc: '', args: []);
  }

  /// `登录`
  String get loginPageTitle {
    return Intl.message('登录', name: 'loginPageTitle', desc: '', args: []);
  }

  /// `手机号`
  String get phoneHint {
    return Intl.message('手机号', name: 'phoneHint', desc: '', args: []);
  }

  /// `密码`
  String get passwordHint {
    return Intl.message('密码', name: 'passwordHint', desc: '', args: []);
  }

  /// `登录`
  String get loginButton {
    return Intl.message('登录', name: 'loginButton', desc: '', args: []);
  }

  /// `首页`
  String get homePageTitle {
    return Intl.message('首页', name: 'homePageTitle', desc: '', args: []);
  }

  /// `退出登录`
  String get signOutButton {
    return Intl.message('退出登录', name: 'signOutButton', desc: '', args: []);
  }

  /// `切换主题`
  String get switchTheme {
    return Intl.message('切换主题', name: 'switchTheme', desc: '', args: []);
  }

  /// `切换语言`
  String get switchLanguage {
    return Intl.message('切换语言', name: 'switchLanguage', desc: '', args: []);
  }

  /// `手机号格式不正确`
  String get invalidPhone {
    return Intl.message('手机号格式不正确', name: 'invalidPhone', desc: '', args: []);
  }

  /// `密码至少 6 位`
  String get invalidPassword {
    return Intl.message(
      '密码至少 6 位',
      name: 'invalidPassword',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'zh'),
      Locale.fromSubtags(languageCode: 'en'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
