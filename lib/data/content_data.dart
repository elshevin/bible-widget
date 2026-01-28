import '../models/models.dart';

class ContentData {
  // Bible Verses - 50+ verses
  static const List<Verse> verses = [
    // Hope
    Verse(id: 'v1', text: 'For I know the plans I have for you, declares the Lord, plans to prosper you and not to harm you, plans to give you hope and a future.', reference: 'Jeremiah 29:11', book: 'Jeremiah', chapter: 29, verseNumber: 11, topics: ['hope', 'faith', 'god', 'bible-verses']),
    Verse(id: 'v2', text: 'But those who hope in the Lord will renew their strength. They will soar on wings like eagles; they will run and not grow weary, they will walk and not be faint.', reference: 'Isaiah 40:31', book: 'Isaiah', chapter: 40, verseNumber: 31, topics: ['hope', 'strength', 'faith', 'bible-verses']),
    Verse(id: 'v3', text: 'May the God of hope fill you with all joy and peace as you trust in him, so that you may overflow with hope by the power of the Holy Spirit.', reference: 'Romans 15:13', book: 'Romans', chapter: 15, verseNumber: 13, topics: ['hope', 'joy', 'peace', 'bible-verses']),
    Verse(id: 'v4', text: 'Be joyful in hope, patient in affliction, faithful in prayer.', reference: 'Romans 12:12', book: 'Romans', chapter: 12, verseNumber: 12, topics: ['hope', 'faith', 'prayer', 'bible-verses']),
    Verse(id: 'v5', text: 'Now faith is confidence in what we hope for and assurance about what we do not see.', reference: 'Hebrews 11:1', book: 'Hebrews', chapter: 11, verseNumber: 1, topics: ['hope', 'faith', 'bible-verses']),

    // Peace
    Verse(id: 'v6', text: 'Peace I leave with you; my peace I give you. I do not give to you as the world gives. Do not let your hearts be troubled and do not be afraid.', reference: 'John 14:27', book: 'John', chapter: 14, verseNumber: 27, topics: ['peace', 'faith', 'inner-peace', 'bible-verses']),
    Verse(id: 'v7', text: 'The Lord gives strength to his people; the Lord blesses his people with peace.', reference: 'Psalm 29:11', book: 'Psalms', chapter: 29, verseNumber: 11, topics: ['peace', 'strength', 'inner-peace', 'bible-verses']),
    Verse(id: 'v8', text: 'And the peace of God, which transcends all understanding, will guard your hearts and your minds in Christ Jesus.', reference: 'Philippians 4:7', book: 'Philippians', chapter: 4, verseNumber: 7, topics: ['peace', 'faith', 'inner-peace', 'bible-verses']),
    Verse(id: 'v9', text: 'Be still, and know that I am God.', reference: 'Psalm 46:10', book: 'Psalms', chapter: 46, verseNumber: 10, topics: ['peace', 'faith', 'god', 'inner-peace', 'bible-verses']),
    Verse(id: 'v10', text: 'You will keep in perfect peace those whose minds are steadfast, because they trust in you.', reference: 'Isaiah 26:3', book: 'Isaiah', chapter: 26, verseNumber: 3, topics: ['peace', 'faith', 'inner-peace', 'mental-health', 'bible-verses']),

    // Faith
    Verse(id: 'v11', text: 'Trust in the Lord with all your heart and lean not on your own understanding; in all your ways submit to him, and he will make your paths straight.', reference: 'Proverbs 3:5-6', book: 'Proverbs', chapter: 3, verseNumber: 5, topics: ['faith', 'trust', 'god', 'bible-verses']),
    Verse(id: 'v12', text: 'I can do all this through him who gives me strength.', reference: 'Philippians 4:13', book: 'Philippians', chapter: 4, verseNumber: 13, topics: ['faith', 'strength', 'bible-verses']),
    Verse(id: 'v13', text: 'The Lord is my shepherd, I lack nothing.', reference: 'Psalm 23:1', book: 'Psalms', chapter: 23, verseNumber: 1, topics: ['faith', 'god', 'peace', 'bible-verses']),
    Verse(id: 'v14', text: 'Delight yourself in the Lord, and he will give you the desires of your heart.', reference: 'Psalm 37:4', book: 'Psalms', chapter: 37, verseNumber: 4, topics: ['faith', 'hope', 'god', 'bible-verses']),
    Verse(id: 'v15', text: 'And we know that in all things God works for the good of those who love him, who have been called according to his purpose.', reference: 'Romans 8:28', book: 'Romans', chapter: 8, verseNumber: 28, topics: ['faith', 'hope', 'god', 'bible-verses']),
    Verse(id: 'v16', text: 'For we walk by faith, not by sight.', reference: '2 Corinthians 5:7', book: '2 Corinthians', chapter: 5, verseNumber: 7, topics: ['faith', 'bible-verses']),
    Verse(id: 'v17', text: 'So do not fear, for I am with you; do not be dismayed, for I am your God.', reference: 'Isaiah 41:10', book: 'Isaiah', chapter: 41, verseNumber: 10, topics: ['faith', 'god', 'strength', 'bible-verses']),

    // Love
    Verse(id: 'v18', text: 'For God so loved the world that he gave his one and only Son, that whoever believes in him shall not perish but have eternal life.', reference: 'John 3:16', book: 'John', chapter: 3, verseNumber: 16, topics: ['love', 'faith', 'god', 'bible-verses']),
    Verse(id: 'v19', text: 'Love is patient, love is kind. It does not envy, it does not boast, it is not proud.', reference: '1 Corinthians 13:4', book: '1 Corinthians', chapter: 13, verseNumber: 4, topics: ['love', 'kindness', 'bible-verses']),
    Verse(id: 'v20', text: 'Above all, love each other deeply, because love covers over a multitude of sins.', reference: '1 Peter 4:8', book: '1 Peter', chapter: 4, verseNumber: 8, topics: ['love', 'grace', 'kindness', 'bible-verses']),
    Verse(id: 'v21', text: 'A new command I give you: Love one another. As I have loved you, so you must love one another.', reference: 'John 13:34', book: 'John', chapter: 13, verseNumber: 34, topics: ['love', 'kindness', 'bible-verses']),
    Verse(id: 'v22', text: 'And now these three remain: faith, hope and love. But the greatest of these is love.', reference: '1 Corinthians 13:13', book: '1 Corinthians', chapter: 13, verseNumber: 13, topics: ['love', 'faith', 'hope', 'bible-verses']),

    // Grace
    Verse(id: 'v23', text: 'For it is by grace you have been saved, through faith—and this is not from yourselves, it is the gift of God.', reference: 'Ephesians 2:8', book: 'Ephesians', chapter: 2, verseNumber: 8, topics: ['grace', 'faith', 'god', 'bible-verses']),
    Verse(id: 'v24', text: 'But he said to me, "My grace is sufficient for you, for my power is made perfect in weakness."', reference: '2 Corinthians 12:9', book: '2 Corinthians', chapter: 12, verseNumber: 9, topics: ['grace', 'strength', 'faith', 'bible-verses']),
    Verse(id: 'v25', text: 'The Lord is compassionate and gracious, slow to anger, abounding in love.', reference: 'Psalm 103:8', book: 'Psalms', chapter: 103, verseNumber: 8, topics: ['grace', 'love', 'god', 'bible-verses']),
    Verse(id: 'v26', text: 'Let us then approach God\'s throne of grace with confidence, so that we may receive mercy and find grace to help us in our time of need.', reference: 'Hebrews 4:16', book: 'Hebrews', chapter: 4, verseNumber: 16, topics: ['grace', 'faith', 'god', 'bible-verses']),

    // Strength
    Verse(id: 'v27', text: 'The Lord is my strength and my shield; my heart trusts in him, and he helps me.', reference: 'Psalm 28:7', book: 'Psalms', chapter: 28, verseNumber: 7, topics: ['strength', 'trust', 'faith', 'bible-verses']),
    Verse(id: 'v28', text: 'Be strong and courageous. Do not be afraid; do not be discouraged, for the Lord your God will be with you wherever you go.', reference: 'Joshua 1:9', book: 'Joshua', chapter: 1, verseNumber: 9, topics: ['strength', 'courage', 'faith', 'bible-verses']),
    Verse(id: 'v29', text: 'God is our refuge and strength, an ever-present help in trouble.', reference: 'Psalm 46:1', book: 'Psalms', chapter: 46, verseNumber: 1, topics: ['strength', 'faith', 'god', 'bible-verses']),
    Verse(id: 'v30', text: 'The Lord is my light and my salvation—whom shall I fear? The Lord is the stronghold of my life—of whom shall I be afraid?', reference: 'Psalm 27:1', book: 'Psalms', chapter: 27, verseNumber: 1, topics: ['strength', 'faith', 'god', 'bible-verses']),

    // Healing
    Verse(id: 'v31', text: 'He heals the brokenhearted and binds up their wounds.', reference: 'Psalm 147:3', book: 'Psalms', chapter: 147, verseNumber: 3, topics: ['healing', 'comfort', 'bible-verses']),
    Verse(id: 'v32', text: 'Come to me, all you who are weary and burdened, and I will give you rest.', reference: 'Matthew 11:28', book: 'Matthew', chapter: 11, verseNumber: 28, topics: ['healing', 'rest', 'comfort', 'inner-peace', 'bible-verses']),
    Verse(id: 'v33', text: 'The Lord is close to the brokenhearted and saves those who are crushed in spirit.', reference: 'Psalm 34:18', book: 'Psalms', chapter: 34, verseNumber: 18, topics: ['comfort', 'healing', 'god', 'bible-verses']),
    Verse(id: 'v34', text: 'But I will restore you to health and heal your wounds, declares the Lord.', reference: 'Jeremiah 30:17', book: 'Jeremiah', chapter: 30, verseNumber: 17, topics: ['healing', 'hope', 'god', 'bible-verses']),

    // Gratitude
    Verse(id: 'v35', text: 'Give thanks in all circumstances; for this is God\'s will for you in Christ Jesus.', reference: '1 Thessalonians 5:18', book: '1 Thessalonians', chapter: 5, verseNumber: 18, topics: ['gratitude', 'faith', 'bible-verses']),
    Verse(id: 'v36', text: 'Enter his gates with thanksgiving and his courts with praise; give thanks to him and praise his name.', reference: 'Psalm 100:4', book: 'Psalms', chapter: 100, verseNumber: 4, topics: ['gratitude', 'praise', 'bible-verses']),
    Verse(id: 'v37', text: 'Every good and perfect gift is from above, coming down from the Father of the heavenly lights.', reference: 'James 1:17', book: 'James', chapter: 1, verseNumber: 17, topics: ['gratitude', 'god', 'bible-verses']),
    Verse(id: 'v38', text: 'I will give thanks to you, Lord, with all my heart; I will tell of all your wonderful deeds.', reference: 'Psalm 9:1', book: 'Psalms', chapter: 9, verseNumber: 1, topics: ['gratitude', 'praise', 'bible-verses']),

    // Self-worth
    Verse(id: 'v39', text: 'I praise you because I am fearfully and wonderfully made; your works are wonderful, I know that full well.', reference: 'Psalm 139:14', book: 'Psalms', chapter: 139, verseNumber: 14, topics: ['self-worth', 'gratitude', 'god', 'bible-verses']),
    Verse(id: 'v40', text: 'See what great love the Father has lavished on us, that we should be called children of God! And that is what we are!', reference: '1 John 3:1', book: '1 John', chapter: 3, verseNumber: 1, topics: ['self-worth', 'love', 'god', 'bible-verses']),
    Verse(id: 'v41', text: 'For we are God\'s handiwork, created in Christ Jesus to do good works, which God prepared in advance for us to do.', reference: 'Ephesians 2:10', book: 'Ephesians', chapter: 2, verseNumber: 10, topics: ['self-worth', 'faith', 'god', 'bible-verses']),

    // Kindness
    Verse(id: 'v42', text: 'Be kind and compassionate to one another, forgiving each other, just as in Christ God forgave you.', reference: 'Ephesians 4:32', book: 'Ephesians', chapter: 4, verseNumber: 32, topics: ['kindness', 'grace', 'love', 'bible-verses']),
    Verse(id: 'v43', text: 'Therefore, as God\'s chosen people, holy and dearly loved, clothe yourselves with compassion, kindness, humility, gentleness and patience.', reference: 'Colossians 3:12', book: 'Colossians', chapter: 3, verseNumber: 12, topics: ['kindness', 'love', 'faith', 'bible-verses']),
    Verse(id: 'v44', text: 'A gentle answer turns away wrath, but a harsh word stirs up anger.', reference: 'Proverbs 15:1', book: 'Proverbs', chapter: 15, verseNumber: 1, topics: ['kindness', 'peace', 'bible-verses']),

    // Mental health
    Verse(id: 'v45', text: 'God has not given us a spirit of fear, but of power and of love and of a sound mind.', reference: '2 Timothy 1:7', book: '2 Timothy', chapter: 1, verseNumber: 7, topics: ['mental-health', 'peace', 'strength', 'bible-verses']),
    Verse(id: 'v46', text: 'Cast all your anxiety on him because he cares for you.', reference: '1 Peter 5:7', book: '1 Peter', chapter: 5, verseNumber: 7, topics: ['mental-health', 'peace', 'anxiety', 'inner-peace', 'bible-verses']),
    Verse(id: 'v47', text: 'Do not be anxious about anything, but in every situation, by prayer and petition, with thanksgiving, present your requests to God.', reference: 'Philippians 4:6', book: 'Philippians', chapter: 4, verseNumber: 6, topics: ['mental-health', 'peace', 'prayer', 'anxiety', 'bible-verses']),

    // Letting go
    Verse(id: 'v48', text: 'Forget the former things; do not dwell on the past. See, I am doing a new thing!', reference: 'Isaiah 43:18-19', book: 'Isaiah', chapter: 43, verseNumber: 18, topics: ['letting-go', 'hope', 'god', 'bible-verses']),
    Verse(id: 'v49', text: 'Brothers and sisters, I do not consider myself yet to have taken hold of it. But one thing I do: Forgetting what is behind and straining toward what is ahead.', reference: 'Philippians 3:13', book: 'Philippians', chapter: 3, verseNumber: 13, topics: ['letting-go', 'hope', 'faith', 'bible-verses']),
    Verse(id: 'v50', text: 'Create in me a pure heart, O God, and renew a steadfast spirit within me.', reference: 'Psalm 51:10', book: 'Psalms', chapter: 51, verseNumber: 10, topics: ['letting-go', 'healing', 'god', 'bible-verses']),
  ];

