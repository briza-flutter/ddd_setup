# DDD Setup

基于 Flutter 的 **Core / Feature** 项目模板，吸收 DDD（领域驱动设计）思想：每个 feature 内部按 `data / domain / presentation` 三层切分，依赖单向流向 domain。

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
├── main.dart                                 # 入口：初始化环境 → DI → 启动 App
│
├── app/                                      # 应用壳：入口、DI、路由、环境配置、项目级装配
│   ├── app.dart                              #   MyApp（MaterialApp.router）
│   ├── di.dart                               #   GetIt + Injectable DI 配置
│   ├── env_config.dart                       #   环境变量（dev/stag/prod）
│   ├── database/
│   │   └── migrations.dart                   #   项目所有 sqlite 迁移集中放（依赖业务表，故在 app/）
│   ├── network/
│   │   └── interceptor_handler.dart          #   拦截器回调桥接 Riverpod（依赖 auth feature，故在 app/）
│   ├── router/
│   │   ├── app_router.dart                   #   GoRouter 配置 + 鉴权守卫
│   │   └── routes.dart                       #   路由路径定义
│   └── theme/
│       └── app_theme.dart                    #   主题（light/dark）+ 品牌色 + 设计 token
│
├── core/                                     # 跨 feature 基建（零业务依赖，可独立成 package）
│   ├── domain/value_object.dart              #   ValueObject 基类
│   ├── error/failures.dart                   #   Failure 异常体系
│   ├── database/
│   │   └── sqlite_client.dart                #   通用 sqlite 封装（开库 + 迁移调度 + CRUD）
│   ├── network/
│   │   ├── dio_client.dart                   #   Dio 封装（get/post）
│   │   └── interceptors/
│   │       ├── auth_interceptor.dart         #   Bearer Token 注入（通过回调取 token）
│   │       ├── response_interceptor.dart     #   响应 code != 200 转异常
│   │       └── error_interceptor.dart        #   全局错误回调（通过回调通知）
│   ├── presentation/extensions/
│   │   ├── context_extensions.dart           #   BuildContext 简写（theme / screen / 键盘 / 导航）
│   │   └── future_extensions.dart            #   tryCatch() 异步异常捕获
│   ├── storage/
│   │   └── secure_storage.dart               #   加密本地存储（token 等敏感数据）
│   └── utils/
│       ├── app_logger.dart                   #   日志单例
│       ├── debouncer.dart                    #   Debouncer / Throttler（防抖 / 节流）
│       └── map_utils.dart                    #   Map 嵌套取值工具
│
├── shared/                                   # 跨 feature 业务相关代码（业务通用 widget / model / 全局状态）
│   ├── providers/
│   │   ├── locale_vm.dart                    #   语言（zh/en）全局状态（含 SP 持久化）
│   │   └── theme_vm.dart                     #   ThemeMode 全局状态（含 SP 持久化）
│   └── widgets/
│       └── loading_indicator.dart            #   通用 loading widget
│
├── features/                                 # 业务功能模块，每个 feature 内部 data/domain/presentation 三层
│   ├── auth/                                 # 认证：登录、登出、token & user 持久化
│   │   ├── data/                             #   ─ 落地实现（IO 边界）
│   │   │   ├── datasource/
│   │   │   │   ├── auth_api.dart             #     远程登录接口
│   │   │   │   └── auth_local_storage.dart   #     本地存储：token（SecureStorage）+ user（SP）
│   │   │   ├── model/                        #     DTO（不能进 domain）
│   │   │   │   ├── login_dto.dart            #       请求体
│   │   │   │   └── login_resp_model.dart     #       响应体（含 toDomain）
│   │   │   └── repository/
│   │   │       └── auth_repository.dart      #     编排 API + 本地存储（已合并简单 use case）
│   │   ├── domain/                           #   ─ 纯业务规则（无 Flutter / 无 IO）
│   │   │   ├── entity/
│   │   │   │   ├── auth_result.dart          #     AuthResult（登录结果）
│   │   │   │   └── login_param.dart          #     LoginParam（登录入参）
│   │   │   └── value_object/
│   │   │       └── credentials.dart          #     PhoneNumber / Password 值对象
│   │   └── presentation/                     #   ─ UI + ViewModel
│   │       ├── pages/
│   │       │   └── login_page.dart           #     登录页
│   │       └── provider/
│   │           ├── auth_session_vm.dart      #     全局登录会话状态（keepAlive）
│   │           └── login_vm.dart             #     登录页面 VM
│   │
│   ├── user/                                 # 用户信息查询
│   │   ├── data/
│   │   │   ├── datasource/user_api.dart      #     用户接口
│   │   │   ├── model/user_model.dart         #     UserModel（含 toDomain/fromDomain）
│   │   │   └── repository/user_repository.dart
│   │   └── domain/entity/user.dart           #     User 实体
│   │
│   └── home/                                 # 主页（登录后入口）
│       └── presentation/
│           ├── pages/home_page.dart
│           └── provider/home_vm.dart
│
└── i18/                                      # 国际化
    ├── l10n/                                 #   arb 翻译源文件
    └── generated/                            #   生成的 Dart 文件

