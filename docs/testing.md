# 测试指南

> **核心思路**：跟着分层走——domain 纯单测、data 用 mock datasource、presentation 用 Riverpod container + DI override、跨层用 widget test。

## 测试依赖

域层纯 Dart 不需要额外依赖。涉及 mock 的层推荐加 `mocktail`（无代码生成、对 Dart 类型友好）：

```yaml
dev_dependencies:
  mocktail: ^1.0.4
```

## 目录结构

`test/` 镜像 `lib/`：

```
test/
├── core/                                 # 纯工具 / 基建测试
│   └── utils/debouncer_test.dart
├── features/
│   └── auth/
│       ├── domain/
│       │   └── value_object/credentials_test.dart
│       ├── data/
│       │   └── repository/auth_repository_test.dart
│       └── presentation/
│           └── provider/auth_session_vm_test.dart
└── helpers/
    ├── di_setup.dart                     # 注册 / 重置测试 DI
    └── fixtures.dart                     # 共用测试数据
```

## 四种测试

### 1. Domain — 纯 Dart 单测（最快最稳）

`ValueObject` / `Entity` 不依赖 Flutter / IO，直接测业务规则。

```dart
// test/features/auth/domain/value_object/credentials_test.dart
import 'package:ddd_setup/features/auth/domain/value_object/credentials.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PhoneNumber', () {
    test('合法手机号返回 value', () {
      final r = PhoneNumber.create('13800138000');
      expect(r.valueOrNull()?.value, '13800138000');
    });

    test('非法手机号返回 failure', () {
      final r = PhoneNumber.create('12345');
      expect(r.valueOrNull(), isNull);
      expect(r.failureOrNull(), isNotNull);
    });
  });

  group('Password', () {
    test('≥6 位通过，<6 位失败', () {
      expect(Password.create('123456').valueOrNull(), isNotNull);
      expect(Password.create('12345').valueOrNull(), isNull);
    });
  });
}
```

### 2. Repository — Mock datasource，测编排

Repository 是 `Api + LocalStorage` 的编排点，**只测编排逻辑**（顺序、转换、异常映射）。

```dart
// test/features/auth/data/repository/auth_repository_test.dart
import 'package:ddd_setup/features/auth/data/datasource/auth_api.dart';
import 'package:ddd_setup/features/auth/data/datasource/auth_local_storage.dart';
import 'package:ddd_setup/features/auth/data/model/login_dto.dart';
import 'package:ddd_setup/features/auth/data/model/login_resp_model.dart';
import 'package:ddd_setup/features/auth/data/repository/auth_repository.dart';
import 'package:ddd_setup/features/auth/domain/entity/login_param.dart';
import 'package:ddd_setup/features/auth/domain/value_object/credentials.dart';
import 'package:ddd_setup/features/user/data/model/user_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockAuthApi extends Mock implements AuthApi {}

class _MockAuthLocalStorage extends Mock implements AuthLocalStorage {}

void main() {
  late _MockAuthApi api;
  late _MockAuthLocalStorage storage;
  late AuthRepository repo;

  setUpAll(() {
    registerFallbackValue(LoginDto(username: '', password: ''));
  });

  setUp(() {
    api = _MockAuthApi();
    storage = _MockAuthLocalStorage();
    repo = AuthRepository(api, storage);
  });

  test('login 成功后先返回结果，再写入 token + user', () async {
    final respModel = LoginRespModel(
      token: 'tok_xyz',
      user: UserModel(id: 1, name: 'Alice'),
    );
    when(() => api.login(any())).thenAnswer((_) async => respModel);
    when(() => storage.setToken(any())).thenAnswer((_) async {});
    when(() => storage.setUser(any())).thenAnswer((_) async => true);

    final param = LoginParam(
      phoneNumber: PhoneNumber.create('13800138000').valueOrNull()!,
      password: Password.create('123456').valueOrNull()!,
    );

    final result = await repo.login(param);

    expect(result.token, 'tok_xyz');
    expect(result.user.id, 1);
    verify(() => storage.setToken('tok_xyz')).called(1);
    verify(() => storage.setUser(result.user)).called(1);
  });

  test('logout 清空本地 token 与 user', () async {
    when(() => storage.clearToken()).thenAnswer((_) async {});
    when(() => storage.clearUser()).thenAnswer((_) async => true);
    await repo.logout();
    verify(() => storage.clearToken()).called(1);
    verify(() => storage.clearUser()).called(1);
  });
}
```

