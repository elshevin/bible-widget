import 'package:flutter/material.dart';
import '../models/models.dart';
import '../data/content_data.dart';
import '../theme/app_theme.dart';
import '../services/widget_service.dart';

class AppState extends ChangeNotifier {
  UserProfile _user = const UserProfile();
  List<Verse> _feedContent = [];
  int _currentFeedIndex = 0;
  VisualTheme _currentTheme = VisualThemes.all.first;
  
  // Getters
  UserProfile get user => _user;
  List<Verse> get feedContent => _feedContent;
  int get currentFeedIndex => _currentFeedIndex;
  VisualTheme get currentTheme => _currentTheme;
  bool get hasCompletedOnboarding => _user.hasCompletedOnboarding;
  
  // Initialize
  void initialize() {
    _feedContent = ContentData.getAllContent();
    _updateStreak();
  }
  
  // Update user profile
  void updateUser(UserProfile newUser) {
    _user = newUser;
    notifyListeners();
  }
  
  // Update name
  void setUserName(String name) {
    _user = _user.copyWith(name: name);
    notifyListeners();
  }
  
  // Update age range
  void setAgeRange(int index) {
    _user = _user.copyWith(ageRange: index);
    notifyListeners();
  }
  
  // Update gender
  void setGender(String gender) {
    _user = _user.copyWith(gender: gender);
    notifyListeners();
  }
  
  // Update selected topics
  void setSelectedTopics(List<String> topics) {
    _user = _user.copyWith(selectedTopics: topics);
    _refreshFeed();
    notifyListeners();
  }
  
  void toggleTopic(String topicId) {
    final topics = List<String>.from(_user.selectedTopics);
    if (topics.contains(topicId)) {
      topics.remove(topicId);
    } else {
      topics.add(topicId);
    }
    _user = _user.copyWith(selectedTopics: topics);
    notifyListeners();
  }
  
  // Update theme
  void setTheme(String themeId) {
    _currentTheme = VisualThemes.getById(themeId);
    _user = _user.copyWith(selectedThemeId: themeId);
    // Update widget with new theme colors
    WidgetService.updateWidgetTheme(themeId);
    notifyListeners();
  }
  
  // Complete onboarding
  void completeOnboarding() {
    _user = _user.copyWith(hasCompletedOnboarding: true);
    _refreshFeed();
    notifyListeners();
  }
  
  // Feed navigation
  void setFeedIndex(int index) {
    _currentFeedIndex = index;
    notifyListeners();
  }
  
  void nextVerse() {
    if (_currentFeedIndex < _feedContent.length - 1) {
      _currentFeedIndex++;
      notifyListeners();
    }
  }
  
  void previousVerse() {
    if (_currentFeedIndex > 0) {
      _currentFeedIndex--;
      notifyListeners();
    }
  }
  
  // Favorites
  bool isFavorite(String verseId) {
    return _user.favoriteVerseIds.contains(verseId);
  }
  
  /// Toggle favorite status for a verse
  /// Returns true if user just reached the daily limit of 5 favorites
  bool toggleFavorite(String verseId) {
    final favorites = List<String>.from(_user.favoriteVerseIds);
    final wasInList = favorites.contains(verseId);

    if (wasInList) {
      favorites.remove(verseId);
    } else {
      favorites.add(verseId);
    }
    _user = _user.copyWith(favoriteVerseIds: favorites);
    notifyListeners();

    // Return true if user just reached 5 favorites (daily goal)
    return !wasInList && favorites.length == 5;
  }
  
  List<Verse> getFavoriteVerses() {
    return _feedContent
        .where((v) => _user.favoriteVerseIds.contains(v.id))
        .toList();
  }
  
  int get favoritesCount => _user.favoriteVerseIds.length;
  
