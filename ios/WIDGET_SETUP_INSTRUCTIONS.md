# iOS Widget Extension 设置指南

我已经创建了 Widget Extension 的代码文件，但需要在 Xcode 中手动添加 target。请按照以下步骤操作：

## 步骤 1: 打开 Xcode 项目

```bash
open "/Users/vincent/Desktop/bible widget /code/bible_widgets/ios/Runner.xcworkspace"
```

## 步骤 2: 添加 Widget Extension Target

1. 在 Xcode 菜单栏选择 **File > New > Target...**
2. 在弹出窗口中选择 **iOS > Widget Extension**
3. 点击 **Next**
4. 填写以下信息：
   - **Product Name**: `BibleWidgetExtension`
   - **Team**: 选择你的开发者账号
   - **Bundle Identifier**: `com.oneapp.bibleWidgets.BibleWidgetExtension`
   - **Include Configuration App Intent**: 取消勾选（不需要）
5. 点击 **Finish**
6. 如果弹出 "Activate scheme?" 对话框，选择 **Activate**

## 步骤 3: 删除自动生成的文件

Xcode 会自动生成一些模板文件，我们需要用已创建的文件替换它们：

1. 在 Xcode 左侧 Project Navigator 中找到 `BibleWidgetExtension` 文件夹
2. 删除 Xcode 自动生成的所有 `.swift` 文件（通常有 `BibleWidgetExtension.swift` 等）
3. 右键点击 `BibleWidgetExtension` 文件夹
4. 选择 **Add Files to "Runner"...**
5. 导航到 `ios/BibleWidgetExtension/` 文件夹
6. 选择 `BibleWidget.swift` 和 `Info.plist`
7. 确保勾选 **"Copy items if needed"** 已取消
8. 确保 Target 选择了 `BibleWidgetExtension`
9. 点击 **Add**

## 步骤 4: 配置 App Groups

### 为主 App (Runner) 配置：

1. 在 Project Navigator 中选择 **Runner** 项目（蓝色图标）
2. 选择 **Runner** target
3. 点击 **Signing & Capabilities** 标签
4. 点击 **+ Capability** 按钮
5. 搜索并添加 **App Groups**
6. 点击 App Groups 下的 **+** 按钮
7. 输入: `group.com.oneapp.bibleWidgets`
8. 点击 **OK**

### 为 Widget Extension 配置：

1. 选择 **BibleWidgetExtension** target
2. 点击 **Signing & Capabilities** 标签
3. 点击 **+ Capability** 按钮
4. 搜索并添加 **App Groups**
5. 勾选 `group.com.oneapp.bibleWidgets`（应该已经存在）

## 步骤 5: 添加 Entitlements 文件

### 为主 App：
1. 选择 **Runner** target
2. 点击 **Build Settings** 标签
3. 搜索 "Code Signing Entitlements"
4. 将值设置为: `Runner/Runner.entitlements`

### 为 Widget Extension：
1. 选择 **BibleWidgetExtension** target
2. 点击 **Build Settings** 标签
3. 搜索 "Code Signing Entitlements"
4. 将值设置为: `BibleWidgetExtension/BibleWidgetExtension.entitlements`

## 步骤 6: 设置部署目标

1. 选择 **BibleWidgetExtension** target
2. 点击 **General** 标签
3. 将 **Minimum Deployments** 设置为 **iOS 14.0** 或更高

## 步骤 7: 构建和测试

1. 选择 **Runner** scheme（不是 BibleWidgetExtension）
2. 选择你的真机或模拟器
3. 按 **Cmd + B** 构建
4. 按 **Cmd + R** 运行

## 测试 Widget

1. 在 iOS 设备上长按主屏幕
2. 点击左上角的 **+** 按钮
3. 搜索 "Bible" 或 "Bible Widget"
4. 选择想要的尺寸（小/中/大）
5. 点击 "Add Widget"

## 常见问题

### Q: 找不到 Widget？
确保：
- Widget Extension target 已正确添加
- App Groups 配置正确
- 设备已重启或等待几分钟让 Widget 出现

### Q: Widget 显示空白？
确保：
- App Groups ID 完全匹配 (`group.com.oneapp.bibleWidgets`)
- 主 App 至少运行过一次
- Flutter 代码中正确调用了 `HomeWidget.saveWidgetData()`

### Q: 签名错误？
确保：
- 两个 target 使用相同的开发者团队
- App Groups 已正确配置
- Provisioning Profiles 已更新
