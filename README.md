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

## 文档

详细规范与开发指南拆分在 `docs/` 目录：

| 文档 | 内容 |
|---|---|
| [架构与分层](docs/architecture.md) | 分层依赖规则、`core / shared / features` 边界、feature 之间的关系 |
| [开发指南](docs/development.md) | 新增模块流程、UseCase 何时引入、命名约定、入参 / 返回值规范、DI 注册 |
| [全局状态](docs/state-management.md) | 全局状态放置原则与判断流程 |
| [本地存储](docs/storage.md) | SharedPreferences / SecureStorage / sqlite 选型与使用 |
| [主题](docs/theme.md) | 主题切换、设计 token、品牌色 |
| [国际化](docs/i18n.md) | arb 文案、`S.of` / `S.current`、语言切换 |
| [测试指南](docs/testing.md) | 分层测试策略、mocktail、Riverpod + DI override、sqlite in-memory |

## 环境切换

```bash
# 开发环境
flutter run --dart-define=env=dev

# 预发布
flutter run --dart-define=env=stag

# 生产（默认）
flutter run
```

## 常用命令

```bash
# 代码生成（Freezed / Injectable / Riverpod）
dart run build_runner build --delete-conflicting-outputs

# 持续监听文件变化自动生成
dart run build_runner watch --delete-conflicting-outputs

# 国际化生成
flutter pub run intl_utils:generate
```