env/                                          # 环境配置
├── dev.json
├── stag.json
└── prod.json
```

## 分层依赖规则

### 顶层（垂直切分）

```
app/  ─────────────────┐
                       │
features/<x>/  ───→  features/<y>/ ?     ❌ 禁止 feature 之间互相依赖 data/presentation
                       │                  ✅ 仅允许引用对方的 domain/entity（单向）
shared/  ←─────────────┤
core/    ←─────────────┘
```

- **`app/`**：应用壳，可以引用所有层
- **`features/`**：业务模块，可以引用 `core/` 和 `shared/`；feature 之间**只能单向引用对方的 `domain/`**（不能跨 feature 引 data/presentation）
- **`shared/`**：业务通用 widget / 数据结构，可以引用 `core/`
- **`core/`**：技术基建，零业务，零依赖（只依赖三方包）

### feature 内部（水平分层 — DDD 内核）

```
presentation/ ──→ data/ ──→ domain/
                            ↑
                  data 通过 toDomain() 把 DTO 转成 domain entity
```

- **`domain/`**：纯 Dart，不依赖 Flutter / IO / 三方 SDK。定义实体、值对象、（可选）UseCase
- **`data/`**：实现 IO，依赖 `domain/`。负责 API 调用、本地存储、DTO ↔ Entity 转换
- **`presentation/`**：UI + ViewModel，依赖 `data/` 的 Repository（已简化，不强制走 UseCase）

## 开发指南

### 新增功能模块流程

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

### 何时加回 UseCase 层

> **默认不加 use case，简单 CRUD 直接 `vm → repository`。复杂场景按需加，加在 feature 内的 `domain/usecase/`。**

#### 该加的信号 ✓

| 信号 | 例子 |
|---|---|
| **跨多个 repository 编排** | 下单 = 商品检查 + 库存锁定 + 支付发起 + 订单创建 |
| **跨多个 feature 协作** | 退出登录 = 清 token + 清收藏列表 + 清购物车 |
| **同一业务流被多个 vm 复用** | 登录后逻辑既在 `login_vm` 用，也在第三方授权回调用 |
| **领域规则不属于任何单一 repo** | 新用户首次登录跳引导页 |
| **vm 变胖**（> 100 行 / 多个业务方法） | 需要拆出来给 vm 减负 |

#### 不加的信号 ✗

- 单 repo 直通的 CRUD（`getUserInfo`、`updateNickname`）
- 只一个地方在用
- vm 里 2~3 行就能写完

#### 加在哪里 / 怎么命名

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

#### 示例：跨 feature 的登录 use case

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

### core / shared / features 的边界

| 放在哪 | 标准 | 例子 |
|---|---|---|
| **`app/`** | 项目特定的装配/壳：入口、DI、路由、环境、依赖具体 feature 的桥接 | `MyApp`、`di.dart`、`AppRouterConfig`、`DioInterceptorHandler` |
| **`core/`** | 技术基建，无业务概念，**可独立成 package** | dio_client、logger、Failure、ValueObject 基类、纯拦截器（通过回调） |
| **`shared/`** | 跨 feature 复用的**业务相关**代码 | LoadingIndicator、EmptyView、PagedResult、业务 extension |
| **`features/<x>/`** | 只在单个 feature 内用 | LoginVm、AuthRepository |

#### 黄金判断：「能直接 copy 到下个 Flutter 项目用吗？」

| 答案 | 归宿 |
|---|---|
| 能（构造函数注入参数即可） | `core/` |
| 改一两个构造参数就能用 | `core/`，参数走 DI |
| 必须知道项目里的具体 feature / 装配决策 | `app/` |
| 跨 feature 业务复用 | `shared/` |
| 单 feature 内用 | `features/<x>/` |

**典型例子：`AuthInterceptor` vs `DioInterceptorHandler`**

```dart
// core/network/interceptors/auth_interceptor.dart  ← core，因为通过回调拿 token
class AuthInterceptor extends Interceptor {
  final String? Function() getToken;     // 不知道 token 从哪来，靠注入
  AuthInterceptor({required this.getToken});
}

