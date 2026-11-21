# EzWindows.ahk

基于 **AutoHotkey v2** 构建的轻量级配置框架，提供了一个在 Windows 上自由控制窗口和虚拟桌面的框架，带来类似 Linux 平铺/动态窗口管理器（Window Manager）的高效键盘与鼠标操控体验。

---

## 核心特性

- **自由的窗口控制**：支持通过快捷键快速关闭、强制终止、最大化/还原当前窗口；支持按住 `LWin + 鼠标左键` 在窗口任意位置直接拖拽移动窗口，按住 `LWin + 鼠标右键` 直接拖拽调整窗口大小。
- **高效的虚拟桌面管理**：支持通过快捷键在多个虚拟桌面之间无动画快速跳转，或将当前活动窗口一键迁移至指定虚拟桌面并自动跟随。
- **全屏应用防干扰**：内置全屏状态检测（`fullscreen.ahk`），当检测到游戏等全屏应用运行时，自动挂起（`Suspend`）AHK 并禁用所有按键绑定；同时支持配置排除列表（`FullScreenExcludeList`，默认包含 Firefox、Edge、Chrome 等浏览器），确保浏览器全屏浏览或全屏看视频时快捷键依然正常可用。
- **解耦的按键配置**：将通用快捷键（`keybind.ahk`）与窗口/桌面管理快捷键（`wm_keybind.ahk`）集中拆分管理，方便随时按个人习惯定制。

---

## 目录结构

```text
EzWindows.ahk/
├── init.ahk                  # 主入口脚本，加载全屏检测、通用热键并启动窗口管理器
├── keybind.ahk               # 通用快捷键绑定（启动应用、音量控制、输入法切换等）
├── fullscreen.ahk            # 全屏应用检测与排除列表配置（全屏时自动暂停 AHK）
├── wm_init.ahk               # 窗口管理器（WM）入口，组织窗口与虚拟桌面模块
├── wm_keybind.ahk            # 窗口与虚拟桌面管理相关的按键绑定
├── wm_virtual-desktop.ahk    # 虚拟桌面切换与窗口跨桌面移动逻辑
├── wm_mouse-easy-window.ahk  # 鼠标拖拽移动窗口与调整窗口大小逻辑
├── setup.bat                 # 自动创建 ./resources/lib 目录并拉取 VD.ah2 依赖
└── resources/
    ├── lib/
    │   └── VD.ah2            # 虚拟桌面控制库（由 setup.bat 下载）
    └── bin/                  # 可选外部二进制工具目录（如 im-select.exe）
```

---

## 快速开始

