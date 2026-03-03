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
│   │   │   ├── auth_data.dart         #   LoginData（登录入参）
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
│   │   │   │   └── models/dto.dart    #   LoginDto（请求体）
│   │   │   └── user/
│   │   │       ├── user.dart          #   UserApi（用户接口）
│   │   │       └── models/vo.dart     #   UserVo（响应体 → Domain 转换）
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
@freezed
abstract class Order with _$Order {
  factory Order({required int id, required double amount}) = _Order;
  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);
}

// lib/domain/order/repositories/order_repo.dart
abstract class OrderRepo {
  Future<List<Order>> getOrders();
}
```

**2. Infrastructure 层 — 实现接口**

```dart
// lib/infrastructure/remote_data/api/order/order.dart
@singleton
class OrderApi {
  final DioClient _dioClient;
  OrderApi(this._dioClient);
  Future<List<OrderVo>> getOrders() async { ... }
}

// lib/infrastructure/remote_data/impl/order_repo_impl.dart
@Injectable(as: OrderRepo)
class OrderRepoImpl implements OrderRepo {
  final OrderApi _orderApi;
  OrderRepoImpl(this._orderApi);
  @override
  Future<List<Order>> getOrders() async {
    final vos = await _orderApi.getOrders();
    return vos.map((e) => e.toDomain).toList();
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

### DTO / VO / Entity 命名约定

| 类型 | 位置 | 用途 |
|------|------|------|
| Entity | `domain/*/entity/` | 领域实体，核心业务模型 |
| Value Object | `domain/*/value_object.dart` | 带验证逻辑的值类型 |
| DTO | `infrastructure/remote_data/api/*/models/dto.dart` | 请求体（发给服务端） |
| VO | `infrastructure/remote_data/api/*/models/vo.dart` | 响应体（来自服务端），含 `toDomain` 转换 |

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
