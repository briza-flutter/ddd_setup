# DDD Setup

基于 Flutter 的 DDD（领域驱动设计）+ Clean Architecture 项目模板。

## 技术栈

| 分类 | 技术 | 说明 |
|------|------|------|
| 框架 | Flutter 3.x / Dart ^3.6.2 | 多平台支持 |
| 状态管理 | Riverpod + riverpod_generator | UI 层响应式状态 |
| 依赖注入 | Injectable + GetIt | 服务层自动 DI |
| 路由 | GoRouter + go_transitions | 声明式路由 + 转场动画 |
| 网络 | Dio | HTTP 客户端 + 拦截器链 |
| 数据类 | Freezed + json_serializable | 不可变模型 + JSON 序列化 |
| 本地存储 | SharedPreferences | 轻量 KV 缓存 |
| 国际化 | flutter_intl | 多语言支持（默认中文） |
| Toast | BotToast | 全局提示 |
| 日志 | Logger | 调试日志 |

## 目录结构

```
lib/
├── main.dart                          # 入口：初始化环境 → DI → 启动 App
├── config/
│   ├── di.dart                        # GetIt + Injectable DI 配置
│   └── env_config.dart                # 环境变量（dev/stag/prod）
│
├── domain/                            # 领域层（纯业务逻辑，零框架依赖）
│   ├── auth/
│   │   ├── models/
│   │   │   ├── login_param.dart       #   LoginParam（登录入参）
│   │   │   └── auth_result.dart       #   AuthResult（登录结果）
│   │   ├── repositories/
│   │   │   ├── auth_repo.dart         #   AuthRepo 抽象（远程认证）
│   │   │   └── local_auth_storage.dart #  LocalAuthStorage 抽象（本地存储）
│   │   └── value_object.dart          #   PhoneNumber / Password 值对象
│   └── user/
│       ├── entity/
│       │   └── user.dart              #   User 实体
│       └── repositories/
│           └── user_repo.dart         #   UserRepo 抽象
│
├── application/                       # 应用层（用例编排，仅依赖 Domain 层）
│   ├── auth/
│   │   └── auth_use_case.dart         #   登录、登出、本地数据读取
│   └── user/
│       └── user_use_case.dart         #   获取用户信息
│
├── infrastructure/                    # 基础设施层（接口实现 + 外部依赖）
│   ├── remote_data/
│   │   ├── http_client/
│   │   │   ├── dio_client.dart        #   Dio 封装（get/post）
│   │   │   └── interceptors/
│   │   │       ├── auth_interceptor.dart      # Bearer Token 注入
│   │   │       ├── response_interceptor.dart  # 响应 code != 200 转异常
│   │   │       └── error_interceptor.dart     # 全局错误回调
│   │   ├── api/
│   │   │   ├── auth/
│   │   │   │   ├── auth.dart          #   AuthApi（登录接口）
│   │   │   │   └── models/login_dto.dart  #   LoginDto（请求体）
│   │   │   └── user/
│   │   │       ├── user.dart          #   UserApi（用户接口）
│   │   │       └── models/user_model.dart #   UserModel（响应体 → Domain 转换）
│   │   └── impl/
│   │       ├── auth_repo_impl.dart    #   AuthRepo 实现
│   │       └── user_repo_impl.dart    #   UserRepo 实现
│   └── local_data/
│       └── impl/
│           └── local_auth_storage_impl.dart  # LocalAuthStorage 实现（SP）
│
├── presentation/                      # 展示层（UI + ViewModel）
│   ├── pages/
│   │   ├── auth/login/
│   │   │   ├── login_page.dart        #   登录页面
│   │   │   └── login_vm.dart          #   登录 ViewModel
│   │   └── root/
│   │       ├── root_page.dart         #   首页
│   │       └── root_vm.dart           #   首页 ViewModel
│   ├── provider/
│   │   └── user_provider.dart         #   全局用户状态（keepAlive）
│   └── router/
│       ├── router_config.dart         #   GoRouter 配置 + 鉴权守卫
│       └── routes.dart                #   路由路径定义
│
├── common/                            # 公共层（跨层共享工具）
│   ├── domain/
│   │   ├── errors.dart                #   Failure 异常体系
│   │   └── value_object.dart          #   ValueObject 基类
│   ├── event/
│   │   └── dio_interceptor_handler.dart #  拦截器回调桥接
│   ├── presentation/extensions/
│   │   └── future_extensions.dart     #   tryCatch() 异步异常捕获
│   └── utils/
│       ├── app_logger.dart            #   日志单例
│       └── map_utils.dart             #   Map 嵌套取值工具
│
└── i18/                               # 国际化
    ├── l10n/                          #   arb 翻译源文件
    └── generated/                     #   生成的 Dart 文件

env/                                   # 环境配置
├── dev.json                           #   开发环境
├── stag.json                          #   预发布环境
└── prod.json                          #   生产环境
```

