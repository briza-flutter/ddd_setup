import 'package:ddd_setup/features/auth/presentation/provider/auth_session_vm.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_vm.freezed.dart';
part 'home_vm.g.dart';

@freezed
abstract class HomeVmStore with _$HomeVmStore {
  const factory HomeVmStore() = _HomeVmStore;

  factory HomeVmStore.fromJson(Map<String, dynamic> json) =>
      _$HomeVmStoreFromJson(json);
}

@riverpod
class HomeVm extends _$HomeVm {
  @override
  HomeVmStore build() {
    ref.read(authSessionVmProvider.notifier).refreshUser();
    return const HomeVmStore();
  }

  Future<void> signOut() async {
    await ref.read(authSessionVmProvider.notifier).logout();
  }
}
