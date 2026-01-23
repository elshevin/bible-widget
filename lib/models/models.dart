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
  final bool isPremium;
  final bool hasCompletedOnboarding;

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
    this.isPremium = false,
    this.hasCompletedOnboarding = false,
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
    bool? isPremium,
    bool? hasCompletedOnboarding,
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
      isPremium: isPremium ?? this.isPremium,
      hasCompletedOnboarding: hasCompletedOnboarding ?? this.hasCompletedOnboarding,
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