### 3. ViewModel — Riverpod container + DI override

> VM 内部用 `di.get<XxxRepository>()` 拿依赖（而不是构造注入），所以测试时**把 mock 注册到 GetIt**，VM `late final` 字段首次访问就会拿到 mock。

#### 公共辅助

```dart
// test/helpers/di_setup.dart
import 'package:ddd_setup/app/di.dart';

void registerTestDep<T extends Object>(T instance) {
  if (di.isRegistered<T>()) di.unregister<T>();
  di.registerSingleton<T>(instance);
}

Future<void> resetTestDi() => di.reset();
```

#### 测试全局 VM（如 `AuthSessionVm`）

```dart
// test/features/auth/presentation/provider/auth_session_vm_test.dart
import 'package:ddd_setup/features/auth/data/repository/auth_repository.dart';
import 'package:ddd_setup/features/auth/domain/entity/auth_result.dart';
import 'package:ddd_setup/features/auth/domain/entity/login_param.dart';
import 'package:ddd_setup/features/auth/presentation/provider/auth_session_vm.dart';
import 'package:ddd_setup/features/user/data/repository/user_repository.dart';
import 'package:ddd_setup/features/user/domain/entity/user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/di_setup.dart';

class _MockAuthRepo extends Mock implements AuthRepository {}

class _MockUserRepo extends Mock implements UserRepository {}

class _FakeLoginParam extends Fake implements LoginParam {}

void main() {
  late _MockAuthRepo authRepo;
  late _MockUserRepo userRepo;

  setUpAll(() => registerFallbackValue(_FakeLoginParam()));

  setUp(() {
    authRepo = _MockAuthRepo();
    userRepo = _MockUserRepo();
    registerTestDep<AuthRepository>(authRepo);
    registerTestDep<UserRepository>(userRepo);
  });

  tearDown(resetTestDi);

  ProviderContainer makeContainer() {
    final c = ProviderContainer();
    addTearDown(c.dispose);
    return c;
  }

  test('build：本地无登录态时 user/token 为 null', () {
    when(() => authRepo.getLocalAuth()).thenReturn(null);
    final c = makeContainer();
    final s = c.read(authSessionVmProvider);
    expect(s.user, isNull);
    expect(s.token, isNull);
  });

  test('login 成功后 state 更新为返回的 user/token', () async {
    when(() => authRepo.getLocalAuth()).thenReturn(null);
    final user = User(id: 1, name: 'Alice');
    when(() => authRepo.login(any()))
        .thenAnswer((_) async => AuthResult(user: user, token: 'tok'));

    final c = makeContainer();
    await c.read(authSessionVmProvider.notifier).login(_FakeLoginParam());

    final s = c.read(authSessionVmProvider);
    expect(s.token, 'tok');
    expect(s.user, user);
  });
}
```

#### 涉及 Form / TextEditingController 的 VM（如 `LoginVm`）

`login_vm.dart` 里 `formKey.currentState?.validate()` 依赖 widget tree，**直接单元测拿不到 FormState** → 走 widget test。但 **纯校验函数**可以直接测：

```dart
test('validatePhone 非法返回错误文案', () {
  final c = makeContainer();
  final vm = c.read(loginVmProvider.notifier);
  expect(vm.validatePhone('123'), isNotNull);
  expect(vm.validatePhone('13800138000'), isNull);
});
```

### 4. Widget Test — 完整页面交互

