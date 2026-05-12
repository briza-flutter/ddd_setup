# 架构与分层

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

## core / shared / features 的边界

| 放在哪 | 标准 | 例子 |
|---|---|---|
| **`app/`** | 项目特定的装配/壳：入口、DI、路由、环境、依赖具体 feature 的桥接 | `MyApp`、`di.dart`、`AppRouterConfig`、`DioInterceptorHandler` |
| **`core/`** | 技术基建，无业务概念，**可独立成 package** | dio_client、logger、Failure、ValueObject 基类、纯拦截器（通过回调） |
| **`shared/`** | 跨 feature 复用的**业务相关**代码 | LoadingIndicator、EmptyView、PagedResult、业务 extension |
| **`features/<x>/`** | 只在单个 feature 内用 | LoginVm、AuthRepository |

### 黄金判断：「能直接 copy 到下个 Flutter 项目用吗？」

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

### 判断三问

1. 它依赖业务概念吗？→ **是** 去 `shared/`；**否**（纯技术）去 `core/`
2. 当前被两个以上 feature 用吗？→ **否**，先留 feature 内，**不要预先放 shared**
3. 后续可能被多个 feature 用吗？→ 用到第二处时再搬，避免预测式抽象

## feature 之间的关系

> **铁律**：依赖方向单向（业务 → 基础），只穿透到对方的 `domain/` 和 `data/repository/`，**绝不**碰对方的 `presentation/`。

### 依赖分层

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

### 三种典型场景的代码模式

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

### use case 放哪个 feature —— "主导原则"

> 谁是这个流程的**触发者 / 主屏幕**，use case 就放谁那。

| 流程 | 主导 feature | use case 位置 |
|---|---|---|
| 活动详情页领券 | campaign（用户在活动页操作） | `features/campaign/domain/usecase/` |
| 下单时用券 | order（在订单页选券） | `features/order/domain/usecase/` |
| "我的优惠券"页手动作废 | coupon（在券列表操作） | `features/coupon/domain/usecase/` |

基础 feature 只暴露**原子能力**（`getCoupon`、`getMyCoupons`、`refreshLocal`、`markUsed`），不知道有谁在编排它。

### 共享实体放 feature 还是 shared

判断：**这个实体有没有自己的 UI 入口**？

| 情况 | 放哪 |
|---|---|
| 有独立页面（"我的优惠券"列表、券详情页） | `features/<x>/domain/entity/`，它就是一个 feature |
| 没有 UI，只是嵌在别处展示的值对象 | `shared/domain/` |

### 跨 feature 状态同步

领券后，"我的优惠券"页面应自动刷新。两种方案：

| 方案 | 做法 | 适用 |
|---|---|---|
| **A：基础 feature 自管刷新** | 领取 use case 调 `_couponRepo.refreshLocal()`，coupon vm 监听 repo 的 stream/notifier | 解耦更彻底 |
| **B：业务 feature 主动通知**（推荐） | 流程结束后通过 ref 调 `couponVm.refresh()` | 模板项目首选，简单直接 |

真要扩展到多对多通知场景，再上事件总线。

### 反模式 ✗

| 反模式 | 为什么错 | 正解 |
|---|---|---|
| `coupon` import `order` | 基础不应该知道业务，违反单向依赖 | 永远只能业务 → 基础 |
| `campaign` import `order/presentation/order_vm.dart` | vm 是 UI 状态，跨 feature 引 vm 必生硬耦合 | 通过 repo 调；真要共享状态就抽到第三方 |
| `coupon` 和 `campaign` 互相 import | 循环依赖 | 把共同部分抽到 `shared/` 或拆出第三个 feature |
| 在 order 里偷偷塞一份 `Coupon` entity | 实体重复定义，后续迁移地狱 | entity 只在所属 feature 定义一次，其他 feature import |
| 通过 GetIt 反向获取业务 feature 的 vm provider | 绕过 Riverpod 依赖管理 | 依赖反转：让对方提供回调或 stream |