// app/network/interceptor_handler.dart  ← app，因为它"知道"项目用 authSessionVm
@singleton
class DioInterceptorHandler {
  String? getToken() => _container.read(authSessionVmProvider).token;  // ← 项目特定
}
```

前者可复用，后者绑死 auth feature。**前者在 core，后者在 app**。

#### 判断三问

1. 它依赖业务概念吗？→ **是** 去 `shared/`；**否**（纯技术）去 `core/`
2. 当前被两个以上 feature 用吗？→ **否**，先留 feature 内，**不要预先放 shared**
3. 后续可能被多个 feature 用吗？→ 用到第二处时再搬，避免预测式抽象

### feature 之间的关系

> **铁律**：依赖方向单向（业务 → 基础），只穿透到对方的 `domain/` 和 `data/repository/`，**绝不**碰对方的 `presentation/`。

#### 依赖分层

```
业务 feature（编排）：order, campaign
       ↓ 依赖
基础 feature（实体 + 原子 CRUD）：coupon, user, payment
       ↓ 依赖
shared / core
```

- **基础 feature**：拥有实体 + 原子 CRUD，不知道有谁在用它
- **业务 feature**：编排基础 feature 完成业务流程，依赖多个基础 feature
- 一个项目里，coupon 既可以是基础 feature（被 order/campaign 调用），自己也可以有业务页面（"我的优惠券"列表、详情）

#### 三种典型场景的代码模式

**场景 1：简单拼装（vm 直接调多个 repo）**

活动页同时显示活动信息和已领优惠券：

```dart
// features/campaign/presentation/provider/campaign_detail_vm.dart
@riverpod
class CampaignDetailVm extends _$CampaignDetailVm {
  late final _campaignRepo = di.get<CampaignRepository>();
  late final _couponRepo = di.get<CouponRepository>();   // ← 跨 feature 引 repo，OK

  Future<void> load(int campaignId) async {
    final campaign = await _campaignRepo.getCampaign(campaignId);
    final myCoupons = await _couponRepo.getMyCoupons();
    state = state.copyWith(campaign: campaign, coupons: myCoupons);
  }
}
```

**不需要 use case**，vm 直接拼装。

**场景 2：复杂编排（抽 use case，放主导 feature）**

活动中领取优惠券，需要校验活动状态、用户额度、领取后刷新本地缓存：

```dart
// features/campaign/domain/usecase/claim_coupon_usecase.dart
@injectable
class ClaimCouponUseCase {
  final CampaignRepository _campaignRepo;
  final CouponRepository _couponRepo;
  ClaimCouponUseCase(this._campaignRepo, this._couponRepo);

