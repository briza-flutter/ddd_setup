# 本地存储

三种存储方案各司其职：

| 存储 | 用途 | 加密 | 读 | 写 | 注册 |
|---|---|---|---|---|---|
| `SharedPreferences` | 普通 KV：用户偏好、缓存的非敏感数据、用户档案 | ❌ | sync | async | `app/di.dart`（`@preResolve`） |
| `SecureStorage`（core） | 敏感数据：token、密码、加密密钥 | ✅ | sync（启动期预读） | async | `app/di.dart`（`@preResolve`） |
| `SqliteClient`（core） | 结构化数据：订单列表、消息历史、可查询的业务表 | ❌ | async | async | `app/di.dart`（`@preResolve`） |

## 判断口诀

- **敏感 → SecureStorage**（token、密码、PIN、加密密钥）
- **KV 偏好 → SharedPreferences**（语言、主题、最近搜索、列表过滤器）
- **多记录 / 查询 → sqlite**（订单、用户档案缓存、消息历史）

## 当前模板：`AuthLocalStorage` 混用两种

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

## SecureStorage 的"同步读"是怎么做到的

`flutter_secure_storage` 的原生 API 全是异步。模板里 `SecureStorage.getInstance()` 在启动期一次性 `readAll()` 进内存，DI 用 `@preResolve` 等它完成；之后 `read(key)` 直接读内存 map（**同步**），写操作既刷盘也更新内存。这样 dio 的 `AuthInterceptor.onRequest`（同步钩子）才能直接取到 token。

模式和 `SharedPreferences.getInstance()` 完全一致——异步初始化，同步读，异步写。

## 本地数据库（sqlite）

按 dio 的三层模式组织：**通用封装在 `core/`、装配在 `app/`、表 DAO 在 feature**。

### 跨平台支持

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

### 三层结构

| 层 | 内容 | 文件 |
|---|---|---|
| **通用封装** | `SqliteClient`：开库 + 迁移调度 + CRUD 直通 | `core/database/sqlite_client.dart` |
| **项目装配** | 数据库名、所有迁移 SQL、DI 注册 | `app/database/migrations.dart` + `app/di.dart` |
| **表 DAO** | 单 feature 的表读写 | `features/<x>/data/datasource/<x>_dao.dart` |

### 与 dio 完全对称

| 网络 | sqlite |
|---|---|
| `core/network/dio_client.dart`（通用 Dio 封装） | `core/database/sqlite_client.dart`（通用 sqlite 封装） |
| `app/di.dart` 注册 `DioClient(baseUrl, interceptors)` | `app/di.dart` 注册 `SqliteClient(dbName, migrations)` |
| `features/<x>/data/datasource/<x>_api.dart` | `features/<x>/data/datasource/<x>_dao.dart` |

### 新增一张表的步骤

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

### 三种 model 不要混用

| 类型 | 用途 | 位置 |
|---|---|---|
| `XxxModel` | API JSON 序列化（`fromJson` / `toJson`） | `features/*/data/model/xxx_model.dart` |
| `XxxDbModel` | sqlite 行序列化（`fromRow` / `toRow`） | `features/*/data/model/xxx_db_model.dart` |
| `Xxx` | 领域实体 | `features/*/domain/entity/xxx.dart` |

两个 model 都 ↔ 同一个 `Xxx`，**Repository 是它们的汇合点**。不要让一个 freezed 类既管 JSON 又管 db row——字段类型、空值规则、命名习惯都不一样，强行复用必埋坑。
