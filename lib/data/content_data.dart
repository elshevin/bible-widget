import '../models/models.dart';

class ContentData {
  // Bible Verses
  static const List<Verse> verses = [
    // Hope
    Verse(
      id: 'v1',
      text: 'For I know the plans I have for you, declares the Lord, plans to prosper you and not to harm you, plans to give you hope and a future.',
      reference: 'Jeremiah 29:11',
      book: 'Jeremiah',
      chapter: 29,
      verseNumber: 11,
      topics: ['hope', 'faith', 'god'],
    ),
    Verse(
      id: 'v2',
      text: 'But those who hope in the Lord will renew their strength. They will soar on wings like eagles; they will run and not grow weary, they will walk and not be faint.',
      reference: 'Isaiah 40:31',
      book: 'Isaiah',
      chapter: 40,
      verseNumber: 31,
      topics: ['hope', 'strength', 'faith'],
    ),
    Verse(
      id: 'v3',
      text: 'May the God of hope fill you with all joy and peace as you trust in him, so that you may overflow with hope by the power of the Holy Spirit.',
      reference: 'Romans 15:13',
      book: 'Romans',
      chapter: 15,
      verseNumber: 13,
      topics: ['hope', 'joy', 'peace'],
    ),
    
    // Peace
    Verse(
      id: 'v4',
      text: 'Peace I leave with you; my peace I give you. I do not give to you as the world gives. Do not let your hearts be troubled and do not be afraid.',
      reference: 'John 14:27',
      book: 'John',
      chapter: 14,
      verseNumber: 27,
      topics: ['peace', 'faith'],
    ),
    Verse(
      id: 'v5',
      text: 'The Lord gives strength to his people; the Lord blesses his people with peace.',
      reference: 'Psalm 29:11',
      book: 'Psalms',
      chapter: 29,
      verseNumber: 11,
      topics: ['peace', 'strength'],
    ),
    Verse(
      id: 'v6',
      text: 'And the peace of God, which transcends all understanding, will guard your hearts and your minds in Christ Jesus.',
      reference: 'Philippians 4:7',
      book: 'Philippians',
      chapter: 4,
      verseNumber: 7,
      topics: ['peace', 'faith'],
    ),
    
    // Faith
    Verse(
      id: 'v7',
      text: 'Now faith is confidence in what we hope for and assurance about what we do not see.',
      reference: 'Hebrews 11:1',
      book: 'Hebrews',
      chapter: 11,
      verseNumber: 1,
      topics: ['faith', 'hope'],
    ),
    Verse(
      id: 'v8',
      text: 'Trust in the Lord with all your heart and lean not on your own understanding; in all your ways submit to him, and he will make your paths straight.',
      reference: 'Proverbs 3:5-6',
      book: 'Proverbs',
      chapter: 3,
      verseNumber: 5,
      topics: ['faith', 'trust', 'god'],
    ),
    Verse(
      id: 'v9',
      text: 'I can do all this through him who gives me strength.',
      reference: 'Philippians 4:13',
      book: 'Philippians',
      chapter: 4,
      verseNumber: 13,
      topics: ['faith', 'strength'],
    ),
    
    // Love
    Verse(
      id: 'v10',
      text: 'For God so loved the world that he gave his one and only Son, that whoever believes in him shall not perish but have eternal life.',
      reference: 'John 3:16',
      book: 'John',
      chapter: 3,
      verseNumber: 16,
      topics: ['love', 'faith', 'god'],
    ),
    Verse(
      id: 'v11',
      text: 'Love is patient, love is kind. It does not envy, it does not boast, it is not proud.',
      reference: '1 Corinthians 13:4',
      book: '1 Corinthians',
      chapter: 13,
      verseNumber: 4,
      topics: ['love', 'kindness'],
    ),
    Verse(
      id: 'v12',
      text: 'Above all, love each other deeply, because love covers over a multitude of sins.',
      reference: '1 Peter 4:8',
      book: '1 Peter',
      chapter: 4,
      verseNumber: 8,
      topics: ['love', 'grace'],
    ),
    
    // Healing
    Verse(
      id: 'v13',
      text: 'He heals the brokenhearted and binds up their wounds.',
      reference: 'Psalm 147:3',
      book: 'Psalms',
      chapter: 147,
      verseNumber: 3,
      topics: ['healing', 'comfort'],
    ),
    Verse(
      id: 'v14',
      text: 'Come to me, all you who are weary and burdened, and I will give you rest.',
      reference: 'Matthew 11:28',
      book: 'Matthew',
      chapter: 11,
      verseNumber: 28,
      topics: ['healing', 'rest', 'comfort'],
    ),
    
    // Strength
    Verse(
      id: 'v15',
      text: 'The Lord is my strength and my shield; my heart trusts in him, and he helps me.',
      reference: 'Psalm 28:7',
      book: 'Psalms',
      chapter: 28,
      verseNumber: 7,
      topics: ['strength', 'trust', 'faith'],
    ),
    Verse(
      id: 'v16',
      text: 'Be strong and courageous. Do not be afraid; do not be discouraged, for the Lord your God will be with you wherever you go.',
      reference: 'Joshua 1:9',
      book: 'Joshua',
      chapter: 1,
      verseNumber: 9,
      topics: ['strength', 'courage', 'faith'],
    ),
    
    // Gratitude
    Verse(
      id: 'v17',
      text: 'Give thanks in all circumstances; for this is God\'s will for you in Christ Jesus.',
      reference: '1 Thessalonians 5:18',
      book: '1 Thessalonians',
      chapter: 5,
      verseNumber: 18,
      topics: ['gratitude', 'faith'],
    ),
    Verse(
      id: 'v18',
      text: 'Enter his gates with thanksgiving and his courts with praise; give thanks to him and praise his name.',
      reference: 'Psalm 100:4',
      book: 'Psalms',
      chapter: 100,
      verseNumber: 4,
      topics: ['gratitude', 'praise'],
    ),
    
    // Inner Peace
    Verse(
      id: 'v19',
      text: 'Be still, and know that I am God.',
      reference: 'Psalm 46:10',
      book: 'Psalms',
      chapter: 46,
      verseNumber: 10,
      topics: ['peace', 'faith', 'god'],
    ),
    Verse(
      id: 'v20',
      text: 'Cast all your anxiety on him because he cares for you.',
      reference: '1 Peter 5:7',
      book: '1 Peter',
      chapter: 5,
      verseNumber: 7,
      topics: ['peace', 'anxiety', 'comfort'],
    ),
    
    // More verses
    Verse(
      id: 'v21',
      text: 'The Lord is my shepherd, I lack nothing.',
      reference: 'Psalm 23:1',
      book: 'Psalms',
      chapter: 23,
      verseNumber: 1,
      topics: ['faith', 'god', 'peace'],
    ),
    Verse(
      id: 'v22',
      text: 'Delight yourself in the Lord, and he will give you the desires of your heart.',
      reference: 'Psalm 37:4',
      book: 'Psalms',
      chapter: 37,
      verseNumber: 4,
      topics: ['faith', 'hope', 'god'],
    ),
    Verse(
      id: 'v23',
      text: 'Do not be anxious about anything, but in every situation, by prayer and petition, with thanksgiving, present your requests to God.',
      reference: 'Philippians 4:6',
      book: 'Philippians',
      chapter: 4,
      verseNumber: 6,
      topics: ['peace', 'prayer', 'anxiety'],
    ),
    Verse(
      id: 'v24',
      text: 'The Lord is close to the brokenhearted and saves those who are crushed in spirit.',
      reference: 'Psalm 34:18',
      book: 'Psalms',
      chapter: 34,
      verseNumber: 18,
      topics: ['comfort', 'healing', 'god'],
    ),
    Verse(
      id: 'v25',
      text: 'And we know that in all things God works for the good of those who love him, who have been called according to his purpose.',
      reference: 'Romans 8:28',
      book: 'Romans',
      chapter: 8,
      verseNumber: 28,
      topics: ['faith', 'hope', 'god'],
    ),
  ];