  Future<Coupon> call(int campaignId) async {
    final campaign = await _campaignRepo.getCampaign(campaignId);
    if (!campaign.isActive) throw BusinessFailure(message: '活动已结束');

    final claimedCount = await _campaignRepo.getUserClaimedCount(campaignId);
    if (claimedCount >= campaign.limitPerUser) {
      throw BusinessFailure(message: '已达领取上限');
    }

    final coupon = await _campaignRepo.claim(campaignId);
    await _couponRepo.refreshLocal();          // ← 通知 coupon feature 刷新
    return coupon;
  }
}
```

**场景 3：业务流程消费基础能力（订单用券）**

```dart
// features/order/domain/usecase/place_order_usecase.dart
@injectable
class PlaceOrderUseCase {
  final OrderRepository _orderRepo;
  final CouponRepository _couponRepo;
  PlaceOrderUseCase(this._orderRepo, this._couponRepo);

  Future<Order> call(PlaceOrderParam param) async {
    if (param.couponId != null) {
      final coupon = await _couponRepo.getCoupon(param.couponId!);
      if (!coupon.canApplyTo(param.items)) {
        throw BusinessFailure(message: '优惠券不适用');
      }
    }
    return _orderRepo.placeOrder(param);
  }
}
```

#### use case 放哪个 feature —— "主导原则"

> 谁是这个流程的**触发者 / 主屏幕**，use case 就放谁那。

| 流程 | 主导 feature | use case 位置 |
|---|---|---|
| 活动详情页领券 | campaign（用户在活动页操作） | `features/campaign/domain/usecase/` |
| 下单时用券 | order（在订单页选券） | `features/order/domain/usecase/` |
| "我的优惠券"页手动作废 | coupon（在券列表操作） | `features/coupon/domain/usecase/` |

基础 feature 只暴露**原子能力**（`getCoupon`、`getMyCoupons`、`refreshLocal`、`markUsed`），不知道有谁在编排它。

#### 共享实体放 feature 还是 shared

判断：**这个实体有没有自己的 UI 入口**？

| 情况 | 放哪 |
|---|---|
| 有独立页面（"我的优惠券"列表、券详情页） | `features/<x>/domain/entity/`，它就是一个 feature |
| 没有 UI，只是嵌在别处展示的值对象 | `shared/domain/` |

#### 跨 feature 状态同步

领券后，"我的优惠券"页面应自动刷新。两种方案：

| 方案 | 做法 | 适用 |
|---|---|---|
| **A：基础 feature 自管刷新** | 领取 use case 调 `_couponRepo.refreshLocal()`，coupon vm 监听 repo 的 stream/notifier | 解耦更彻底 |
| **B：业务 feature 主动通知**（推荐） | 流程结束后通过 ref 调 `couponVm.refresh()` | 模板项目首选，简单直接 |

真要扩展到多对多通知场景，再上事件总线。

#### 反模式 ✗

| 反模式 | 为什么错 | 正解 |
|---|---|---|
| `coupon` import `order` | 基础不应该知道业务，违反单向依赖 | 永远只能业务 → 基础 |
| `campaign` import `order/presentation/order_vm.dart` | vm 是 UI 状态，跨 feature 引 vm 必生硬耦合 | 通过 repo 调；真要共享状态就抽到第三方 |
| `coupon` 和 `campaign` 互相 import | 循环依赖 | 把共同部分抽到 `shared/` 或拆出第三个 feature |
| 在 order 里偷偷塞一份 `Coupon` entity | 实体重复定义，后续迁移地狱 | entity 只在所属 feature 定义一次，其他 feature import |
| 通过 GetIt 反向获取业务 feature 的 vm provider | 绕过 Riverpod 依赖管理 | 依赖反转：让对方提供回调或 stream |

### 全局状态放哪

> **核心原则：归属大于通用性。** 不要因为"很多 feature 都用"就搬到全局目录——先问"它属于哪个业务领域"。
>
> **"全局"是讲生命周期（`@Riverpod(keepAlive: true)`），不是物理位置。** vm 放哪取决于"它管什么领域"，不取决于"谁来用它"。

#### 放置规则

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

#### 示例：用户详情跨页面修改

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

#### auth_session_vm vs user_profile_vm 的边界

两者职责分离，**单向依赖**（user_profile 监听 auth_session，反之不可）：

| vm | 职责 | 字段 |
|---|---|---|
| `auth_session_vm` | 登录态、token、路由鉴权 | `token`、最小 `user`（id + name 用于显示） |
| `user_profile_vm` | 完整用户档案，所有 user 业务的单一事实来源 | 详细 `user`（含头像、偏好、扩展字段） |

模板项目目前只有 `auth_session_vm` 已够用，业务真扩展时再加 `user_profile_vm`。

#### 真正"无业务归属"的全局状态

少数情况，例如主题切换、网络状态、全局错误。**实际极少**，不要预先建空目录，等用到时再建：

```
shared/providers/theme_vm.dart        # 跨 feature 业务无关
app/providers/connectivity_vm.dart    # 应用级基础状态
```

#### 反模式 ✗

| 反模式 | 为什么错 | 正解 |
|---|---|---|
| 建 `lib/global/`、`lib/state/` 顶级目录收纳"全局 vm" | 按"通用性"分类，掩盖业务归属 | 按领域归属放在 feature 内 |
| 因为"home 也要用"就把 `user_profile_vm` 搬到 `shared/` | 通用性不是搬家理由 | 留在 `features/user/`，home 直接 import |
| 一个超级 vm 同时管 auth + user + cart | 巨石 vm，难维护、难测试 | 拆成多个 vm，单向监听协作 |
| 多个 vm 各自缓存一份 user，更新时手动同步 | 多事实来源，必出同步 bug | 单一 vm，其他地方 `ref.watch` |
| page 里直接 `di.get<UserRepository>()` 读取数据 | 绕过 vm，状态分散 | 永远走 vm，vm 是唯一对外接口 |

### 命名约定

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

### 入参 / 返回值规范

> **核心原则：同一业务方法在 Repository / UseCase / VM 三层入参类型一致，不要在某一层拆成命名参数。**

#### 入参

| 字段数量 | 形态 | 形参变量名 | 示例 |
|---|---|---|---|
| 单个基础类型 | 直传 | 业务名 | `getUserInfo(int userId)` |
| ≥2 个字段 / 含值对象 / 含复杂结构 | `XxxParam`（domain 层 freezed） | `param` | `login(LoginParam param)` |

- **Repository、UseCase、VM 的同名方法保持入参类型一致**，VM 不要把 `Param` 拆成命名参数（避免每加一个字段就改三层签名）。
- DTO 不暴露给 Repository / VM。Repository 内部从 `Param` 构造 `Dto` 后传给 Api。
- Api 层形参名用 `dto`（如 `login(LoginDto dto)`），不用 `loginDto` 这种"类型重复"的命名。
- ValueObject 字段名直接用业务名，**不加 `Obj` 后缀**。`password` ✓，`passwordObj` ✗。

#### 返回值

| 场景 | 形态 | 示例 |
|---|---|---|
| 单值 | 直接返回领域类型 | `Future<User>` |
| 多值且语义明确 | `XxxResult`（domain 层 freezed） | `Future<AuthResult>` |
| 跨层 record | **禁止** | ~~`Future<(User, Token)>`~~ |

- record 只允许在**单文件内部**短期使用，**不可跨层暴露**。
- Api 层返回 `Model`（data 类型），Repository 负责 `model.toDomain` 转换为 Domain Entity 或 `Result`。

#### 三层调用示例

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

### DI 注册：`@singleton` vs `@lazySingleton`

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

### 本地存储

三种存储方案各司其职：

| 存储 | 用途 | 加密 | 读 | 写 | 注册 |
|---|---|---|---|---|---|
| `SharedPreferences` | 普通 KV：用户偏好、缓存的非敏感数据、用户档案 | ❌ | sync | async | `app/di.dart`（`@preResolve`） |
| `SecureStorage`（core） | 敏感数据：token、密码、加密密钥 | ✅ | sync（启动期预读） | async | `app/di.dart`（`@preResolve`） |
| `SqliteClient`（core） | 结构化数据：订单列表、消息历史、可查询的业务表 | ❌ | async | async | `app/di.dart`（`@preResolve`） |

#### 判断口诀

- **敏感 → SecureStorage**（token、密码、PIN、加密密钥）
- **KV 偏好 → SharedPreferences**（语言、主题、最近搜索、列表过滤器）
- **多记录 / 查询 → sqlite**（订单、用户档案缓存、消息历史）

#### 当前模板：`AuthLocalStorage` 混用两种

```dart
@singleton
class AuthLocalStorage {
  final SharedPreferences _sp;       // user（非敏感，明文 OK）
  final SecureStorage _secure;       // token（敏感，加密）

