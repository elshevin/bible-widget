import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';

/// Centralized analytics service wrapping Firebase Analytics.
/// All event tracking goes through this class for consistency.
class AnalyticsService {
  static final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  /// Get the analytics observer for MaterialApp navigator
  static FirebaseAnalyticsObserver get observer =>
      FirebaseAnalyticsObserver(analytics: _analytics);

  // ── Screen Views ──────────────────────────────────────────

  static Future<void> logScreenView(String screenName) async {
    try {
      await _analytics.logScreenView(screenName: screenName);
      if (kDebugMode) print('Analytics: screen_view → $screenName');
    } catch (e) {
      if (kDebugMode) print('Analytics error: $e');
    }
  }

  // ── User Actions ──────────────────────────────────────────

  static Future<void> logFavoriteToggle(String verseId, bool isFavorite, {required String source}) async {
    try {
      await _analytics.logEvent(
        name: 'favorite_toggle',
        parameters: {
          'verse_id': verseId,
          'action': isFavorite ? 'add' : 'remove',
          'source': source,
        },
      );
      if (kDebugMode) print('Analytics: favorite_toggle → $verseId ($isFavorite) from $source');
    } catch (e) {
      if (kDebugMode) print('Analytics error: $e');
    }
  }

  static Future<void> logShare(String verseId, String method, {required String source}) async {
    try {
      await _analytics.logEvent(
        name: 'share',
        parameters: {
          'verse_id': verseId,
          'method': method,
          'source': source,
        },
      );
      if (kDebugMode) print('Analytics: share → $verseId via $method from $source');
    } catch (e) {
      if (kDebugMode) print('Analytics error: $e');
    }
  }

  static Future<void> logThemeChange(String themeId) async {
    try {
      await _analytics.logEvent(
        name: 'theme_change',
        parameters: {'theme_id': themeId},
      );
      if (kDebugMode) print('Analytics: theme_change → $themeId');
    } catch (e) {
      if (kDebugMode) print('Analytics error: $e');
    }
  }

  static Future<void> logSearch(String query, int resultCount) async {
    try {
      await _analytics.logEvent(
        name: 'search',
        parameters: {
          'search_term': query,
          'result_count': resultCount,
        },
      );
      if (kDebugMode) print('Analytics: search → "$query" ($resultCount results)');
    } catch (e) {
      if (kDebugMode) print('Analytics error: $e');
    }
  }

  static Future<void> logTopicFollow(String topicId, bool isFollowing) async {
    try {
      await _analytics.logEvent(
        name: 'topic_follow',
        parameters: {
          'topic_id': topicId,
          'action': isFollowing ? 'follow' : 'unfollow',
        },
      );
      if (kDebugMode) print('Analytics: topic_follow → $topicId ($isFollowing)');
    } catch (e) {
      if (kDebugMode) print('Analytics error: $e');
    }
  }

  static Future<void> logWidgetSettingChange(String setting, String value) async {
    try {
      await _analytics.logEvent(
        name: 'widget_setting_change',
        parameters: {
          'setting': setting,
          'value': value,
        },
      );
      if (kDebugMode) print('Analytics: widget_setting → $setting = $value');
    } catch (e) {
      if (kDebugMode) print('Analytics error: $e');
    }
  }

  static Future<void> logBookmarkAdd(String verseId, String collectionId, {required String source}) async {
    try {
      await _analytics.logEvent(
        name: 'bookmark_add',
        parameters: {
          'verse_id': verseId,
          'collection_id': collectionId,
          'source': source,
        },
      );
      if (kDebugMode) print('Analytics: bookmark_add → $verseId to $collectionId from $source');
    } catch (e) {
      if (kDebugMode) print('Analytics error: $e');
    }
  }

  static Future<void> logOnboardingComplete() async {
    try {
      await _analytics.logEvent(name: 'onboarding_complete');
      if (kDebugMode) print('Analytics: onboarding_complete');
    } catch (e) {
      if (kDebugMode) print('Analytics error: $e');
    }
  }

  static Future<void> logAppOpen() async {
    try {
      await _analytics.logAppOpen();
      if (kDebugMode) print('Analytics: app_open');
    } catch (e) {
      if (kDebugMode) print('Analytics error: $e');
    }
  }

  // ── New Events ──────────────────────────────────────────

  static Future<void> logOnboardingShow() async {
    try {
      await _analytics.logEvent(name: 'onboarding_show');
      if (kDebugMode) print('Analytics: onboarding_show');
    } catch (e) {
      if (kDebugMode) print('Analytics error: $e');
    }
  }

  static Future<void> logVerseSwiped(String verseId, String direction) async {
    try {
      await _analytics.logEvent(
        name: 'verse_swiped',
        parameters: {
          'verse_id': verseId,
          'direction': direction,
        },
      );
      if (kDebugMode) print('Analytics: verse_swiped → $verseId ($direction)');
    } catch (e) {
      if (kDebugMode) print('Analytics error: $e');
    }
  }

  static Future<void> logButtonTap(String buttonName) async {
    try {
      await _analytics.logEvent(
        name: 'button_tap',
        parameters: {'button_name': buttonName},
      );
      if (kDebugMode) print('Analytics: button_tap → $buttonName');
    } catch (e) {
      if (kDebugMode) print('Analytics error: $e');
    }
  }

  // ── Widget Events ──────────────────────────────────────────

  /// Log when app is opened from widget click (cold or warm start)
  static Future<void> logWidgetClick({required String launchType}) async {
    try {
      await _analytics.logEvent(
        name: 'widget_click',
        parameters: {'launch_type': launchType},
      );
      if (kDebugMode) print('Analytics: widget_click → $launchType');
    } catch (e) {
      if (kDebugMode) print('Analytics error: $e');
    }
  }

  /// Log when we detect that the user has enabled the home screen widget
  /// (first time the iOS widget writes to shared UserDefaults)
  static Future<void> logWidgetEnabled() async {
    try {
      await _analytics.logEvent(name: 'widget_enabled');
      if (kDebugMode) print('Analytics: widget_enabled');
    } catch (e) {
      if (kDebugMode) print('Analytics error: $e');
    }
  }
}
