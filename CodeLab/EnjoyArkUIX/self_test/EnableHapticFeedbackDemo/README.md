# EnableHapticFeedbackDemo

### 介绍
本示例用于验证组件触觉反馈（Haptic Feedback）相关能力，覆盖 Picker、Slider、Text、Web、AlphabetIndexer、Drag、UI Picker 以及 ContextMenu 等交互场景。

### 功能概述
本示例主要包含以下测试页面：

1. Picker
2. Slider
3. Text
4. Web
5. AlphabetIndexer
6. Drag
7. UI Picker
8. CommonBindContextMenu
9. RicheditorContextMenu
10. WebBindContextMenu

### 效果预览
<img src="interface/EnableHapticFeedback.jpeg" width="270" />

### 使用说明
1. 启动应用后进入首页“组件示例”。
2. 点击任一功能卡片进入对应测试页。
3. 在各页面执行点击、滑动、拖拽、菜单弹出等操作，观察触觉反馈表现。
4. 若需测试 Web 相关页面，请确保可访问网页资源。

### 工程目录
```
src/main/
|---ets/
|   |---enablehapticfeedbackdemoability/
|   |   |---EnableHapticFeedbackDemoAbility.ets
|   |---pages/
|   |   |---Index.ets
|   |   |---Picker.ets
|   |   |---Slider.ets
|   |   |---Text.ets
|   |   |---Web.ets
|   |   |---AlphabetIndexer.ets
|   |   |---Drag.ets
|   |   |---uipicker.ets
|   |   |---CommonBindContextMenu.ets
|   |   |---RicheditorContextMenu.ets
|   |   |---WebBindContextMenu.ets
|---resources/
|   |---base/
|   |   |---profile/
|   |   |   |---main_pages.json
|---module.json5
```

### 具体实现
- 首页采用卡片网格导航，将多种交互组件拆分到独立页面，便于逐项验证。
- 通过不同组件触发路径（点击、滑动、拖拽、长按菜单）覆盖触觉反馈能力。
- 包含文本、富文本、Web 场景下的菜单绑定测试，验证统一交互体验。

### 相关权限
模块中声明了以下权限：

- ohos.permission.INTERNET
- ohos.permission.VIBRATE

### 依赖
- ArkUI 组件交互能力
- 震动与触觉反馈相关系统能力
