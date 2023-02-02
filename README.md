# Ticos 可观测性 SDK

让你对固件的发布充满信心。

# 开始

要完成对平台的整合，请
[先注册](https://console.ticos.cn/)。

# 组件

本 SDK 设计为一系列组件的集合，你可以只包含项目需要的特性。本 SDK 设计时也将对代码空间、带宽以及电源消耗的影响降至最低。

[`components`](components/) 目录文件夹包含 SDK 的各个组件。每个组件包含 `readme.md`，源代码，头文件和 “platform” 头文件。

Platform 头文件描述了组件所依赖的必须实现的接口。

对于某些平台依赖，我们提供了可直接链接到你的系统的移植实现，或用作进一步自定义的模板。你可以在 [`ports`](ports/) 文件夹中找到它们。

对于一些流行的 MCU 和供应商 SDK，我们已经提供了平台依赖的参考实现，可以在 [`examples`](examples/) 文件夹中找到。这些也可以作为在最初在你的平台上设置 SDK 时的一个很好的例子。

### 主要组件

- `panics` - 故障处理，coredump 和重启跟踪以及重启循环检测 API。
- `metrics` - 长时间监视设备健康状况，例如连接性，电池寿命， MCU 资源利用率，硬件退化等。
 
请参考每个文件夹中的 `readme.md` 了解更多细节。

### 支持的组件

- `core` – 所有其他组件使用的通用代码。
- `demo` - 各个平台的 demo 应用程序使用的通用代码。
- `http` – 用于从设备直接将 coredumps 和事件 post 到 ticos 服务的 http 客户端 API。
- `util` – 各种辅助代码。

# 集成 Ticos 可观测性 SDK

## 添加 Ticos 可观测性 SDK 到你的库

TICOS SDK 可以直接添加到你的存储库中。 结构通常看起来像：

```
<YOUR_PROJECT>
├── third_party/ticos
│               ├── ticos-firmware-sdk (submodule)
│               │
│               │ # 平台移植需要实现的文件
│               ├── ticos_platform_port.c
│               ├── ticos_platform_coredump_regions.c
│               │
│               │ # 配置头文件
│               ├── ticos_platform_config.h
│               ├── ticos_trace_reason_user_config.def
│               ├── ticos_metrics_heartbeat_config.def
│               └── ticos_platform_log_config.h
```

你可以使用 `git`，将 Ticos SDK 添加到项目中作为子模块：

```
$ git submodule add https://github.com/tiwater/observability-mcu-sdk.git $YOUR_PROJECT/third_party/ticos/ticos-firmware-sdk
```

这使得跟踪Ticos SDK的历史变化变得更加容易。你不需要对Ticos SDK做任何更改。更新的一般流程如下:

- `git pull` 拉取 upstream 最新的主机记录。
- 检查 [CHANGES.md](CHANGES.md)，看看是否需要做任何更改。
- 你的库中的子模块更新至新的提交。

另外，你也可以将 Ticos SDK 添加到项目中作为 git 子目录，或者将源代码复制到项目中。

## 添加源代码到构建系统中

### Make

如果使用 `make`，可以使用 `makefiles/TicosWorker.mk` 来非常方便地收集 Ticos SDK 所需的源文件和包含路径；

```c
TICOS_SDK_ROOT := <从你的项目到本 SDK 根目录的路径>
TICOS_COMPONENTS := <要使用的SDK组件，例如“core util”>
include $(TICOS_SDK_ROOT)/makefiles/TicosWorker.mk
<YOUR_SRC_FILES> += $(TICOS_COMPONENTS_SRCS)
<YOUR_INCLUDE_PATHS> += $(TICOS_COMPONENTS_INC_FOLDERS)
```

### Cmake

使用cmake，也可以利用 `cmake/Ticos.cmake` 类似地收集源文件和包含路径：

```c
set(TICOS_SDK_ROOT <本 SDK 根目录的路径>)
list(APPEND TICOS_COMPONENTS <要使用的SDK组件，例如“core util”>)
include(${TICOS_SDK_ROOT}/cmake/Ticos.cmake)
ticos_library(${TICOS_SDK_ROOT} TICOS_COMPONENTS
 TICOS_COMPONENTS_SRCS TICOS_COMPONENTS_INC_FOLDERS)

# ${TICOS_COMPONENTS_SRCS} contains the sources
# needed for the library and ${TICOS_COMPONENTS_INC_FOLDERS} contains the include paths
```

### 其他构建系统

如果您不使用上述构建系统之一，要包含SDK，您需要做的是：

- 将位于 `components/<component>/src/*.c` 的 `.c` 文件添加到您的构建系统中
- 将 `components/<component>/include` 添加到传递给编译器的include路径

### 运行单元测试

SDK 代码受到单元测试的全面覆盖。它们可以在 `tests/` 文件夹中找到。如果您想自己运行它们，请查看 [tests/README.md](tests/README.md) 中的说明。

要了解有关固件开发的单元测试最佳实践的更多信息，请查看我们的[博客文章](https://interrupt.ticos.com/blog/unit-testing-basics) ！

单元测试由 CircleCI 在提交此存储库时运行。有关主分支的构建和测试覆盖率状态，请查看顶部的徽章。

# 常见问题

- 为什么在上传后，“问题”中没有出现coredump？

  - 请确保将符号上传到您上传coredumps的相同项目。还要确保设备报告的软件类型和软件版本（参见 `components/core/README.md` 中的“设备信息”）与在线创建软件版本和符号工件时输入的软件类型和软件版本相匹配。
  [有关构建ID和上传符号文件的更多信息，请参见此处](https://ticos.io/symbol-file-build-ids)。

- 我遇到错误 XYZ，现在该怎么办？

  - 不要犹豫，联系我们寻求帮助！您可以通过 [hi@tiwater.com](mailto:hi@tiwater.com) 与我们联系。

# 许可证

除非特别在文件中指出，否则 ticos-mcu-sdk 中的所有文件均根据 ticos 许可证授权。 （[examples](/examples) 和 [ports](/ports) 目录中的一些文件根据供应商的要求，会有许可证上的差别。）