  String? getToken() => _secure.read(_tokenKey);
  Future<void> setToken(String t) => _secure.write(_tokenKey, t);
  User? getUser() { /* 从 _sp 反序列化 */ }
}
```

> **不要把 token 存 SharedPreferences**——Android root 设备或 iOS 越狱设备能直接读到明文。SecureStorage 在 Android 走 EncryptedSharedPreferences，在 iOS 走 Keychain，root / 越狱也读不到。

#### SecureStorage 的"同步读"是怎么做到的

`flutter_secure_storage` 的原生 API 全是异步。模板里 `SecureStorage.getInstance()` 在启动期一次性 `readAll()` 进内存，DI 用 `@preResolve` 等它完成；之后 `read(key)` 直接读内存 map（**同步**），写操作既刷盘也更新内存。这样 dio 的 `AuthInterceptor.onRequest`（同步钩子）才能直接取到 token。

模式和 `SharedPreferences.getInstance()` 完全一致——异步初始化，同步读，异步写。

### 本地数据库（sqlite）

按 dio 的三层模式组织：**通用封装在 `core/`、装配在 `app/`、表 DAO 在 feature**。

#### 跨平台支持

`SqliteClient.open()` 通过条件 import 自动选择合适的 factory：

| 平台 | 实现 | 额外配置 |
|---|---|---|
| Android / iOS | sqflite 默认 plugin | 无 |
| Windows / Linux / macOS | sqflite_common_ffi（加载 sqlite3 动态库） | 无 |
| Web | sqflite_common_ffi_web（sqlite3 wasm + IndexedDB） | 见下 |

**Web 首次运行前必须执行一次**（已为本模板执行过）：

```bash
dart run sqflite_common_ffi_web:setup
```

它会把 `sqflite_sw.js` 和 `sqlite3.wasm` 复制到 `web/` 目录，必须随 `web/` 一起提交到 git。

文件结构：
```
lib/core/database/
├── sqlite_client.dart                  # 主入口
├── _platform_factory_native.dart       # 移动 / 桌面
└── _platform_factory_web.dart          # Web
```

#### 三层结构

| 层 | 内容 | 文件 |
|---|---|---|
| **通用封装** | `SqliteClient`：开库 + 迁移调度 + CRUD 直通 | `core/database/sqlite_client.dart` |
| **项目装配** | 数据库名、所有迁移 SQL、DI 注册 | `app/database/migrations.dart` + `app/di.dart` |
| **表 DAO** | 单 feature 的表读写 | `features/<x>/data/datasource/<x>_dao.dart` |

#### 与 dio 完全对称

| 网络 | sqlite |
|---|---|
| `core/network/dio_client.dart`（通用 Dio 封装） | `core/database/sqlite_client.dart`（通用 sqlite 封装） |
| `app/di.dart` 注册 `DioClient(baseUrl, interceptors)` | `app/di.dart` 注册 `SqliteClient(dbName, migrations)` |
| `features/<x>/data/datasource/<x>_api.dart` | `features/<x>/data/datasource/<x>_dao.dart` |

#### 新增一张表的步骤

**1. 在 `app/database/migrations.dart` 追加迁移**

```dart
class AppMigrations {
  static final List<Migration> all = [
    Migration(version: 1, sql: 'CREATE TABLE users ...'),       // 已有
    Migration(                                                   // ← 新增
      version: 2,
      sql: 'CREATE TABLE orders (id INTEGER PRIMARY KEY, amount REAL)',
    ),
  ];
}
```

> **不要修改历史迁移**——已发布版本里数据库已按旧 SQL 建好，改了不会重跑，必出数据腐败。

**2. 在 feature 内加 DbModel + DAO**

```dart
// features/order/data/model/order_db_model.dart
class OrderDbModel {
  final int id;
  final double amount;
  OrderDbModel({required this.id, required this.amount});