```dart
// test/features/auth/presentation/pages/login_page_test.dart
import 'package:ddd_setup/features/auth/presentation/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
// ... 同前 mock setup

void main() {
  // setUp / tearDown 同 VM 测试（注册 mock 到 di）

  testWidgets('输入合法手机号 + 密码点击登录，触发 authRepo.login', (tester) async {
    when(() => authRepo.getLocalAuth()).thenReturn(null);
    when(() => authRepo.login(any())).thenAnswer(
      (_) async => AuthResult(user: User(id: 1, name: 'A'), token: 't'),
    );

    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: LoginPage())),
    );

    await tester.enterText(find.byType(TextFormField).at(0), '13800138000');
    await tester.enterText(find.byType(TextFormField).at(1), '123456');
    await tester.tap(find.text('登录'));
    await tester.pump();

    verify(() => authRepo.login(any())).called(1);
  });
}
```

> 测多语言文案不要硬编码 `'登录'`，用 `S.current.loginButton`，或给关键 widget 加 `Key`。

## sqlite / DAO 测试

`sqflite_common_ffi` 已在依赖里，在测试启动时切换 factory，库走内存：

```dart
// test/features/order/data/datasource/order_dao_test.dart
import 'package:ddd_setup/app/database/migrations.dart';
import 'package:ddd_setup/core/database/sqlite_client.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  late SqliteClient client;

  setUp(() async {
    client = SqliteClient(
      dbName: inMemoryDatabasePath, // ← sqflite 提供的内存库路径
      migrations: AppMigrations.all,
    );
    await client.open();
  });

  tearDown(() => client.close());

  test('迁移正确建表 + insert + query 闭环', () async {
    await client.insert('users', {'id': 1, 'name': 'Alice'});
    final rows = await client.query('users');
    expect(rows, hasLength(1));
    expect(rows.first['name'], 'Alice');
  });
}
```

DAO 测试同理：构造 `SqliteClient` → `new OrderDao(client)` → 调用 → 断言。

## 测什么 / 不测什么

| 层 | 必测 | 备注 |
|---|---|---|
| **Domain**（VO / Entity） | 业务规则、验证分支 | 100% 覆盖核心分支，零依赖 |
| **Data**（Repository） | 编排顺序、缓存策略、异常映射 | `verify` 调用次数 |
| **Data**（DAO） | CRUD 正确性、迁移 | in-memory sqlite |
| **Presentation**（全局 VM） | 状态转换、错误路径 | ProviderContainer + DI override |
| **Presentation**（Page） | 关键交互路径 | widget test，跳过琐碎布局 |
| **Core**（utils） | 纯函数（Debouncer 等） | 直接单测 |

**不要测**：

- freezed / json_serializable / riverpod_generator 生成的代码（框架已测）
- getter / 单步直通调用（如 `repo.x() => api.x().toDomain`，覆盖一次即可）
- 路由配置（除非有自定义 redirect）
- 为凑覆盖率写的无意义断言

## 运行

```bash
# 全部
flutter test

# 单文件
flutter test test/features/auth/domain/value_object/credentials_test.dart

# 覆盖率
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html      # 需 brew install lcov
```

## 常见坑

| 坑 | 处理 |
|---|---|
| `Bad state: GetIt: Object/factory with type X is not registered` | 测试漏了 `registerTestDep<X>()` |
| `Null check operator used on a null value`（FormState） | 不要在 unit test 测 `vm.login()`，走 widget test |
| 不同测试间 DI 状态污染 | `tearDown(resetTestDi)`，每个 case 重新注册 |
| `MissingPluginException` for `shared_preferences` / `secure_storage` | 不要在测试中调真实存储，把 `AuthLocalStorage` 整个 mock 掉 |
| 启动 App 跑完整流程的测试 | 不要直接 `pumpWidget(MyApp())` —— main.dart 会调真实 DI + sqlite。改为构造**最小 widget 树** + override |