  // Inspirational Quotes (personalized with {name})
  static const List<Verse> quotes = [
    Verse(
      id: 'q1',
      text: 'You\'re stronger than you know, {name}, because God walks with you.',
      topics: ['uplifting', 'strength'],
      isPersonalized: true,
    ),
    Verse(
      id: 'q2',
      text: 'Everything you\'ve experienced is leading you to the path God created for you, {name}.',
      topics: ['hope', 'faith'],
      isPersonalized: true,
    ),
    Verse(
      id: 'q3',
      text: 'Very soon you will smile and say, "God, this is more than I prayed for."',
      topics: ['hope', 'gratitude'],
    ),
    Verse(
      id: 'q4',
      text: 'When God wakes you up at 3 a.m., pray. Before you make any big decisions, pray. Before you reach for your phone in the morning, pray. Start with Him. He\'s all you need.',
      topics: ['prayer', 'faith'],
    ),
    Verse(
      id: 'q5',
      text: 'Let go and let God.',
      topics: ['letting-go', 'faith'],
    ),
    Verse(
      id: 'q6',
      text: 'Today, I protect the peace that God has planted in me.',
      topics: ['peace', 'affirmations'],
    ),
    Verse(
      id: 'q7',
      text: 'I am grateful for all my prayers being answered.',
      topics: ['gratitude', 'prayer', 'affirmations'],
    ),
    Verse(
      id: 'q8',
      text: '{name}, God\'s timing is perfect. Trust the wait.',
      topics: ['faith', 'hope'],
      isPersonalized: true,
    ),
    Verse(
      id: 'q9',
      text: 'Your current situation is not your final destination. God has more in store for you.',
      topics: ['hope', 'faith'],
    ),
    Verse(
      id: 'q10',
      text: 'Don\'t worry about tomorrow. God is already there.',
      topics: ['faith', 'peace'],
    ),
    Verse(
      id: 'q11',
      text: 'God didn\'t bring you this far to leave you, {name}.',
      topics: ['faith', 'hope'],
      isPersonalized: true,
    ),
    Verse(
      id: 'q12',
      text: 'When you can\'t control what\'s happening, challenge yourself to control the way you respond. That\'s where your power is.',
      topics: ['mental-health', 'strength'],
    ),
    Verse(
      id: 'q13',
      text: 'Be patient with yourself. Healing takes time.',
      topics: ['healing', 'self-worth'],
    ),
    Verse(
      id: 'q14',
      text: 'You are worthy of love, belonging, and joy.',
      topics: ['self-worth', 'love'],
    ),
    Verse(
      id: 'q15',
      text: 'Today I choose faith over fear.',
      topics: ['faith', 'affirmations'],
    ),
  ];

