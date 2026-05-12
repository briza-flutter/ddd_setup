import 'package:ddd_setup/core/presentation/extensions/future_extensions.dart';
import 'package:ddd_setup/features/auth/domain/entity/login_param.dart';
import 'package:ddd_setup/features/auth/domain/value_object/credentials.dart';
import 'package:ddd_setup/features/auth/presentation/provider/auth_session_vm.dart';
import 'package:ddd_setup/i18/generated/l10n.dart';
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

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  LoginVmStore build() {
    return const LoginVmStore();
  }

  Future<bool> login() async {
    if (formKey.currentState?.validate() != true) return false;
    final phoneNumber = PhoneNumber.create(phoneController.text).valueOrNull();
    final password = Password.create(passwordController.text).valueOrNull();
    if (phoneNumber == null || password == null) return false;

    final (:data, :failure) = await ref
        .read(authSessionVmProvider.notifier)
        .login(LoginParam(phoneNumber: phoneNumber, password: password))
        .tryCatch(showLoading: true, showError: true);
    return failure == null;
  }

  String? validatePhone(String? value) {
    if (PhoneNumber.create(value ?? "").valueOrNull() == null) {
      return S.current.invalidPhone;
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (Password.create(value ?? "").valueOrNull() == null) {
      return S.current.invalidPassword;
    }
    return null;
  }
}