  // Inspirational Quotes - 30+ quotes with affirmations
  static const List<Verse> quotes = [
    // Affirmations
    Verse(id: 'q1', text: 'I am blessed beyond measure.', topics: ['affirmations', 'gratitude', 'quotes']),
    Verse(id: 'q2', text: 'God\'s love for me is unconditional and everlasting.', topics: ['affirmations', 'love', 'god', 'quotes']),
    Verse(id: 'q3', text: 'I release all worry and embrace God\'s peace.', topics: ['affirmations', 'peace', 'inner-peace', 'letting-go', 'quotes']),
    Verse(id: 'q4', text: 'I am enough because God made me enough.', topics: ['affirmations', 'self-worth', 'quotes']),
    Verse(id: 'q5', text: 'My heart is open to receive God\'s blessings today.', topics: ['affirmations', 'faith', 'hope', 'quotes']),
    Verse(id: 'q6', text: 'I forgive myself and others, and I move forward in grace.', topics: ['affirmations', 'grace', 'letting-go', 'healing', 'quotes']),
    Verse(id: 'q7', text: 'Every day is a new opportunity to grow in faith.', topics: ['affirmations', 'faith', 'hope', 'quotes']),
    Verse(id: 'q8', text: 'I am surrounded by God\'s love and protection.', topics: ['affirmations', 'love', 'god', 'quotes']),
    Verse(id: 'q9', text: 'Today I choose faith over fear.', topics: ['affirmations', 'faith', 'quotes']),
    Verse(id: 'q10', text: 'I am worthy of love, belonging, and joy.', topics: ['affirmations', 'self-worth', 'love', 'quotes']),
    Verse(id: 'q11', text: 'I am grateful for all my prayers being answered.', topics: ['affirmations', 'gratitude', 'prayer', 'quotes']),
    Verse(id: 'q12', text: 'Today, I protect the peace that God has planted in me.', topics: ['affirmations', 'peace', 'inner-peace', 'quotes']),
    Verse(id: 'q13', text: 'I trust God\'s plan for my life.', topics: ['affirmations', 'faith', 'god', 'quotes']),
    Verse(id: 'q14', text: 'I am fearfully and wonderfully made.', topics: ['affirmations', 'self-worth', 'quotes']),
    Verse(id: 'q15', text: 'God\'s grace is sufficient for me.', topics: ['affirmations', 'grace', 'quotes']),

    // Uplifting quotes
    Verse(id: 'q16', text: 'You\'re stronger than you know, {name}, because God walks with you.', topics: ['uplifting', 'strength', 'quotes'], isPersonalized: true),
    Verse(id: 'q17', text: 'Everything you\'ve experienced is leading you to the path God created for you, {name}.', topics: ['uplifting', 'hope', 'faith', 'quotes'], isPersonalized: true),
    Verse(id: 'q18', text: 'Very soon you will smile and say, "God, this is more than I prayed for."', topics: ['uplifting', 'hope', 'gratitude', 'quotes']),
    Verse(id: 'q19', text: 'Your current situation is not your final destination. God has more in store for you.', topics: ['uplifting', 'hope', 'faith', 'quotes']),
    Verse(id: 'q20', text: 'God didn\'t bring you this far to leave you, {name}.', topics: ['uplifting', 'faith', 'hope', 'quotes'], isPersonalized: true),
    Verse(id: 'q21', text: 'The sun will rise again, and so will you.', topics: ['uplifting', 'hope', 'quotes']),
    Verse(id: 'q22', text: 'You were made for such a time as this.', topics: ['uplifting', 'hope', 'self-worth', 'quotes']),
    Verse(id: 'q23', text: 'Your story isn\'t over yet. The best chapters are still being written.', topics: ['uplifting', 'hope', 'faith', 'quotes']),
    Verse(id: 'q24', text: '{name}, God\'s timing is perfect. Trust the wait.', topics: ['uplifting', 'faith', 'hope', 'quotes'], isPersonalized: true),

    // General inspirational
    Verse(id: 'q25', text: 'Let go and let God.', topics: ['letting-go', 'faith', 'quotes']),
    Verse(id: 'q26', text: 'Don\'t worry about tomorrow. God is already there.', topics: ['faith', 'peace', 'inner-peace', 'quotes']),
    Verse(id: 'q27', text: 'When you can\'t control what\'s happening, challenge yourself to control the way you respond. That\'s where your power is.', topics: ['mental-health', 'strength', 'quotes']),
    Verse(id: 'q28', text: 'Be patient with yourself. Healing takes time.', topics: ['healing', 'self-worth', 'quotes']),
    Verse(id: 'q29', text: 'Grace means God gives you what you don\'t deserve, and mercy means He doesn\'t give you what you do deserve.', topics: ['grace', 'god', 'quotes']),
    Verse(id: 'q30', text: 'In a world where you can be anything, be kind.', topics: ['kindness', 'love', 'quotes']),
    Verse(id: 'q31', text: 'When God wakes you up at 3 a.m., pray. Start with Him. He\'s all you need.', topics: ['prayer', 'faith', 'quotes']),
    Verse(id: 'q32', text: 'Kindness is a language the deaf can hear and the blind can see.', topics: ['kindness', 'love', 'quotes']),
  ];

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