## 分层依赖规则

```
Presentation → Application → Domain ← Infrastructure
                                ↑              |
                                └──────────────┘
                               （实现 Domain 的抽象接口）
```

- **Domain**：纯 Dart，不依赖任何外部包。定义实体、值对象、Repository 抽象
- **Application**：仅依赖 Domain 层。编排用例逻辑，不关心具体实现
- **Infrastructure**：实现 Domain 层定义的抽象接口，处理网络/存储等外部依赖
- **Presentation**：UI + ViewModel，通过 Riverpod 管理状态，通过 `di.get<>()` 获取 UseCase
- **Common**：跨层共享的基础工具（Failure 定义、ValueObject 基类、扩展方法）

## 开发指南

### 新增功能模块流程

以新增「订单」模块为例：

**1. Domain 层 — 定义业务核心**

```dart
// lib/domain/order/entity/order.dart
// 纯领域实体，不感知任何序列化（无 fromJson/toJson）
@freezed
abstract class Order with _$Order {
  factory Order({required int id, required double amount}) = _Order;
}

// lib/domain/order/repositories/order_repo.dart
abstract class OrderRepo {
  Future<List<Order>> getOrders();
}
```

**2. Infrastructure 层 — 实现接口**

```dart
// lib/infrastructure/remote_data/api/order/models/order_model.dart
// DTO 在 infra 层独立定义，承担 JSON 序列化职责
@freezed
abstract class OrderModel with _$OrderModel {
  factory OrderModel({required int id, required double amount}) = _OrderModel;
  factory OrderModel.fromJson(Map<String, dynamic> json) =>
      _$OrderModelFromJson(json);
  factory OrderModel.fromDomain(Order o) =>
      OrderModel(id: o.id, amount: o.amount);

  OrderModel._();
  Order get toDomain => Order(id: id, amount: amount);
}

// lib/infrastructure/remote_data/api/order/order.dart
@singleton
class OrderApi {
  final DioClient _dioClient;
  OrderApi(this._dioClient);
  Future<List<OrderModel>> getOrders() async { ... }
}

// lib/infrastructure/remote_data/impl/order_repo_impl.dart
@Singleton(as: OrderRepo)
class OrderRepoImpl implements OrderRepo {
  final OrderApi _orderApi;
  OrderRepoImpl(this._orderApi);
  @override
  Future<List<Order>> getOrders() async {
    final models = await _orderApi.getOrders();
    return models.map((e) => e.toDomain).toList();   // DTO → Domain 在边界处转换
  }
}
```

**3. Application 层 — 编排用例**

```dart
// lib/application/order/order_use_case.dart
@injectable
class OrderUseCase {
  final OrderRepo _orderRepo;
  OrderUseCase(this._orderRepo);
  Future<List<Order>> getOrders() => _orderRepo.getOrders();
}
```

**4. Presentation 层 — UI + 状态**

```dart
// lib/presentation/pages/order/order_vm.dart
@riverpod
class OrderVm extends _$OrderVm {
  late final _orderUseCase = di.get<OrderUseCase>();
  @override
  OrderVmStore build() => const OrderVmStore();
  Future loadOrders() async {
    final (:data, :failure) = await _orderUseCase.getOrders().tryCatch();
    // 处理结果...
  }
}
```

**5. 生成代码 & 注册路由**

```bash
dart run build_runner build --delete-conflicting-outputs
```

在 `routes.dart` 中添加新路由即可。

### 命名约定

| 类型 | 后缀 | 位置 | 文件命名 | 用途 |
|------|------|------|----------|------|
| Entity | 无 | `domain/*/entity/` | `user.dart` | 领域实体，核心业务模型 |
| Value Object | 无 | `domain/*/value_object.dart` | `value_object.dart` | 带验证逻辑的值类型 |
| Param | `XxxParam` | `domain/*/models/` | `login_param.dart` | Repository / UseCase 的入参 |
| Result | `XxxResult` | `domain/*/models/` | `auth_result.dart` | Repository / UseCase 的复合返回值 |
| DTO | `XxxDto` | `infrastructure/.../models/` | `login_dto.dart` | 请求体（发给服务端） |
| Model | `XxxModel` | `infrastructure/.../models/` | `user_model.dart` | 响应体（来自服务端），含 `toDomain` / `fromDomain` 转换 |
| State | `XxxVmStore` / `XxxStore` | `presentation/.../` | `login_vm.dart` 内 | 页面/全局状态（freezed 不可变） |

### 入参 / 返回值规范

> **核心原则：同一业务方法在 Repo / UseCase / VM 三层入参类型一致，不要在某一层拆成命名参数。**

#### 入参

