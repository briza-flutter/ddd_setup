import 'package:ddd_setup/common/presentation/extensions/future_extensions.dart';
import 'package:ddd_setup/common/utils/app_logger.dart';
import 'package:ddd_setup/config/di.dart';
import 'package:ddd_setup/domain/auth/value_object.dart';
import 'package:ddd_setup/presentation/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'login_vm.freezed.dart';
part 'login_vm.g.dart';

@freezed
abstract class LoginVmStore with _$LoginVmStore {
  const factory LoginVmStore() = _LoginVmStore;

  factory LoginVmStore.fromJson(Map<String, dynamic> json) =>
      _$LoginVmStoreFromJson(json);
}

@riverpod
class LoginVm extends _$LoginVm {
  late final TextEditingController phoneController = TextEditingController();

  late final TextEditingController passwordController = TextEditingController();
  final AppLogger _logger = di.get<AppLogger>();
  @override
  LoginVmStore build() {
    return const LoginVmStore();
  }

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  Future<bool> login() async {
    final r = formKey.currentState?.validate();
    if (r != true) return false;
    final phone = phoneController.text;
    final password = passwordController.text;
    final phoneNumber = PhoneNumber.create(phone).valueOrNull();
    final passwordObj = Password.create(password).valueOrNull();
    if (phoneNumber == null || passwordObj == null) {
      return false;
    }
    _logger.d("Logging in with phone: $phone and password: $password");
    final (:data, :failure) = await ref
        .read(userVmProvider.notifier)
        .login(phoneNumber: phoneNumber, passwordObj: passwordObj)
        .tryCatch(showLoading: true, showError: true);
    return failure == null;
  }

  String? validatePhone(String? value) {
    final r = PhoneNumber.create(value ?? "");
    final res = r.valueOrNull();
    if (res == null) {
      return "Invalid phone number";
    }
    return null;
  }

  String? validatePassword(String? value) {
    final r = Password.create(value ?? "");
    final res = r.valueOrNull();
    if (res == null) {
      return "Invalid password";
    }
    return null;
  }
}
