# 开发指南

## 新增功能模块流程

以新增「订单」feature 为例：

**1. 建目录骨架**

```
features/order/
├── data/
│   ├── datasource/
│   ├── model/
│   └── repository/
├── domain/
│   └── entity/
└── presentation/
    ├── pages/
    └── provider/
```

**2. Domain — 定义业务实体**

```dart
// features/order/domain/entity/order.dart
// 纯领域实体，不感知任何序列化（无 fromJson/toJson）
@freezed
abstract class Order with _$Order {
  factory Order({required int id, required double amount}) = _Order;
}
```

**3. Data — API + DTO + Repository**

```dart
// features/order/data/model/order_model.dart
// DTO 在 data 层独立定义，承担 JSON 序列化职责
@freezed
abstract class OrderModel with _$OrderModel {
  factory OrderModel({required int id, required double amount}) = _OrderModel;
  factory OrderModel.fromJson(Map<String, dynamic> json) =>
      _$OrderModelFromJson(json);

  OrderModel._();
  Order get toDomain => Order(id: id, amount: amount);
}

// features/order/data/datasource/order_api.dart
@singleton
class OrderApi {
  final DioClient _dioClient;
  OrderApi(this._dioClient);
  Future<List<OrderModel>> getOrders() async { /* ... */ }
}

// features/order/data/repository/order_repository.dart
@singleton
class OrderRepository {
  final OrderApi _api;
  OrderRepository(this._api);

  Future<List<Order>> getOrders() async {
    final models = await _api.getOrders();
    return models.map((e) => e.toDomain).toList();   // DTO → Domain 在边界处转换
  }
}
```

**4. Presentation — Page + VM**

```dart
// features/order/presentation/provider/order_vm.dart
@riverpod
class OrderVm extends _$OrderVm {
  late final _orderRepo = di.get<OrderRepository>();

  @override
  OrderVmStore build() => const OrderVmStore();

  Future loadOrders() async {
    final (:data, :failure) = await _orderRepo.getOrders().tryCatch();
    // 处理结果...
  }
}
```

**5. 生成代码 & 注册路由**

```bash
dart run build_runner build --delete-conflicting-outputs
```

在 `app/router/routes.dart` 添加路由即可。

## 何时加回 UseCase 层

> **默认不加 use case，简单 CRUD 直接 `vm → repository`。复杂场景按需加，加在 feature 内的 `domain/usecase/`。**

### 该加的信号 ✓

| 信号 | 例子 |
|---|---|
| **跨多个 repository 编排** | 下单 = 商品检查 + 库存锁定 + 支付发起 + 订单创建 |
| **跨多个 feature 协作** | 退出登录 = 清 token + 清收藏列表 + 清购物车 |
| **同一业务流被多个 vm 复用** | 登录后逻辑既在 `login_vm` 用，也在第三方授权回调用 |
| **领域规则不属于任何单一 repo** | 新用户首次登录跳引导页 |
| **vm 变胖**（> 100 行 / 多个业务方法） | 需要拆出来给 vm 减负 |

### 不加的信号 ✗

- 单 repo 直通的 CRUD（`getUserInfo`、`updateNickname`）
- 只一个地方在用
- vm 里 2~3 行就能写完

### 加在哪里 / 怎么命名

```
features/auth/
├── domain/
│   ├── entity/
│   ├── value_object/
│   └── usecase/                              ← 复杂时新增
│       └── login_with_first_login_check.dart
├── data/
└── presentation/
```

- 放 `domain/usecase/`（不要新建顶层 `application/`），让复杂业务规则和它服务的 feature 在一起
- **每个 use case 一个文件，一个公开方法**（命名 `call` 或用动词）
- 用 `@injectable` 注册，构造函数注入所需 Repository

### 示例：跨 feature 的登录 use case

```dart
// features/auth/domain/usecase/login_with_first_login_check.dart
@injectable
class LoginWithFirstLoginCheck {
  final AuthRepository _auth;
  final OnboardingRepository _onboarding;   // 来自另一个 feature

  LoginWithFirstLoginCheck(this._auth, this._onboarding);

  Future<LoginOutcome> call(LoginParam param) async {
    final session = await _auth.login(param);
    final isFirstTime = await _onboarding.isFirstLogin(session.user.id);
    if (isFirstTime) {
      await _onboarding.markSeen(session.user.id);
      return LoginOutcome.needGuide(session);
    }
    return LoginOutcome.normal(session);
  }
}
```

VM 里把直接调用 `_authRepo.login()` 改成 `_loginUseCase.call()`，其他不变。

**演进路径**：先在 vm 里写 → vm 变胖或被复用 → 抽到 `domain/usecase/`。**不要预先建空 use case**。

## 命名约定