  factory OrderDbModel.fromRow(Map<String, Object?> r) =>
      OrderDbModel(id: r['id'] as int, amount: r['amount'] as double);
  Map<String, Object?> toRow() => {'id': id, 'amount': amount};

  factory OrderDbModel.fromDomain(Order o) =>
      OrderDbModel(id: o.id, amount: o.amount);
  Order get toDomain => Order(id: id, amount: amount);
}

// features/order/data/datasource/order_dao.dart
@singleton
class OrderDao {
  final SqliteClient _sqlite;
  OrderDao(this._sqlite);

  Future<List<OrderDbModel>> findAll() async {
    final rows = await _sqlite.query('orders');
    return rows.map(OrderDbModel.fromRow).toList();
  }

  Future<void> upsert(OrderDbModel m) => _sqlite.insert(
        'orders',
        m.toRow(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
}
```

**3. Repository 编排 remote + local（缓存模式示例）**

```dart
@singleton
class OrderRepository {
  final OrderApi _api;
  final OrderDao _dao;
  OrderRepository(this._api, this._dao);

  Future<List<Order>> getOrders() async {
    final cached = await _dao.findAll();
    if (cached.isNotEmpty) return cached.map((m) => m.toDomain).toList();

    final remote = await _api.getOrders();
    for (final m in remote) {
      await _dao.upsert(OrderDbModel.fromDomain(m.toDomain));
    }
    return remote.map((m) => m.toDomain).toList();
  }
}
```

**4. 生成代码**

```bash
dart run build_runner build --delete-conflicting-outputs
```

DAO 通过 `@singleton` 自动被 injectable 发现并注册，构造参数 `SqliteClient` 由 DI 注入。

#### 三种 model 不要混用

| 类型 | 用途 | 位置 |
|---|---|---|
| `XxxModel` | API JSON 序列化（`fromJson` / `toJson`） | `features/*/data/model/xxx_model.dart` |
| `XxxDbModel` | sqlite 行序列化（`fromRow` / `toRow`） | `features/*/data/model/xxx_db_model.dart` |
| `Xxx` | 领域实体 | `features/*/domain/entity/xxx.dart` |

两个 model 都 ↔ 同一个 `Xxx`，**Repository 是它们的汇合点**。不要让一个 freezed 类既管 JSON 又管 db row——字段类型、空值规则、命名习惯都不一样，强行复用必埋坑。

### 主题与设计 token

主题数据放 `app/theme/app_theme.dart`——属于**项目装配**（品牌色、字号是这个 App 的，换项目都要改），不在 `core/`。

`MaterialApp` 在 `app/app.dart` 通过 `theme` / `darkTheme` / `themeMode` 注入，业务页面通过 `Theme.of(context)`（或 `context.theme`）读取。

#### 两类 token 的访问方式

| 类型 | 来源 | 访问方式 | 示例 |
|---|---|---|---|
| **Material 标准色** | `ColorScheme`（由 seedColor 自动派生） | `context.colorScheme.primary` | 主色、表面色、错误色 |
| **自定义 token** | `AppTheme.*` 静态常量 | 直接 import | `AppTheme.success`、`AppTheme.spaceMd` |

```dart
// 用 ColorScheme（随主题自动切换 light/dark）
Container(color: context.colorScheme.primary)

// 用自定义 token（语义色、间距、圆角等）
Container(
  color: AppTheme.success,
  padding: const EdgeInsets.all(AppTheme.spaceMd),
)
```

> **为什么自定义 token 不放进 ColorScheme**：`ColorScheme` 是 Material 设计规范的标准色槽，硬塞 success/warning 等业务语义色会绕开 Material 主题派生机制。需要随主题切换的自定义色用 [ThemeExtension](https://api.flutter.dev/flutter/material/ThemeExtension-class.html)，模板用不到先简化。

#### 修改品牌色

只改 `_brandSeed` 一处，整个 ColorScheme 自动重新派生：

```dart
static const _brandSeed = Color(0xFF0066FF);   // ← 改这里
```

#### 主题切换已内置

`shared/providers/theme_vm.dart` 已实现 `ThemeMode` 全局状态 + SharedPreferences 持久化。`app/app.dart` 订阅了它，登录页右上角 `AppBar.actions` 图标按钮一键循环切换 system → light → dark。

```dart
// 任意 widget 内切换
ref.read(themeVmProvider.notifier).toggle();

// 或指定模式
ref.read(themeVmProvider.notifier).setMode(ThemeMode.dark);

// 读当前模式
final mode = ref.watch(themeVmProvider);   // ThemeMode
```

**为什么 theme_vm 在 `shared/` 而不是 `features/`**：主题无业务领域归属（不属于 auth / user / 任何业务）→ 应用层共享状态 → `shared/providers/`。判断标准见前面「全局状态放哪」一节。

### 国际化（i18n）与语言切换

基于 `flutter_intl`（IDE 插件）+ `intl_utils`（CLI 生成器）。`pubspec.yaml` 里的 `flutter_intl:` block 是配置：

```yaml
flutter_intl:
  enabled: true
  main_locale: zh             # 主语言（必须有完整 key）
  arb_dir: lib/i18/l10n
  output_dir: lib/i18/generated
```

#### 文件结构

```
lib/i18/
├── l10n/                         # 翻译源（arb）
│   ├── intl_zh.arb               #   中文（main_locale，所有 key 都在这里）
│   └── intl_en.arb               #   英文（key 要和 zh 对齐）
└── generated/                    # intl_utils 生成（勿手改）
    ├── l10n.dart                 #   S 类入口
    └── intl/
        ├── messages_all.dart
        ├── messages_zh.dart
        └── messages_en.dart
```

#### 新增一条文案的流程

1. 在 `intl_zh.arb` 和 `intl_en.arb` 同时加 key + 翻译
2. 跑 `dart run intl_utils:generate`（重新生成 `S` 类）
3. 使用：

```dart
// 在 Widget 内（推荐 —— 自动响应 locale 变化）
Text(S.of(context).loginButton)

// 在 ViewModel 内（无 context）—— 用 S.current
return S.current.invalidPhone;
```

> **`S.of(context)` vs `S.current`**：前者依赖 widget tree 的 Localizations，locale 切换时自动 rebuild；后者是全局静态，跟随最近一次 `S.load` 的 locale。validator / 业务 vm 等没有 context 的地方用 `S.current`。

#### 语言切换已内置

`shared/providers/locale_vm.dart` 提供 `LocaleVm`：`@Riverpod(keepAlive: true)`、SP 持久化、`toggle()` 在 zh / en 之间循环。

`app/app.dart` 已订阅，`locale` 和 `supportedLocales` 都来自它：

```dart
final locale = ref.watch(localeVmProvider);
return MaterialApp.router(
  locale: locale,
  supportedLocales: LocaleVm.supported,
  localizationsDelegates: const [S.delegate, ...],
  ...
);
```

登录页右上角 `EN / 中` 文字按钮一键切换，整 App 立即响应。

#### 加新语言（如日语）

1. 新建 `lib/i18/l10n/intl_ja.arb`，key 和 zh 对齐
2. `dart run intl_utils:generate`
3. 在 `LocaleVm.supported` 里加 `Locale('ja')`
4. `LocaleVm.toggle()` 改成循环逻辑（或直接用 `setLocale()` 配合选择列表 UI）

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
