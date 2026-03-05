import 'package:ddd_setup/presentation/provider/user_provider.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'root_vm.freezed.dart';
part 'root_vm.g.dart';

@freezed
abstract class RootVmStore with _$RootVmStore {
  const factory RootVmStore() = _RootVmStore;

  factory RootVmStore.fromJson(Map<String, dynamic> json) =>
      _$RootVmStoreFromJson(json);
}

@riverpod
class RootVm extends _$RootVm {
  @override
  RootVmStore build() {
    ref.read(userVmProvider.notifier).updateUserInfo();
    return const RootVmStore();
  }

  Future signOut() async {
    await ref.read(userVmProvider.notifier).logout();
  }
}