  // Streak
  void _updateStreak() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    if (_user.lastActiveDate == null) {
      _user = _user.copyWith(
        streakCount: 1,
        lastActiveDate: today,
      );
    } else {
      final lastActive = DateTime(
        _user.lastActiveDate!.year,
        _user.lastActiveDate!.month,
        _user.lastActiveDate!.day,
      );
      
      final difference = today.difference(lastActive).inDays;
      
      if (difference == 0) {
        // Same day, no change
      } else if (difference == 1) {
        // Consecutive day
        _user = _user.copyWith(
          streakCount: _user.streakCount + 1,
          lastActiveDate: today,
        );
      } else {
        // Streak broken
        _user = _user.copyWith(
          streakCount: 1,
          lastActiveDate: today,
        );
      }
    }
  }
  
  // Refresh feed based on selected topics
  void _refreshFeed() {
    if (_user.selectedTopics.isEmpty) {
      _feedContent = ContentData.getAllContent();
    } else {
      final Set<Verse> filtered = {};
      for (final topic in _user.selectedTopics) {
        filtered.addAll(ContentData.getByTopic(topic));
      }
      _feedContent = filtered.toList()..shuffle();
      
      // Add some general content if not enough
      if (_feedContent.length < 10) {
        final additional = ContentData.getAllContent()
            .where((v) => !filtered.contains(v))
            .take(10 - _feedContent.length);
        _feedContent.addAll(additional);
      }
    }
    _currentFeedIndex = 0;
  }
  
  // Collections
  void createCollection(String name) {
    final collection = Collection(
      id: 'col_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      verseIds: [],
      createdAt: DateTime.now(),
    );
    final collections = List<Collection>.from(_user.collections)..add(collection);
    _user = _user.copyWith(collections: collections);
    notifyListeners();
  }
  
  void addToCollection(String collectionId, String verseId) {
    final collections = _user.collections.map((c) {
      if (c.id == collectionId) {
        final verseIds = List<String>.from(c.verseIds);
        if (!verseIds.contains(verseId)) {
          verseIds.add(verseId);
        }
        return Collection(
          id: c.id,
          name: c.name,
          verseIds: verseIds,
          createdAt: c.createdAt,
        );
      }
      return c;
    }).toList();
    _user = _user.copyWith(collections: collections);
    notifyListeners();
  }
  
  // Premium
  void setPremium(bool value) {
    _user = _user.copyWith(isPremium: value);
    notifyListeners();
  }

  // Custom Quotes
  List<CustomQuote> get customQuotes => _user.customQuotes;

  void addCustomQuote(String text, String? source) {
    final quote = CustomQuote(
      id: 'quote_${DateTime.now().millisecondsSinceEpoch}',
      text: text,
      source: source,
      createdAt: DateTime.now(),
    );
    final quotes = List<CustomQuote>.from(_user.customQuotes)..add(quote);
    _user = _user.copyWith(customQuotes: quotes);
    notifyListeners();
  }

  void removeCustomQuote(String id) {
    final quotes = _user.customQuotes.where((q) => q.id != id).toList();
    _user = _user.copyWith(customQuotes: quotes);
    notifyListeners();
  }

  // Collections getters
  List<Collection> get collections => _user.collections;

  bool isInAnyCollection(String verseId) {
    return _user.collections.any((c) => c.verseIds.contains(verseId));
  }

  void removeFromCollection(String collectionId, String verseId) {
    final collections = _user.collections.map((c) {
      if (c.id == collectionId) {
        final verseIds = List<String>.from(c.verseIds)..remove(verseId);
        return Collection(
          id: c.id,
          name: c.name,
          verseIds: verseIds,
          createdAt: c.createdAt,
        );
      }
      return c;
    }).toList();
    _user = _user.copyWith(collections: collections);
    notifyListeners();
  }

  void deleteCollection(String collectionId) {
    final collections = _user.collections.where((c) => c.id != collectionId).toList();
    _user = _user.copyWith(collections: collections);
    notifyListeners();
  }

  Verse? getVerseById(String id) {
    try {
      return _feedContent.firstWhere((v) => v.id == id);
    } catch (e) {
      return null;
    }
  }
  
  // Get current verse
  Verse? get currentVerse {
    if (_feedContent.isEmpty) return null;
    if (_currentFeedIndex >= _feedContent.length) return _feedContent.first;
    return _feedContent[_currentFeedIndex];
  }
  
  // Get display text with personalization
  String getDisplayText(Verse verse) {
    return verse.getDisplayText(_user.name);
  }
}
