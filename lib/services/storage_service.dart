import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/models.dart';

/// Service for persisting user data locally using SharedPreferences
class StorageService {
  static const String _keyUserName = 'user_name';
  static const String _keyAgeRange = 'age_range';
  static const String _keyGender = 'gender';
  static const String _keySelectedTopics = 'selected_topics';
  static const String _keySelectedThemeId = 'selected_theme_id';
  static const String _keyStreakCount = 'streak_count';
  static const String _keyLastActiveDate = 'last_active_date';
  static const String _keyFavoriteVerseIds = 'favorite_verse_ids';
  static const String _keyCollections = 'collections';
  static const String _keyCustomQuotes = 'custom_quotes';
  static const String _keyIsPremium = 'is_premium';
  static const String _keyHasCompletedOnboarding = 'has_completed_onboarding';
  static const String _keyWidgetSettings = 'widget_settings';
  static const String _keyReadingHistory = 'reading_history';

  static SharedPreferences? _prefs;

  /// Initialize SharedPreferences instance
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Save complete user profile
  static Future<void> saveUserProfile(UserProfile user) async {
    if (_prefs == null) await init();

    // Basic info
    if (user.name != null) {
      await _prefs!.setString(_keyUserName, user.name!);
    }
    if (user.ageRange != null) {
      await _prefs!.setInt(_keyAgeRange, user.ageRange!);
    }
    if (user.gender != null) {
      await _prefs!.setString(_keyGender, user.gender!);
    }

    // Topics and theme
    await _prefs!.setStringList(_keySelectedTopics, user.selectedTopics);
    await _prefs!.setString(_keySelectedThemeId, user.selectedThemeId);

    // Streak
    await _prefs!.setInt(_keyStreakCount, user.streakCount);
    if (user.lastActiveDate != null) {
      await _prefs!.setString(_keyLastActiveDate, user.lastActiveDate!.toIso8601String());
    }

    // Favorites
    await _prefs!.setStringList(_keyFavoriteVerseIds, user.favoriteVerseIds);

    // Collections
    final collectionsJson = user.collections.map((c) => jsonEncode({
      'id': c.id,
      'name': c.name,
      'verseIds': c.verseIds,
      'createdAt': c.createdAt.toIso8601String(),
    })).toList();
    await _prefs!.setStringList(_keyCollections, collectionsJson);

    // Custom quotes
    final quotesJson = user.customQuotes.map((q) => jsonEncode({
      'id': q.id,
      'text': q.text,
      'source': q.source,
      'createdAt': q.createdAt.toIso8601String(),
    })).toList();
    await _prefs!.setStringList(_keyCustomQuotes, quotesJson);

    // Premium and onboarding
    await _prefs!.setBool(_keyIsPremium, user.isPremium);
    await _prefs!.setBool(_keyHasCompletedOnboarding, user.hasCompletedOnboarding);

    // Widget settings
    await _prefs!.setString(_keyWidgetSettings, jsonEncode(user.widgetSettings.toJson()));

    // Reading history
    final historyJson = user.readingHistory.map((e) => jsonEncode(e.toJson())).toList();
    await _prefs!.setStringList(_keyReadingHistory, historyJson);
  }

