// Verse Model
class Verse {
  final String id;
  final String text;
  final String? reference; // e.g., "John 3:16"
  final String? book;
  final int? chapter;
  final int? verseNumber;
  final List<String> topics;
  final bool isPersonalized;

  const Verse({
    required this.id,
    required this.text,
    this.reference,
    this.book,
    this.chapter,
    this.verseNumber,
    this.topics = const [],
    this.isPersonalized = false,
  });

  String getDisplayText(String? userName) {
    if (isPersonalized && userName != null && userName.isNotEmpty) {
      return text.replaceAll('{name}', userName);
    }
    return text;
  }

  // Get source string for display
  String get source => reference ?? book ?? 'Unknown';
}

// Topic Model
class Topic {
  final String id;
  final String name;
  final String icon;
  final String category;
  final bool isPremium;

  const Topic({
    required this.id,
    required this.name,
    required this.icon,
    required this.category,
    this.isPremium = true,
  });
}

// Prayer Model
class Prayer {
  final String id;
  final String title;
  final String content;
  final String topic;
  final bool isPersonalized;

  const Prayer({
    required this.id,
    required this.title,
    required this.content,
    required this.topic,
    this.isPersonalized = false,
  });

  String getDisplayContent(String? userName) {
    if (isPersonalized && userName != null && userName.isNotEmpty) {
      return content.replaceAll('{name}', userName);
    }
    return content;
  }
}

// Collection Model
class Collection {
  final String id;
  final String name;
  final List<String> verseIds;
  final DateTime createdAt;

  const Collection({
    required this.id,
    required this.name,
    required this.verseIds,
    required this.createdAt,
  });
}

// Custom Quote Model
class CustomQuote {
  final String id;
  final String text;
  final String? source;
  final DateTime createdAt;

  const CustomQuote({
    required this.id,
    required this.text,
    this.source,
    required this.createdAt,
  });
}

// Reading History Entry
class HistoryEntry {
  final String verseId;
  final DateTime viewedAt;

  const HistoryEntry({
    required this.verseId,
    required this.viewedAt,
  });

  Map<String, dynamic> toJson() => {
    'verseId': verseId,
    'viewedAt': viewedAt.toIso8601String(),
  };

  factory HistoryEntry.fromJson(Map<String, dynamic> json) => HistoryEntry(
    verseId: json['verseId'] as String,
    viewedAt: DateTime.parse(json['viewedAt'] as String),
  );
}

// User Model
class UserProfile {
  final String? name;
  final int? ageRange; // index
  final String? gender;
  final List<String> selectedTopics;
  final String selectedThemeId;
  final int streakCount;
  final DateTime? lastActiveDate;
  final List<String> favoriteVerseIds;
  final List<Collection> collections;
  final List<CustomQuote> customQuotes;
  final List<HistoryEntry> readingHistory;
  final bool isPremium;
  final bool hasCompletedOnboarding;
  final WidgetSettings widgetSettings;

  const UserProfile({
    this.name,
    this.ageRange,
    this.gender,
    this.selectedTopics = const [],
    this.selectedThemeId = 'golden_water',
    this.streakCount = 0,
    this.lastActiveDate,
    this.favoriteVerseIds = const [],
    this.collections = const [],
    this.customQuotes = const [],
    this.readingHistory = const [],
    this.isPremium = false,
    this.hasCompletedOnboarding = false,
    this.widgetSettings = const WidgetSettings(),
  });

  UserProfile copyWith({
    String? name,
    int? ageRange,
    String? gender,
    List<String>? selectedTopics,
    String? selectedThemeId,
    int? streakCount,
    DateTime? lastActiveDate,
    List<String>? favoriteVerseIds,
    List<Collection>? collections,
    List<CustomQuote>? customQuotes,
    List<HistoryEntry>? readingHistory,
    bool? isPremium,
    bool? hasCompletedOnboarding,
    WidgetSettings? widgetSettings,
  }) {
    return UserProfile(
      name: name ?? this.name,
      ageRange: ageRange ?? this.ageRange,
      gender: gender ?? this.gender,
      selectedTopics: selectedTopics ?? this.selectedTopics,
      selectedThemeId: selectedThemeId ?? this.selectedThemeId,
      streakCount: streakCount ?? this.streakCount,
      lastActiveDate: lastActiveDate ?? this.lastActiveDate,
      favoriteVerseIds: favoriteVerseIds ?? this.favoriteVerseIds,
      collections: collections ?? this.collections,
      customQuotes: customQuotes ?? this.customQuotes,
      readingHistory: readingHistory ?? this.readingHistory,
      isPremium: isPremium ?? this.isPremium,
      hasCompletedOnboarding: hasCompletedOnboarding ?? this.hasCompletedOnboarding,
      widgetSettings: widgetSettings ?? this.widgetSettings,
    );
  }
}