  // Topics
  static const List<Topic> topics = [
    // By Type - all free
    Topic(id: 'bible-verses', name: 'Bible verses', icon: '📖', category: 'By type', isPremium: false),
    Topic(id: 'prayers', name: 'Prayers', icon: '🙏', category: 'By type', isPremium: false),
    Topic(id: 'quotes', name: 'Quotes', icon: '❝', category: 'By type', isPremium: false),
    Topic(id: 'affirmations', name: 'Affirmations', icon: '💬', category: 'By type', isPremium: false),

    // Draw near to God - common ones free
    Topic(id: 'faith', name: 'Faith', icon: '✝️', category: 'Draw near to God', isPremium: false),
    Topic(id: 'grace', name: 'Grace', icon: '🤲', category: 'Draw near to God', isPremium: false),
    Topic(id: 'god', name: 'God', icon: '☁️', category: 'Draw near to God', isPremium: false),

    // Health and well-being - mix of free and premium
    Topic(id: 'self-worth', name: 'Self-worth', icon: '💪', category: 'Health and well-being', isPremium: false),
    Topic(id: 'letting-go', name: 'Letting go', icon: '🕊️', category: 'Health and well-being', isPremium: false),
    Topic(id: 'healing', name: 'Healing', icon: '💗', category: 'Health and well-being', isPremium: false),
    Topic(id: 'mental-health', name: 'Mental health', icon: '🧠', category: 'Health and well-being'),
    Topic(id: 'kindness', name: 'Kindness', icon: '🤝', category: 'Health and well-being'),
    Topic(id: 'inner-peace', name: 'Inner peace', icon: '💖', category: 'Health and well-being', isPremium: false),

    // Light for your journey - common ones free
    Topic(id: 'hope', name: 'Hope', icon: '🌅', category: 'Light for your journey', isPremium: false),
    Topic(id: 'uplifting', name: 'Uplifting', icon: '😊', category: 'Light for your journey', isPremium: false),
    Topic(id: 'love', name: 'Love', icon: '❤️', category: 'Light for your journey', isPremium: false),
    Topic(id: 'gratitude', name: 'Gratitude', icon: '✨', category: 'Light for your journey', isPremium: false),
  ];