  /// Load user profile from storage
  static Future<UserProfile> loadUserProfile() async {
    if (_prefs == null) await init();

    // Basic info
    final name = _prefs!.getString(_keyUserName);
    final ageRange = _prefs!.getInt(_keyAgeRange);
    final gender = _prefs!.getString(_keyGender);

    // Topics and theme
    final selectedTopics = _prefs!.getStringList(_keySelectedTopics) ?? [];
    final selectedThemeId = _prefs!.getString(_keySelectedThemeId) ?? 'autumn_forest';

    // Streak
    final streakCount = _prefs!.getInt(_keyStreakCount) ?? 0;
    final lastActiveDateStr = _prefs!.getString(_keyLastActiveDate);
    DateTime? lastActiveDate;
    if (lastActiveDateStr != null) {
      lastActiveDate = DateTime.tryParse(lastActiveDateStr);
    }

    // Favorites
    final favoriteVerseIds = _prefs!.getStringList(_keyFavoriteVerseIds) ?? [];

    // Collections
    final collectionsJson = _prefs!.getStringList(_keyCollections) ?? [];
    final collections = collectionsJson.map((json) {
      final map = jsonDecode(json) as Map<String, dynamic>;
      return Collection(
        id: map['id'] as String,
        name: map['name'] as String,
        verseIds: List<String>.from(map['verseIds'] as List),
        createdAt: DateTime.parse(map['createdAt'] as String),
      );
    }).toList();

    // Custom quotes
    final quotesJson = _prefs!.getStringList(_keyCustomQuotes) ?? [];
    final customQuotes = quotesJson.map((json) {
      final map = jsonDecode(json) as Map<String, dynamic>;
      return CustomQuote(
        id: map['id'] as String,
        text: map['text'] as String,
        source: map['source'] as String?,
        createdAt: DateTime.parse(map['createdAt'] as String),
      );
    }).toList();

    // Premium and onboarding
    final isPremium = _prefs!.getBool(_keyIsPremium) ?? false;
    final hasCompletedOnboarding = _prefs!.getBool(_keyHasCompletedOnboarding) ?? false;

    // Widget settings
    final widgetSettingsJson = _prefs!.getString(_keyWidgetSettings);
    WidgetSettings widgetSettings = const WidgetSettings();
    if (widgetSettingsJson != null) {
      try {
        widgetSettings = WidgetSettings.fromJson(jsonDecode(widgetSettingsJson) as Map<String, dynamic>);
      } catch (e) {
        // Use default if parsing fails
      }
    }

    // Reading history
    final historyJson = _prefs!.getStringList(_keyReadingHistory) ?? [];
    final readingHistory = historyJson.map((json) {
      return HistoryEntry.fromJson(jsonDecode(json) as Map<String, dynamic>);
    }).toList();

    return UserProfile(
      name: name,
      ageRange: ageRange,
      gender: gender,
      selectedTopics: selectedTopics,
      selectedThemeId: selectedThemeId,
      streakCount: streakCount,
      lastActiveDate: lastActiveDate,
      favoriteVerseIds: favoriteVerseIds,
      collections: collections,
      customQuotes: customQuotes,
      isPremium: isPremium,
      hasCompletedOnboarding: hasCompletedOnboarding,
      widgetSettings: widgetSettings,
      readingHistory: readingHistory,
    );
  }

  /// Quick save for individual fields (for real-time updates)

  static Future<void> saveFavorites(List<String> favoriteIds) async {
    if (_prefs == null) await init();
    await _prefs!.setStringList(_keyFavoriteVerseIds, favoriteIds);
  }

  static Future<void> saveTheme(String themeId) async {
    if (_prefs == null) await init();
    await _prefs!.setString(_keySelectedThemeId, themeId);
  }

  static Future<void> saveTopics(List<String> topics) async {
    if (_prefs == null) await init();
    await _prefs!.setStringList(_keySelectedTopics, topics);
  }

  static Future<void> saveStreak(int count, DateTime? lastActive) async {
    if (_prefs == null) await init();
    await _prefs!.setInt(_keyStreakCount, count);
    if (lastActive != null) {
      await _prefs!.setString(_keyLastActiveDate, lastActive.toIso8601String());
    }
  }

  static Future<void> saveOnboardingComplete(bool complete) async {
    if (_prefs == null) await init();
    await _prefs!.setBool(_keyHasCompletedOnboarding, complete);
  }

  static Future<void> saveUserBasicInfo({
    String? name,
    int? ageRange,
    String? gender,
  }) async {
    if (_prefs == null) await init();
    if (name != null) await _prefs!.setString(_keyUserName, name);
    if (ageRange != null) await _prefs!.setInt(_keyAgeRange, ageRange);
    if (gender != null) await _prefs!.setString(_keyGender, gender);
  }

  /// Save widget settings
  static Future<void> saveWidgetSettings(WidgetSettings settings) async {
    if (_prefs == null) await init();
    await _prefs!.setString(_keyWidgetSettings, jsonEncode(settings.toJson()));
  }

  /// Load widget settings
  static Future<WidgetSettings> loadWidgetSettings() async {
    if (_prefs == null) await init();
    final json = _prefs!.getString(_keyWidgetSettings);
    if (json != null) {
      try {
        return WidgetSettings.fromJson(jsonDecode(json) as Map<String, dynamic>);
      } catch (e) {
        return const WidgetSettings();
      }
    }
    return const WidgetSettings();
  }

  /// Clear all stored data (for logout/reset)
  static Future<void> clearAll() async {
    if (_prefs == null) await init();
    await _prefs!.clear();
  }
}
