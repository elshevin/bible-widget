# Bible Widgets - Flutter Demo

一个精美的圣经经文和励志语录小组件应用Demo，基于竞品分析设计。

## 功能特性

### 核心功能
- ✅ **全屏经文Feed** - 垂直滑动浏览经文/励志语
- ✅ **主题皮肤** - 12种预设渐变主题可选
- ✅ **个性化** - 支持用户名插入到内容中
- ✅ **收藏系统** - 收藏喜欢的经文
- ✅ **分享功能** - 生成卡片分享到社交媒体
- ✅ **Streak打卡** - 连续使用天数统计
- ✅ **Topics分类** - 按主题筛选内容
- ✅ **祷告生成** - 简单的祷告文生成

### 页面结构
1. **Welcome Screen** - 启动欢迎页
2. **Onboarding Flow** - 用户信息收集流程
   - 姓名输入
   - 年龄选择
   - 性别选择
   - 主题兴趣选择
   - 视觉主题选择
   - 个性化欢迎语
3. **Home Screen** - 主页经文Feed
4. **Topics Sheet** - 主题分类选择
5. **Themes Sheet** - 视觉主题选择
6. **Profile Sheet** - 个人中心
7. **Settings** - 设置页面
8. **Favorites Screen** - 收藏列表
9. **Prayer Screen** - 祷告页面
10. **Share Sheet** - 分享弹窗
11. **Widget Guide** - 小组件安装引导

## 设计风格

- **主色调**: 温暖米色 (#F5EDE4)
- **强调色**: 金色渐变
- **字体**: Playfair Display (标题) + Inter (正文)
- **圆角**: 16-28px
- **卡片**: 低对比度背景色

## 运行项目

### 环境要求
- Flutter 3.0+
- Dart 3.0+

### 安装步骤

```bash
# 1. 克隆或复制项目到本地

# 2. 进入项目目录
cd bible_widgets

# 3. 获取依赖
flutter pub get

# 4. 运行应用
flutter run
```

### 依赖包
- `provider` - 状态管理
- `google_fonts` - 字体
- `flutter_animate` - 动画
- `share_plus` - 分享功能
- `intl` - 日期格式化

## 项目结构

```
lib/
├── main.dart                 # 应用入口
├── theme/
│   └── app_theme.dart        # 主题配置 & 视觉主题
├── models/
│   └── models.dart           # 数据模型
├── data/
│   └── content_data.dart     # 经文/语录/祷告数据
├── providers/
│   └── app_state.dart        # 状态管理
├── widgets/
│   └── common_widgets.dart   # 通用组件
└── screens/
    ├── welcome_screen.dart   # 欢迎页
    ├── onboarding_flow.dart  # Onboarding流程
    ├── home_screen.dart      # 主页Feed
    ├── topics_sheet.dart     # 主题选择
    ├── themes_sheet.dart     # 皮肤选择
    ├── profile_sheet.dart    # 个人中心
    ├── share_sheet.dart      # 分享弹窗
    ├── favorites_screen.dart # 收藏页面
    └── prayer_screen.dart    # 祷告页面
```

## 内容数据

### 包含的圣经经文
- 25+ 条真实圣经经文
- 涵盖: Hope, Peace, Faith, Love, Healing, Strength, Gratitude 等主题

### 包含的励志语录
- 15+ 条鼓励语/Affirmations
- 部分支持个性化 (插入用户名)

### 包含的祷告
- 8 条祷告模板
- 涵盖: 晨祷、平安、力量、感恩等

## 扩展建议

### 后续可添加功能
1. **真实Widget** - 使用 `home_widget` 包实现iOS/Android小组件
2. **云同步** - 使用 Firebase 同步收藏和设置
3. **更多主题** - 添加图片背景主题
4. **AI祷告** - 集成GPT生成个性化祷告
5. **音频朗读** - TTS功能
6. **推送通知** - 每日经文提醒
7. **Apple Watch** - watchOS 小组件

## 注意事项

- 这是一个Demo项目，用于展示UI/UX设计
- 小组件功能需要原生代码实现
- 付费墙仅展示UI，不包含实际支付逻辑

---

Made with ❤️ for spiritual growth