// Onboarding Question Model
class OnboardingQuestion {
  final String id;
  final String question;
  final List<String> options;
  final bool allowSkip;
  final bool isMultiSelect;

  const OnboardingQuestion({
    required this.id,
    required this.question,
    required this.options,
    this.allowSkip = true,
    this.isMultiSelect = false,
  });
}

// Widget Refresh Frequency
enum WidgetRefreshFrequency {
  never('Never', Duration(days: 365 * 100)), // essentially never
  daily('Every day', Duration(hours: 24)),
  twiceDaily('Not very often (1-2 times/day)', Duration(hours: 12)),
  everySixHours('Every 6 hours', Duration(hours: 6)),
  hourly('Every hour', Duration(hours: 1)),
  veryOften('Very often (1-2 times/hour)', Duration(minutes: 30));

  final String displayName;
  final Duration duration;

  const WidgetRefreshFrequency(this.displayName, this.duration);
}

// Widget Content Type
enum WidgetContentType {
  general('General'),
  favorites('Favorites'),
  bibleVerses('Bible verses'),
  prayers('Prayers'),
  followedTopics('Followed topics');

  final String displayName;

  const WidgetContentType(this.displayName);
}

// Widget Button Style
enum WidgetButtonStyle {
  none('None'),
  saveOnly('Save to favorites'),
  saveAndShare('Save to favorites and Share');

  final String displayName;

  const WidgetButtonStyle(this.displayName);
}

// Widget Text Size
enum WidgetTextSize {
  small('Small', 14.0),
  medium('Medium', 16.0),
  large('Large', 18.0),
  extraLarge('Extra Large', 20.0);

  final String displayName;
  final double fontSize;

  const WidgetTextSize(this.displayName, this.fontSize);
}

// Widget Settings Model
class WidgetSettings {
  final String name;
  final String themeId;
  final WidgetTextSize textSize;
  final WidgetRefreshFrequency refreshFrequency;
  final WidgetContentType contentType;
  final WidgetButtonStyle buttonStyle;
  final DateTime? lastRefreshed;

  const WidgetSettings({
    this.name = 'Bible Widget',
    this.themeId = 'golden_water',
    this.textSize = WidgetTextSize.medium,
    this.refreshFrequency = WidgetRefreshFrequency.daily,
    this.contentType = WidgetContentType.general,
    this.buttonStyle = WidgetButtonStyle.saveOnly,
    this.lastRefreshed,
  });

  WidgetSettings copyWith({
    String? name,
    String? themeId,
    WidgetTextSize? textSize,
    WidgetRefreshFrequency? refreshFrequency,
    WidgetContentType? contentType,
    WidgetButtonStyle? buttonStyle,
    DateTime? lastRefreshed,
  }) {
    return WidgetSettings(
      name: name ?? this.name,
      themeId: themeId ?? this.themeId,
      textSize: textSize ?? this.textSize,
      refreshFrequency: refreshFrequency ?? this.refreshFrequency,
      contentType: contentType ?? this.contentType,
      buttonStyle: buttonStyle ?? this.buttonStyle,
      lastRefreshed: lastRefreshed ?? this.lastRefreshed,
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'themeId': themeId,
    'textSize': textSize.name,
    'refreshFrequency': refreshFrequency.name,
    'contentType': contentType.name,
    'buttonStyle': buttonStyle.name,
    'lastRefreshed': lastRefreshed?.toIso8601String(),
  };

  factory WidgetSettings.fromJson(Map<String, dynamic> json) {
    return WidgetSettings(
      name: json['name'] as String? ?? 'Bible Widget',
      themeId: json['themeId'] as String? ?? 'golden_water',
      textSize: WidgetTextSize.values.firstWhere(
        (e) => e.name == json['textSize'],
        orElse: () => WidgetTextSize.medium,
      ),
      refreshFrequency: WidgetRefreshFrequency.values.firstWhere(
        (e) => e.name == json['refreshFrequency'],
        orElse: () => WidgetRefreshFrequency.daily,
      ),
      contentType: WidgetContentType.values.firstWhere(
        (e) => e.name == json['contentType'],
        orElse: () => WidgetContentType.general,
      ),
      buttonStyle: WidgetButtonStyle.values.firstWhere(
        (e) => e.name == json['buttonStyle'],
        orElse: () => WidgetButtonStyle.saveOnly,
      ),
      lastRefreshed: json['lastRefreshed'] != null
          ? DateTime.parse(json['lastRefreshed'] as String)
          : null,
    );
  }
}
