# 全局状态放哪

> **核心原则：归属大于通用性。** 不要因为"很多 feature 都用"就搬到全局目录——先问"它属于哪个业务领域"。
>
> **"全局"是讲生命周期（`@Riverpod(keepAlive: true)`），不是物理位置。** vm 放哪取决于"它管什么领域"，不取决于"谁来用它"。

## 放置规则

| 数据 | 归属 | 放哪 |
|---|---|---|
| 登录态 / token | auth 领域 | `features/auth/presentation/provider/auth_session_vm.dart` |
| 用户详情（昵称、头像、偏好） | user 领域 | `features/user/presentation/provider/user_profile_vm.dart` |
| 购物车 | cart 领域 | `features/cart/presentation/provider/cart_vm.dart` |
| 主题 / 语言 / 网络状态 | **无业务归属** | `shared/providers/` 或 `app/providers/` |

判断流程：

```
                  这个 vm/状态属于哪个业务领域？
                            │
              ┌─────────────┴─────────────┐
              ▼                           ▼
      属于某个具体领域            无业务归属（主题/语言/网络）
      （user, cart, auth）                 │
              │                           ▼
              ▼                   shared/providers/ 或 app/providers/
   features/<x>/presentation/provider/
              │
              ▼
       加 @Riverpod(keepAlive: true)
              │
              ▼
       其他 feature 通过 import 直接 ref.watch / ref.read
```

## 示例：用户详情跨页面修改

需求：首页显示昵称、设置页改昵称、详情页刷新——**全局单一事实来源**。

放在 `features/user/`，所有页面读写同一个 vm：

```dart
// features/user/presentation/provider/user_profile_vm.dart
@freezed
abstract class UserProfileStore with _$UserProfileStore {
  factory UserProfileStore({required User? user}) = _UserProfileStore;
}

@Riverpod(keepAlive: true)
class UserProfileVm extends _$UserProfileVm {
  late final _userRepo = di.get<UserRepository>();

  @override
  UserProfileStore build() {
    /// 监听 auth_session：登出时自动清空
    final session = ref.watch(authSessionVmProvider);
    if (session.token == null) return UserProfileStore(user: null);
    return UserProfileStore(user: session.user);
  }

  Future<void> refresh() async {
    final id = state.user?.id;
    if (id == null) return;
    final fresh = await _userRepo.getUserInfo(id);
    state = state.copyWith(user: fresh);
  }

  Future<void> updateNickname(String nickname) async {
    final id = state.user?.id;
    if (id == null) return;
    await _userRepo.updateNickname(id, nickname);
    state = state.copyWith(user: state.user?.copyWith(name: nickname));
  }
}
```

各页面使用：

```dart
// home 页：只读
final name = ref.watch(userProfileVmProvider).user?.name;

// settings 页：写
ref.read(userProfileVmProvider.notifier).updateNickname("新昵称");

// detail 页：刷新
ref.read(userProfileVmProvider.notifier).refresh();
```

## auth_session_vm vs user_profile_vm 的边界

两者职责分离，**单向依赖**（user_profile 监听 auth_session，反之不可）：

| vm | 职责 | 字段 |
|---|---|---|
| `auth_session_vm` | 登录态、token、路由鉴权 | `token`、最小 `user`（id + name 用于显示） |
| `user_profile_vm` | 完整用户档案，所有 user 业务的单一事实来源 | 详细 `user`（含头像、偏好、扩展字段） |

模板项目目前只有 `auth_session_vm` 已够用，业务真扩展时再加 `user_profile_vm`。

## 真正"无业务归属"的全局状态

少数情况，例如主题切换、网络状态、全局错误。**实际极少**，不要预先建空目录，等用到时再建：

```
shared/providers/theme_vm.dart        # 跨 feature 业务无关
app/providers/connectivity_vm.dart    # 应用级基础状态
```

## 反模式 ✗

| 反模式 | 为什么错 | 正解 |
|---|---|---|
| 建 `lib/global/`、`lib/state/` 顶级目录收纳"全局 vm" | 按"通用性"分类，掩盖业务归属 | 按领域归属放在 feature 内 |
| 因为"home 也要用"就把 `user_profile_vm` 搬到 `shared/` | 通用性不是搬家理由 | 留在 `features/user/`，home 直接 import |
| 一个超级 vm 同时管 auth + user + cart | 巨石 vm，难维护、难测试 | 拆成多个 vm，单向监听协作 |
| 多个 vm 各自缓存一份 user，更新时手动同步 | 多事实来源，必出同步 bug | 单一 vm，其他地方 `ref.watch` |
| page 里直接 `di.get<UserRepository>()` 读取数据 | 绕过 vm，状态分散 | 永远走 vm，vm 是唯一对外接口 |
