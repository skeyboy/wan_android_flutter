# wan_android_flutter

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

## 采用monorepo 方式进行模块化改造

### base 模块
作为基础模块，主要功能为配置，工具等基础功能

结构
```
├── base
│   └── base_page.dart
├── constants
│   └── constants.dart
├── generated
├── routes
│   └── routes.dart
└── utils
    ├── error_handle.dart
    ├── log_util.dart
    └── persistent_util.dart
```

### network模块
网络模块依赖base模块，主要功能为网络相关处理：发送请求、处理相应以及对应模型转化

结构
```
├── api.dart
├── bean
│   ├── AppResponse.dart
│   ├── article_data_entity.dart
│   ├── banner_entity.dart
│   ├── hot_keyword_entity.dart
│   ├── my_shared_data_entity.dart
│   ├── my_todo_data_entity.dart
│   ├── project_category_entity.dart
│   ├── project_list_data_entity.dart
│   ├── user_info_entity.dart
│   └── user_tool_entity.dart
├── generated
│   └── json
│       ├── article_data_entity.g.dart
│       ├── banner_entity.g.dart
│       ├── base
│       │   ├── json_convert_content.dart
│       │   └── json_field.dart
│       ├── hot_keyword_entity.g.dart
│       ├── my_shared_data_entity.g.dart
│       ├── my_todo_data_entity.g.dart
│       ├── project_category_entity.g.dart
│       ├── project_list_data_entity.g.dart
│       ├── user_info_entity.g.dart
│       └── user_tool_entity.g.dart
├── network.dart
├── request_util.dart
└── user.dart
```

### ui模块
此模块为UI部分集合：自定通用widget以及功能模块page

#### ui/page模块
    目前改造只是将main_page模块作为壳工程入口,路由跳转与参数处理均在此模块当中，
鉴于为首次改造因此单纯的将路由跳转参数处理相关也放在此模块中（后续需要单独出来）

结构
```
├── home_page.dart
├── main_page.dart
├── mine_page.dart
├── plaza_page.dart
├── project_page.dart
└── routes
    └── routes.dart
```

### base_widgets模块
基础公用widgets模块，抽离的基础widget壳放置于此

结构
```
├── article_item_layout.dart
└── pages
    ├── detail_page.dart
    ├── login_register_page.dart
    ├── my_colllect_page.dart
    ├── my_shared_page.dart
    ├── my_todo_page.dart
    ├── search_page.dart
    ├── search_result_page.dart
    └── setting_page.dart
```

## 总结
    整体结构还有待完善，颗粒度依然较大，比如：
    1 模块中针对每个独立业务单元理论上是可单独运行的，好比 搜索、个人中心 等都可抽取出一个可独立运行的模块单元
    2 路由模块目前映射都是固定的，切被放置在main_page 模块中，这样是不合理的，正常流程是将路由单独出来，让其被业务单元模块依赖，
    实现根据业务模块配置动态注册
    3 针对资源管理，如 字体、图片、主题等资源可以由单独的模块进行统一处理分配，业务组件依赖此资源模块，进行实现资源相关的高效管理（资源维护）

## 缺点
    根据开发实践来看，模块的更新暂不出发jit（可能没找到对应方法）