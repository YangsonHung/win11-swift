# Win11 Desktop Simulator

**[Original](README.md)** | 中文

使用 SwiftUI 开发的原生 macOS 应用，模拟 Windows 11 桌面系统。

![Screenshot](example.jpg)

## 功能特性

### 桌面环境
- Windows 11 风格桌面背景
- 可交互的桌面图标（双击打开应用）
- 任务栏（开始按钮、应用图标、时间显示）
- 开始菜单（搜索框、固定应用、电源按钮）

### 窗口管理
- 可拖拽窗口
- 最小化/最大化/关闭功能
- 窗口阴影和圆角效果

### 内置应用

| 应用 | 功能 |
|------|------|
| Microsoft Edge (浏览器) | 访问网络、前进、后退、刷新 |
| File Explorer (文件资源管理器) | 浏览文件和文件夹 |
| Notepad (记事本) | 文本编辑、保存文件 |
| Settings (设置) | Windows 11 风格设置界面 |
| Calculator (计算器) | 完整计算器功能 |

## 技术栈

- **UI 框架**: SwiftUI + AppKit
- **浏览器**: WKWebView (WebKit)
- **构建工具**: XcodeGen

## 项目结构

```
win11-swift/
├── project.yml                    # XcodeGen 配置
├── Win11Desktop/
│   ├── App/
│   │   ├── Win11DesktopApp.swift  # 应用入口
│   │   └── AppDelegate.swift       # 应用代理
│   ├── Models/
│   │   ├── AppState.swift          # 全局状态管理
│   │   └── DesktopIcon.swift       # 桌面图标模型
│   ├── Views/
│   │   ├── Desktop/
│   │   │   ├── DesktopView.swift   # 桌面主视图
│   │   │   └── DesktopIconView.swift
│   │   ├── Taskbar/
│   │   │   ├── TaskbarView.swift   # 任务栏
│   │   │   └── StartMenuView.swift # 开始菜单
│   │   ├── Windows/
│   │   │   └── DraggableWindow.swift # 可拖拽窗口
│   │   └── Apps/
│   │       ├── BrowserView.swift   # 浏览器
│   │       ├── ExplorerView.swift  # 文件资源管理器
│   │       ├── NotepadView.swift   # 记事本
│   │       ├── SettingsView.swift  # 设置
│   │       └── CalculatorView.swift # 计算器
│   └── Resources/
│       └── Assets.xcassets         # 应用图标
```

## 快速开始

### 环境要求
- macOS 13.0 或更高版本
- Xcode 15.0 或更高版本

### 构建步骤

1. 克隆项目并进入目录:
   ```bash
   cd win11-swift
   ```

2. 使用 XcodeGen 生成项目:
   ```bash
   xcodegen generate
   ```

3. 在 Xcode 中打开项目:
   ```bash
   open Win11Desktop.xcodeproj
   ```

4. 按 `Cmd + R` 运行应用

### 直接运行

构建产物位于:
```
~/Library/Developer/Xcode/DerivedData/Win11Desktop-*/Build/Products/Debug/Win11 Desktop.app
```

## 使用说明

1. **打开应用**: 点击开始按钮或双击桌面图标
2. **切换应用**: 点击任务栏上的应用图标
3. **关闭窗口**: 点击窗口右上角的关闭按钮
4. **移动窗口**: 拖拽窗口标题栏
5. **浏览器操作**: 在地址栏输入 URL，按 Enter 访问
6. **记事本保存**: 点击 File -> Save 保存文件

## 注意事项

- 浏览器需要网络连接才能访问网站
- 记事本保存功能会打开系统保存对话框
- 应用设置为 accessory 模式，作为桌面模拟器运行

## 许可证

MIT License