| 字段数量 | 形态 | 形参变量名 | 示例 |
|---|---|---|---|
| 单个基础类型 | 直传 | 业务名 | `getUserInfo(int userId)` |
| ≥2 个字段 / 含值对象 / 含复杂结构 | `XxxParam`（domain 层定义，freezed） | `param` | `login(LoginParam param)` |

- **Repository、UseCase、VM 的同名方法保持入参类型一致**，VM 不要把 `Param` 拆成命名参数（避免每加一个字段就改三层签名）。
- DTO 不暴露给 Repo/UseCase。Repo 实现层内部从 `Param` 构造 `Dto` 后传给 Api。
- Api 层形参名用 `dto`（如 `login(LoginDto dto)`），不用 `loginDto` 这种"类型重复"的命名。
- ValueObject 字段名直接用业务名，**不加 `Obj` 后缀**。`password` ✓ ，`passwordObj` ✗。

#### 返回值

| 场景 | 形态 | 示例 |
|---|---|---|
| 单值 | 直接返回领域类型 | `Future<User>` |
| 多值且语义明确 | `XxxResult`（domain 层 freezed） | `Future<AuthResult>` |
| 跨层 record | **禁止** | ~~`Future<(User, Token)>`~~ |

- record 只允许在**单文件内部**短期使用，**不可跨层暴露**。
- Api 层返回 `Model`（infra 类型），Repository 实现层负责 `model.toDomain` 转换为 Domain 实体或 `Result`。

#### 三层调用示例（推荐写法）

```dart
// Domain
@freezed
abstract class LoginParam with _$LoginParam {
  factory LoginParam({required PhoneNumber phoneNumber, required Password password})
      = _LoginParam;
}

abstract class AuthRepo {
  Future<AuthResult> login(LoginParam param);
}

// Application
@singleton
class AuthUseCase {
  Future<AuthResult> login(LoginParam param) => _authRepo.login(param);
}

// Presentation
@Riverpod(keepAlive: true)
class UserVm extends _$UserVm {
  Future<AuthResult> login(LoginParam param) async {           // ← 同一类型贯通
    final res = await _authUseCase.login(param);
    state = state.copyWith(user: res.user, token: res.token);
    return res;
  }
}

// Infrastructure（Repo 实现层做 Param → Dto 的边界转换）
@Singleton(as: AuthRepo)
class AuthRepoImpl implements AuthRepo {
  @override
  Future<AuthResult> login(LoginParam param) async {
    final model = await _authApi.login(LoginDto(
      username: param.phoneNumber.value,
      password: param.password.value,
    ));
    return model.toDomain;                                      // ← Model → Result
  }
}
```

### DI 注册：`@singleton` vs `@lazySingleton`

> **凡是构造函数里访问 Riverpod / 链式触发其他 DI 依赖的类，必须用 `@lazySingleton`，而不是 `@singleton`。**

**原因**：`@singleton` 在 `configureDependencies()` 内部被**急切构造**，构造顺序按依赖图拓扑排序。如果某个类的构造函数里有副作用（监听 Provider、读取其他 UseCase 等），可能踩到"被依赖项尚未注册"的窗口，抛 `StateError: Object/factory with type X is not registered inside GetIt`。

`@lazySingleton` 把构造延迟到首次 `di.get<>()` 调用，那时 init 已全部完成，整条依赖链都可解析。

**典型场景**（本模板中的 `AuthRouterListenable`）：

```dart
@lazySingleton  // ← 必须 lazy
class AuthRouterListenable extends ChangeNotifier {
  AuthRouterListenable(this._container) {
    // 构造函数里立即订阅 Riverpod，会触发 UserVm.build → di.get<AuthUseCase>()
    _container.listen<UserStore>(userVmProvider, ..., fireImmediately: true);
  }
}
```

如果用 `@singleton`，DI init 阶段构造它时，`AuthUseCase`（拓扑排序在后）还没注册 → 报错。

**判断标准**：

| 用 `@singleton` | 用 `@lazySingleton` |
|---|---|
| 构造函数只赋值字段 | 构造函数有副作用（订阅、IO、调用其他 UseCase） |
| 仅依赖已注册的早期对象 | 间接依赖晚期对象（通过 Riverpod / 回调等绕一圈） |
| 启动期就需要存在（如 SharedPreferences） | 只在 UI/路由层第一次访问时才需要 |

### 环境切换

```bash
# 开发环境
flutter run --dart-define=env=dev

# 预发布
flutter run --dart-define=env=stag

# 生产（默认）
flutter run
```

### 常用命令

```bash
# 代码生成（Freezed / Injectable / Riverpod）
dart run build_runner build --delete-conflicting-outputs

# 持续监听文件变化自动生成
dart run build_runner watch --delete-conflicting-outputs

# 国际化生成
flutter pub run intl_utils:generate
```