| 类型 | 后缀 | 位置 | 文件命名 | 用途 |
|------|------|------|----------|------|
| Entity | 无 | `features/*/domain/entity/` | `user.dart` | 领域实体，核心业务模型 |
| Value Object | 无 | `features/*/domain/value_object/` | `credentials.dart` | 带验证逻辑的值类型 |
| Param | `XxxParam` | `features/*/domain/entity/` | `login_param.dart` | Repository / UseCase 的入参 |
| Result | `XxxResult` | `features/*/domain/entity/` | `auth_result.dart` | Repository / UseCase 的复合返回值 |
| DTO | `XxxDto` | `features/*/data/model/` | `login_dto.dart` | 请求体（发给服务端） |
| Model | `XxxModel` | `features/*/data/model/` | `user_model.dart` | 响应体（来自服务端），含 `toDomain` / `fromDomain` |
| Repository | `XxxRepository` | `features/*/data/repository/` | `auth_repository.dart` | 编排 API + 本地存储（具体类，不抽接口） |
| UseCase（按需） | 动词 / `Call` | `features/*/domain/usecase/` | `login_with_xxx.dart` | 跨 repo / 跨 feature 的复杂编排 |
| State | `XxxVmStore` / `XxxStore` | `features/*/presentation/provider/` | 同 vm 文件内 | 页面 / 全局状态（freezed 不可变） |

## 入参 / 返回值规范

> **核心原则：同一业务方法在 Repository / UseCase / VM 三层入参类型一致，不要在某一层拆成命名参数。**

### 入参

| 字段数量 | 形态 | 形参变量名 | 示例 |
|---|---|---|---|
| 单个基础类型 | 直传 | 业务名 | `getUserInfo(int userId)` |
| ≥2 个字段 / 含值对象 / 含复杂结构 | `XxxParam`（domain 层 freezed） | `param` | `login(LoginParam param)` |

- **Repository、UseCase、VM 的同名方法保持入参类型一致**，VM 不要把 `Param` 拆成命名参数（避免每加一个字段就改三层签名）。
- DTO 不暴露给 Repository / VM。Repository 内部从 `Param` 构造 `Dto` 后传给 Api。
- Api 层形参名用 `dto`（如 `login(LoginDto dto)`），不用 `loginDto` 这种"类型重复"的命名。
- ValueObject 字段名直接用业务名，**不加 `Obj` 后缀**。`password` ✓，`passwordObj` ✗。

### 返回值

| 场景 | 形态 | 示例 |
|---|---|---|
| 单值 | 直接返回领域类型 | `Future<User>` |
| 多值且语义明确 | `XxxResult`（domain 层 freezed） | `Future<AuthResult>` |
| 跨层 record | **禁止** | ~~`Future<(User, Token)>`~~ |

- record 只允许在**单文件内部**短期使用，**不可跨层暴露**。
- Api 层返回 `Model`（data 类型），Repository 负责 `model.toDomain` 转换为 Domain Entity 或 `Result`。

### 三层调用示例

```dart
// features/auth/domain/entity/login_param.dart
@freezed
abstract class LoginParam with _$LoginParam {
  factory LoginParam({required PhoneNumber phoneNumber, required Password password})
      = _LoginParam;
}

// features/auth/data/repository/auth_repository.dart
@singleton
class AuthRepository {
  Future<AuthResult> login(LoginParam param) async {
    final model = await _authApi.login(LoginDto(
      username: param.phoneNumber.value,
      password: param.password.value,
    ));
    final result = model.toDomain;                           // ← Model → Result
    await _localStorage.setToken(result.token);
    await _localStorage.setUser(result.user);
    return result;
  }
}

// features/auth/presentation/provider/auth_session_vm.dart
@Riverpod(keepAlive: true)
class AuthSessionVm extends _$AuthSessionVm {
  Future<AuthResult> login(LoginParam param) async {          // ← 同一类型贯通
    final res = await _authRepo.login(param);
    state = AuthSessionStore(user: res.user, token: res.token);
    return res;
  }
}
```

## DI 注册：`@singleton` vs `@lazySingleton`

> **凡是构造函数里访问 Riverpod / 链式触发其他 DI 依赖的类，必须用 `@lazySingleton`，而不是 `@singleton`。**

**原因**：`@singleton` 在 `configureDependencies()` 内部被**急切构造**，构造顺序按依赖图拓扑排序。如果某个类的构造函数里有副作用（监听 Provider、读取其他 Repository 等），可能踩到"被依赖项尚未注册"的窗口，抛 `StateError: Object/factory with type X is not registered inside GetIt`。

`@lazySingleton` 把构造延迟到首次 `di.get<>()` 调用，那时 init 已全部完成，整条依赖链都可解析。

**典型场景**（本模板中的 `AuthRouterListenable`）：

```dart
@lazySingleton  // ← 必须 lazy
class AuthRouterListenable extends ChangeNotifier {
  AuthRouterListenable(this._container) {
    // 构造函数里立即订阅 Riverpod，会触发 AuthSessionVm.build → di.get<AuthRepository>()
    _container.listen<AuthSessionStore>(authSessionVmProvider, ..., fireImmediately: true);
  }
}
```

如果用 `@singleton`，DI init 阶段构造它时，`AuthRepository`（拓扑排序在后）还没注册 → 报错。

**判断标准**：

| 用 `@singleton` | 用 `@lazySingleton` |
|---|---|
| 构造函数只赋值字段 | 构造函数有副作用（订阅、IO、调用其他 Repository） |
| 仅依赖已注册的早期对象 | 间接依赖晚期对象（通过 Riverpod / 回调等绕一圈） |
| 启动期就需要存在（如 SharedPreferences） | 只在 UI/路由层第一次访问时才需要 |