  // Prayers - 20+ prayers
  static const List<Prayer> prayers = [
    Prayer(id: 'p1', title: 'Morning Prayer', content: 'Lord, thank You for this new day. Guide my steps and fill my heart with Your peace. Help me to be a light to others and to trust in Your plan. Amen.', topic: 'faith'),
    Prayer(id: 'p2', title: 'Prayer for Peace', content: 'Heavenly Father, calm my anxious heart. Replace my worries with Your perfect peace. Help me to rest in the knowledge that You are in control. Amen.', topic: 'peace'),
    Prayer(id: 'p3', title: 'Prayer for Strength', content: 'Lord, I feel weak today. Pour Your strength into me. Remind me that I can do all things through Christ who strengthens me. Amen.', topic: 'strength'),
    Prayer(id: 'p4', title: 'Prayer for Healing', content: 'Father, You are the great healer. Touch my body, mind, and spirit with Your healing power. I trust in Your restoration. Amen.', topic: 'healing'),
    Prayer(id: 'p5', title: 'Gratitude Prayer', content: 'Thank You, Lord, for all Your blessings. Help me to see Your goodness in every moment. I am grateful for Your endless love. Amen.', topic: 'gratitude'),
    Prayer(id: 'p6', title: 'Prayer for {name}', content: 'Lord, I lift up {name} to You today. Guide their path, protect their heart, and fill them with Your joy. Let them feel Your presence always. Amen.', topic: 'faith', isPersonalized: true),
    Prayer(id: 'p7', title: 'Evening Prayer', content: 'Lord, as this day ends, I thank You for Your faithfulness. Forgive my shortcomings and give me restful sleep. Watch over me through the night. Amen.', topic: 'faith'),
    Prayer(id: 'p8', title: 'Prayer for Guidance', content: 'Father, I need Your wisdom. Show me the path I should take. Help me to hear Your voice above all others. Lead me in Your truth. Amen.', topic: 'faith'),
    Prayer(id: 'p9', title: 'Prayer for Grace', content: 'Lord, fill me with Your grace today. Help me to extend grace to others as You have graciously given to me. Let Your mercy flow through me. Amen.', topic: 'grace'),
    Prayer(id: 'p10', title: 'Prayer for Inner Peace', content: 'Father, quiet the storms within me. Let Your peace that surpasses all understanding guard my heart and mind. Help me to rest in Your presence. Amen.', topic: 'inner-peace'),
    Prayer(id: 'p11', title: 'Prayer for Self-Worth', content: 'Lord, remind me that I am fearfully and wonderfully made. Help me to see myself as You see me—loved, valued, and precious. Amen.', topic: 'self-worth'),
    Prayer(id: 'p12', title: 'Prayer for Letting Go', content: 'Father, help me release what I cannot control. Give me the courage to let go of the past and trust You with my future. Amen.', topic: 'letting-go'),
    Prayer(id: 'p13', title: 'Prayer for Mental Clarity', content: 'Lord, calm my anxious thoughts. Replace confusion with clarity, fear with faith, and worry with worship. Renew my mind in You. Amen.', topic: 'mental-health'),
    Prayer(id: 'p14', title: 'Prayer for Kindness', content: 'Father, make me an instrument of Your kindness today. Help me to see others through Your eyes and respond with compassion and love. Amen.', topic: 'kindness'),
    Prayer(id: 'p15', title: 'Prayer for Hope', content: 'Lord, when I feel hopeless, remind me of Your promises. Fill me with hope that does not disappoint. Help me to trust in Your perfect timing. Amen.', topic: 'hope'),
    Prayer(id: 'p16', title: 'Prayer for Love', content: 'Father, teach me to love as You love. Fill my heart with Your unconditional love so that I may share it with others. Amen.', topic: 'love'),
    Prayer(id: 'p17', title: 'Prayer for Faith', content: 'Lord, increase my faith. Help me to trust You even when I cannot see the way forward. Strengthen my belief in Your goodness. Amen.', topic: 'faith'),
    Prayer(id: 'p18', title: 'Prayer for Protection', content: 'Heavenly Father, surround me with Your protection today. Guard my heart, mind, and body from all harm. I trust in Your care. Amen.', topic: 'faith'),
    Prayer(id: 'p19', title: 'Prayer for Wisdom', content: 'Lord, grant me wisdom in all my decisions. Help me to seek Your will above my own. Guide my thoughts and actions today. Amen.', topic: 'faith'),
    Prayer(id: 'p20', title: 'Prayer of Surrender', content: 'Father, I surrender all to You. Take my worries, my fears, and my plans. I trust You completely with my life. Your will be done. Amen.', topic: 'letting-go'),
  ];

  static List<Verse> getAllContent() {
    return [...verses, ...quotes]..shuffle();
  }

  static List<Verse> getByTopic(String topicId) {
    if (topicId == 'prayers') {
      return prayers.map((p) => Verse(
        id: p.id,
        text: '${p.title}\n\n${p.content}',
        topics: ['prayers', p.topic],
      )).toList();
    }
    return [...verses, ...quotes].where((v) => v.topics.contains(topicId)).toList();
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