  // Prayers
  static const List<Prayer> prayers = [
    Prayer(
      id: 'p1',
      title: 'Morning Prayer',
      content: 'Lord, thank You for this new day. Guide my steps and fill my heart with Your peace. Help me to be a light to others and to trust in Your plan. Amen.',
      topic: 'faith',
    ),
    Prayer(
      id: 'p2',
      title: 'Prayer for Peace',
      content: 'Heavenly Father, calm my anxious heart. Replace my worries with Your perfect peace. Help me to rest in the knowledge that You are in control. Amen.',
      topic: 'peace',
    ),
    Prayer(
      id: 'p3',
      title: 'Prayer for Strength',
      content: 'Lord, I feel weak today. Pour Your strength into me. Remind me that I can do all things through Christ who strengthens me. Amen.',
      topic: 'strength',
    ),
    Prayer(
      id: 'p4',
      title: 'Prayer for Healing',
      content: 'Father, You are the great healer. Touch my body, mind, and spirit with Your healing power. I trust in Your restoration. Amen.',
      topic: 'healing',
    ),
    Prayer(
      id: 'p5',
      title: 'Gratitude Prayer',
      content: 'Thank You, Lord, for all Your blessings. Help me to see Your goodness in every moment. I am grateful for Your endless love. Amen.',
      topic: 'gratitude',
    ),
    Prayer(
      id: 'p6',
      title: 'Prayer for {name}',
      content: 'Lord, I lift up {name} to You today. Guide their path, protect their heart, and fill them with Your joy. Let them feel Your presence always. Amen.',
      topic: 'faith',
      isPersonalized: true,
    ),
    Prayer(
      id: 'p7',
      title: 'Evening Prayer',
      content: 'Lord, as this day ends, I thank You for Your faithfulness. Forgive my shortcomings and give me restful sleep. Watch over me through the night. Amen.',
      topic: 'faith',
    ),
    Prayer(
      id: 'p8',
      title: 'Prayer for Guidance',
      content: 'Father, I need Your wisdom. Show me the path I should take. Help me to hear Your voice above all others. Lead me in Your truth. Amen.',
      topic: 'faith',
    ),
  ];

  // Get all content (verses + quotes) for feed
  static List<Verse> getAllContent() {
    return [...verses, ...quotes]..shuffle();
  }

  // Get verses by topic
  static List<Verse> getByTopic(String topicId) {
    return [...verses, ...quotes]
        .where((v) => v.topics.contains(topicId))
        .toList();
  }

  // Get topics grouped by category
  static Map<String, List<Topic>> getTopicsGrouped() {
    final Map<String, List<Topic>> grouped = {};
    for (final topic in topics) {
      grouped.putIfAbsent(topic.category, () => []);
      grouped[topic.category]!.add(topic);
    }
    return grouped;
  }
}
