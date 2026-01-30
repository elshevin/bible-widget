import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:shared_preferences/shared_preferences.dart';
import '../data/content_data.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static const String _keyReminderEnabled = 'reminder_enabled';
  static const String _keyReminderHour = 'reminder_hour';
  static const String _keyReminderMinute = 'reminder_minute';

  // Notification messages for encouragement
  static final List<String> _encouragementMessages = [
    'Take a moment to connect with God today.',
    'Your daily verse is waiting for you.',
    'Start your day with His word.',
    'A moment of peace awaits you.',
    'Let His words guide your day.',
    'Time for your spiritual moment.',
    'Grow closer to God today.',
    'Your daily inspiration is ready.',
  ];

  /// Initialize the notification service
  static Future<void> initialize() async {
    tz.initializeTimeZones();

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      settings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );
  }

  /// Handle notification tap
  static void _onNotificationTapped(NotificationResponse response) {
    // App will open automatically, no extra handling needed
  }

  /// Request notification permissions
  static Future<bool> requestPermissions() async {
    final android = _notifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    if (android != null) {
      final granted = await android.requestNotificationsPermission();
      return granted ?? false;
    }

    final ios = _notifications.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();

    if (ios != null) {
      final granted = await ios.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      return granted ?? false;
    }

    return true;
  }

  /// Schedule daily reminder notification
  static Future<void> scheduleDailyReminder({
    required int hour,
    required int minute,
  }) async {
    // Cancel existing reminders first
    await cancelAllReminders();

    // Get a random verse for the notification
    final verses = ContentData.getAllContent();
    final randomVerse = (verses..shuffle()).first;
    final verseText = randomVerse.text.length > 100
        ? '${randomVerse.text.substring(0, 97)}...'
        : randomVerse.text;

    // Get a random encouragement message
    final encouragement = (_encouragementMessages..shuffle()).first;

    // Schedule the notification
    await _notifications.zonedSchedule(
      0, // notification id
      'Bible Widgets',
      encouragement,
      _nextInstanceOfTime(hour, minute),
      NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_reminder',
          'Daily Reminders',
          channelDescription: 'Daily verse reminders to inspire your day',
          importance: Importance.high,
          priority: Priority.high,
          styleInformation: BigTextStyleInformation(
            verseText,
            contentTitle: 'Bible Widgets',
            summaryText: randomVerse.reference ?? '',
          ),
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time, // Repeat daily
    );

    // Save settings
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyReminderEnabled, true);
    await prefs.setInt(_keyReminderHour, hour);
    await prefs.setInt(_keyReminderMinute, minute);
  }

  /// Get next instance of the specified time
  static tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    return scheduledDate;
  }

  /// Cancel all scheduled reminders
  static Future<void> cancelAllReminders() async {
    await _notifications.cancelAll();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyReminderEnabled, false);
  }

  /// Check if reminders are enabled
  static Future<bool> isReminderEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyReminderEnabled) ?? false;
  }

  /// Get saved reminder time
  static Future<TimeOfDay?> getReminderTime() async {
    final prefs = await SharedPreferences.getInstance();
    final hour = prefs.getInt(_keyReminderHour);
    final minute = prefs.getInt(_keyReminderMinute);

    if (hour != null && minute != null) {
      return TimeOfDay(hour: hour, minute: minute);
    }
    return null;
  }

  /// Show a test notification immediately
  static Future<void> showTestNotification() async {
    final verses = ContentData.getAllContent();
    final randomVerse = (verses..shuffle()).first;

    await _notifications.show(
      999,
      'Bible Widgets',
      randomVerse.text.length > 100
          ? '${randomVerse.text.substring(0, 97)}...'
          : randomVerse.text,
      NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_reminder',
          'Daily Reminders',
          channelDescription: 'Daily verse reminders to inspire your day',
          importance: Importance.high,
          priority: Priority.high,
          styleInformation: BigTextStyleInformation(
            randomVerse.text,
            contentTitle: 'Bible Widgets',
            summaryText: randomVerse.reference ?? '',
          ),
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
    );
  }
}
