import '../models/models.dart';
import 'bible_verses.dart';
import 'prayers_data.dart';
import 'quotes_data.dart';
import 'affirmations_data.dart';

class ContentData {
  // Bible Verses - 1000+ verses (imported from bible_verses.dart)
  static List<Verse> get verses => BibleVerses.all;

  // Affirmations - 200 self-affirmation statements (imported from affirmations_data.dart)
  static List<Verse> get affirmations => AffirmationsData.all;

  // Inspirational Quotes - 200 quotes (imported from quotes_data.dart)
  static List<Verse> get quotes => QuotesData.all;

  // Prayers - 200 prayers (imported from prayers_data.dart)
  static List<Prayer> get prayers => PrayersData.all;

  // Topics
  static const List<Topic> topics = [
    Topic(id: 'bible-verses', name: 'Bible verses', icon: '📖', category: 'By type', isPremium: false),
    Topic(id: 'prayers', name: 'Prayers', icon: '🙏', category: 'By type', isPremium: false),
    Topic(id: 'quotes', name: 'Quotes', icon: '❝', category: 'By type', isPremium: false),
    Topic(id: 'affirmations', name: 'Affirmations', icon: '💬', category: 'By type', isPremium: false),
    Topic(id: 'faith', name: 'Faith', icon: '✝️', category: 'Draw near to God', isPremium: false),
    Topic(id: 'grace', name: 'Grace', icon: '🤲', category: 'Draw near to God', isPremium: false),
    Topic(id: 'god', name: 'God', icon: '☁️', category: 'Draw near to God', isPremium: false),
    Topic(id: 'self-worth', name: 'Self-worth', icon: '💪', category: 'Health and well-being', isPremium: false),
    Topic(id: 'letting-go', name: 'Letting go', icon: '🕊️', category: 'Health and well-being', isPremium: false),
    Topic(id: 'healing', name: 'Healing', icon: '💗', category: 'Health and well-being', isPremium: false),
    Topic(id: 'mental-health', name: 'Mental health', icon: '🧠', category: 'Health and well-being', isPremium: false),
    Topic(id: 'kindness', name: 'Kindness', icon: '🤝', category: 'Health and well-being', isPremium: false),
    Topic(id: 'inner-peace', name: 'Inner peace', icon: '💖', category: 'Health and well-being', isPremium: false),
    Topic(id: 'hope', name: 'Hope', icon: '🌅', category: 'Light for your journey', isPremium: false),
    Topic(id: 'uplifting', name: 'Uplifting', icon: '😊', category: 'Light for your journey', isPremium: false),
    Topic(id: 'love', name: 'Love', icon: '❤️', category: 'Light for your journey', isPremium: false),
    Topic(id: 'gratitude', name: 'Gratitude', icon: '✨', category: 'Light for your journey', isPremium: false),
  ];

  static List<Verse> getAllContent() {
    return [...verses, ...quotes, ...affirmations]..shuffle();
  }

  static List<Verse> getByTopic(String topicId) {
    if (topicId == 'prayers') {
      return prayers.map((p) => Verse(
        id: p.id,
        text: '${p.title}\n\n${p.content}',
        topics: ['prayers', p.topic],
      )).toList();
    }
    return [...verses, ...quotes, ...affirmations].where((v) => v.topics.contains(topicId)).toList();
  }

  static Map<String, List<Topic>> getTopicsGrouped() {
    final Map<String, List<Topic>> grouped = {};
    for (final topic in topics) {
      grouped.putIfAbsent(topic.category, () => []);
      grouped[topic.category]!.add(topic);
    }
    return grouped;
  }
}