1. 确保已安装 [AutoHotkey v2.0+](https://www.autohotkey.com/)（**注意：AutoHotkey 必须安装到默认路径，否则 `UIAccess` 权限将不会生效**）。
2. 在项目根目录下双击或在终端运行 `setup.bat`，脚本会自动创建 `./resources` 和 `./resources/lib` 文件夹，并从 `VD.ahk (v2_port)` 获取 `VD.ah2` 到 `./resources/lib/VD.ah2`：
   ```bat
   .\setup.bat
   ```
3. 运行 `init.ahk` 启动配置（若只需启动窗口与虚拟桌面管理，也可直接运行 `wm_init.ahk`）。

---

## 禁用 Windows 默认快捷键 (`DisabledHotkeys`)

在 Windows 系统中，资源管理器（`explorer.exe`）默认注册了许多 `Win + <按键>` 的系统级快捷键，容易与自定义的窗口和桌面管理快捷键冲突。可以通过在注册表中创建 `DisabledHotkeys` 来按需禁用这些内置快捷键。

### 注册表路径

```text
HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced
```

### 配置步骤

1. 按 `Win + R` 输入 `regedit` 打开**注册表编辑器**。
2. 导航至上述路径：
   `HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced`
3. 在右侧空白处右键 -> **新建** -> **字符串值 (`REG_SZ`)**，将其命名为：
   `DisabledHotkeys`
4. 双击 `DisabledHotkeys`，在**数值数据**中填入需要禁用的 `Win + <Key>` 对应的按键字符（使用大写字母或数字直接拼接，无需空格或分隔符）。
   - 例如，若要禁用本项目默认占用的 `Win + 1/2/3/4/9/0/Q/T/W/M/C`，可将其值设为：`123490QTWMC`。
5. 也可以直接在终端（CMD / PowerShell）中执行以下命令创建并重启资源管理器生效：
   ```bat
   reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v DisabledHotkeys /t REG_SZ /d "123490QTWMC" /f
   taskkill /f /im explorer.exe & start explorer.exe
   ```

### 可通过 `DisabledHotkeys` 禁用的常见快捷键说明

在 `DisabledHotkeys` 中填入对应字符后，即可禁用由 `explorer.exe` 注册的相应 `Win + <字符>`（以及部分 `Win + Shift + <字符>`）默认快捷键：

| 填入字符 | 禁用的默认快捷键 | Windows 默认功能 |
| :--- | :--- | :--- |
| `0` ~ `9` | `Win + 0~9` / `Win + Shift + 0~9` | 启动或切换到任务栏上固定位置（第 1~10 个）的应用 |
| `Q` / `S` | `Win + Q` / `Win + S` | 打开 Windows 搜索 |
| `W` | `Win + W` | 打开小组件（Widgets）面板 |
| `M` | `Win + M` / `Win + Shift + M` | 最小化所有窗口 / 还原最小化的窗口 |
| `T` | `Win + T` | 在任务栏上的应用程序之间循环切换焦点 |
| `C` | `Win + C` | 打开 Copilot / Cortana |
| `E` | `Win + E` | 打开文件资源管理器 |
| `R` | `Win + R` | 打开“运行”对话框 |
| `D` | `Win + D` | 显示或隐藏桌面 |
| `I` | `Win + I` | 打开 Windows 设置 |
| `A` | `Win + A` | 打开快捷设置 / 操作中心 |
| `N` | `Win + N` | 打开通知中心与日历 |
| `K` | `Win + K` | 打开无线投屏 / 连接面板 |
| `H` | `Win + H` | 启动语音输入（听写） |
| `V` | `Win + V` | 打开云剪贴板历史记录 |
| `X` | `Win + X` | 打开开始按钮高级上下文菜单 |
| `B` | `Win + B` | 将焦点设置到任务栏系统托盘图标区 |
| `,` | `Win + ,` | 临时透视桌面（Aero Peek） |

> **注意**：修改 `DisabledHotkeys` 后，需要**重启 `explorer.exe`（Windows 资源管理器）**或注销/重新登录系统方可生效。此外，极少数由系统底层组件（而非 `explorer.exe`）直接接管的快捷键（如 `Win + L` 锁定屏幕、`Win + G` Xbox Game Bar、`Win + P` 投影模式、`Win + U` 辅助功能）不受 `DisabledHotkeys` 控制。

---

## 修改 Keybind 适配个人习惯

本项目将快捷键统一抽离在两个独立的配置文件中，只需修改这两个文件即可适配自己的操作习惯：

- **`wm_keybind.ahk`**：管理所有窗口与虚拟桌面操作相关的快捷键。
- **`keybind.ahk`**：管理日常应用启动、音量调节、输入法切换等通用快捷键。
- **`fullscreen.ahk`**：管理 `FullScreenExcludeList` 全屏排除列表（如添加其它不希望全屏时暂停热键的进程名）。

### AutoHotkey v2 常用按键修饰符

| 符号 | 含义 | 示例 |
| :--- | :--- | :--- |
| `#` | `Win` 键 | `#q` 表示 `Win + Q` |
| `!` | `Alt` 键 | `!1` 表示 `Alt + 1` |
| `+` | `Shift` 键 | `#+q` 表示 `Win + Shift + Q` |
| `^` | `Ctrl` 键 | `^!t` 表示 `Ctrl + Alt + T` |
| `<` / `>` | 区分左右修饰键（如 `<#` 左 Win、`>!` 右 Alt） | `<#1` 表示 `左 Win + 1` |
| `&` | 组合两个任意按键或鼠标按键 | `LWin & LButton` 表示 `左 Win + 鼠标左键` |

### 当前默认按键绑定一览

#### 1. 窗口与虚拟桌面管理（`wm_keybind.ahk`）

| 快捷键 | 功能说明 | 调用函数/动作 |
| :--- | :--- | :--- |
| `Win + Q` (`#q`) | 正常关闭当前活动窗口 | `PostMessage 0x0112, 0xF060, , , "A"` |
| `Win + Shift + Q` (`#+q`) | 强制结束当前活动窗口 | `WinKill("A")` |
| `Win + T` (`#t`) | 最大化或还原当前活动窗口 | `MaximizeOrRestoreWindow()` |
| `LWin + 鼠标左键` | 在窗口内任意位置拖拽移动窗口（按 `Esc` 取消并复位） | `EWD_MoveWindow()` |
| `LWin + 鼠标右键` | 在非最大化窗口内拖拽调整窗口大小 | `EWD_ReSizeWindow()` |
| `Win + 1 / 2 / 3 / 4` | 跳转到虚拟桌面 1 ~ 4（内部索引 `0 ~ 3`） | `DeskMove(0 ~ 3)` |
| `Win + W / M / 9 / 0` | 跳转到虚拟桌面 5 ~ 8（内部索引 `4 ~ 7`） | `DeskMove(4 ~ 7)` |
| `Win + Shift + 1 / 2 / 3 / 4` | 将当前窗口移动到虚拟桌面 1 ~ 4 并跟随跳转 | `WinMoveToDesk(0 ~ 3)` |
| `Win + Shift + W / M / 9 / 0` | 将当前窗口移动到虚拟桌面 5 ~ 8 并跟随跳转 | `WinMoveToDesk(4 ~ 7)` |

#### 2. 通用快捷键（`keybind.ahk`）

| 快捷键 | 功能说明 |
| :--- | :--- |
| `Win + C` (`#c`) | 启动 Chrome 浏览器 |
| `Win + Enter` (`#Enter`) | 启动 Windows Terminal (`wt`) |
| `Win + Shift + Up / Down` | 增大 / 减小系统音量 |
| 单按 `Shift` (`~Shift`) | 释放时调用 `./resources/bin/im-select.exe` 切换输入法 |

### 自定义示例

如果你习惯使用 `Alt` 代替 `Win` 进行虚拟桌面切换，或想调整鼠标拖拽热键，只需直接编辑 `wm_keybind.ahk`：

```ahk
; 示例：改为 Alt + 数字 切换虚拟桌面，Alt + Shift + 数字 移动窗口
!1:: DeskMove(0)
!2:: DeskMove(1)
!+1:: WinMoveToDesk(0)
!+2:: WinMoveToDesk(1)

; 示例：改为 Alt + 鼠标左键/右键 拖拽和缩放窗口
LAlt & LButton:: EWD_MoveWindow()
LAlt & RButton:: EWD_ReSizeWindow()
```

---

## 相关依赖

- **[FuPeiJiang/VD.ahk (`v2_port` 分支)](https://github.com/FuPeiJiang/VD.ahk/tree/v2_port)**（**当前使用的依赖**）
  - AutoHotkey v2 版本的 Windows 虚拟桌面控制库，直接通过 COM 接口实现毫秒级无动画桌面切换与窗口跨桌面移动。
  - 可运行仓库根目录的 `setup.bat` 自动下载 [VD.ah2](https://github.com/FuPeiJiang/VD.ahk/blob/v2_port/VD.ah2) 至 `./resources/lib/VD.ah2`。
- **[MScholtes/VirtualDesktop](https://github.com/MScholtes/VirtualDesktop)**（**已弃用但仍然可参考**）
  - 早期使用的命令行虚拟桌面管理工具。由于存在切换虚拟桌面后目标桌面窗口无法正常激活的问题（详见 [MScholtes/VirtualDesktop#105](https://github.com/MScholtes/VirtualDesktop/issues/105)），目前已替换为 `VD.ahk`。
- **[daipeihust/im-select](https://github.com/daipeihust/im-select)**（可选）
  - `keybind.ahk` 中单按 `Shift` 切换输入法功能所依赖的命令行工具，如需使用请将 `im-select.exe` 放置于 `./resources/bin/im-select.exe`。
