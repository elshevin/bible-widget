import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';
import '../providers/app_state.dart';
import '../data/content_data.dart';
import '../services/notification_service.dart';
import 'home_screen.dart';

class OnboardingFlow extends StatefulWidget {
  const OnboardingFlow({super.key});

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // User selections
  String _userName = '';
  int? _selectedAge;
  String? _selectedGender;
  String? _selectedRelationship;
  String? _selectedBibleFamiliarity;
  String? _selectedFaithPractice;
  String? _selectedDenomination;
  String? _selectedPrayerFrequency;
  int? _selectedStreakGoal;
  final List<String> _selectedHabitHelpers = [];
  final List<String> _selectedTopics = [];
  String _selectedThemeId = 'autumn_forest';

  // Reminder settings
  bool _enableReminder = true;
  TimeOfDay _reminderTime = const TimeOfDay(hour: 9, minute: 0);

  final List<String> _ageRanges = [
    '13 to 17',
    '18 to 24',
    '25 to 34',
    '35 to 44',
    '45 to 54',
    '55+',
  ];

  final List<String> _genders = ['Female', 'Male', 'Prefer not to say'];

  final List<String> _relationships = [
    'Single',
    'Widowed',
    'Married',
    'Dating/courting',
    'Not interested in this topic',
  ];

  final List<String> _bibleFamiliarities = [
    'Very familiar',
    'Somewhat familiar',
    'Not familiar at all',
  ];

  final List<String> _faithPractices = [
    'Actively practicing',
    'Exploring',
    'Lapsed',
    'Spiritual but not religious',
    'Other',
  ];

  final List<String> _denominations = [
    'I prefer a broad Christian mix',
    'Protestant',
    'Catholic',
  ];

  final List<String> _prayerFrequencies = [
    'Multiple times a day',
    'Once or twice a day',
    'Rarely, I forget to',
    'I\'m not sure how to',
  ];

  final List<Map<String, dynamic>> _streakGoals = [
    {'days': 3, 'label': '3 days in a row'},
    {'days': 7, 'label': '7 days in a row'},
    {'days': 21, 'label': '21 days in a row'},
  ];

  final List<String> _habitHelpers = [
    'Getting regular reminders',
    'Tracking my progress',
    'A home/lock screen widget',
    'I don\'t know yet',
  ];

  // Total pages count
  static const int _totalPages = 17;

  void _nextPage() {
    // Dismiss keyboard when moving to next page
    FocusScope.of(context).unfocus();

    if (_currentPage < _totalPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  Future<void> _completeOnboarding() async {
    final appState = context.read<AppState>();
    appState.setUserName(_userName);
    if (_selectedAge != null) appState.setAgeRange(_selectedAge!);
    if (_selectedGender != null) appState.setGender(_selectedGender!);
    appState.setSelectedTopics(_selectedTopics);
    appState.setTheme(_selectedThemeId);

    // Schedule reminder if enabled
    if (_enableReminder) {
      await NotificationService.requestPermissions();
      await NotificationService.scheduleDailyReminder(
        hour: _reminderTime.hour,
        minute: _reminderTime.minute,
      );
    }

    appState.completeOnboarding();

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (index) => setState(() => _currentPage = index),
        children: [
          // 1. Intro - Personalize the app
          SafeArea(
            child: _buildTransitionPage(
              title: 'Personalize the app by\nsharing a few details\nabout yourself',
              showIcon: true,
            ),
          ),
          // 2. Name
          SafeArea(child: _buildNamePage()),
          // 3. Age
          SafeArea(child: _buildAgePage()),
          // 4. Gender
          SafeArea(child: _buildGenderPage()),
          // 5. Relationship status
          SafeArea(child: _buildRelationshipPage()),
          // 6. Transition - Faith journey
          SafeArea(
            child: _buildTransitionPage(
              title: 'Let\'s talk about your\nfaith and your\npersonal journey',
            ),
          ),
          // 7. Bible familiarity
          SafeArea(child: _buildBibleFamiliarityPage()),
          // 8. Faith practice
          SafeArea(child: _buildFaithPracticePage()),
          // 9. Denomination
          SafeArea(child: _buildDenominationPage()),
          // 10. Transition - Set up app
          SafeArea(
            child: _buildTransitionPage(
              title: 'Set up the app according\nto your preferences',
              showIcon: true,
              iconType: 'phone',
            ),
          ),
          // 11. Prayer frequency
          SafeArea(child: _buildPrayerFrequencyPage()),
          // 12. Streak goal
          SafeArea(child: _buildStreakGoalPage()),
          // 13. Streak intro
          SafeArea(child: _buildStreakIntroPage()),
          // 14. Reminder setup
          SafeArea(child: _buildReminderPage()),
          // 15. Topics
          SafeArea(child: _buildTopicsPage()),
          // 16. Theme
          SafeArea(child: _buildThemePage()),
          // 17. Final welcome - NO SafeArea wrapper, handled inside
          _buildPersonalizedWelcome(),
        ],
      ),
    );
  }

  Widget _buildPageWrapper({
    required String title,
    required Widget content,
    bool showSkip = true,
    VoidCallback? onContinue,
    String continueText = 'Continue',
    bool canContinue = true,
    bool showContinueButton = true,
  }) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Skip button
          if (showSkip)
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: _nextPage,
                child: const Text(
                  'Skip',
                  style: TextStyle(
                    color: AppTheme.primaryText,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            )
          else
            const SizedBox(height: 48),
          const SizedBox(height: 20),
          // Title
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displaySmall,
          ),
          const SizedBox(height: 32),
          // Content
          Expanded(child: content),
          // Continue button
          if (showContinueButton)
            GradientButton(
              text: continueText,
              onPressed: canContinue ? (onContinue ?? _nextPage) : null,
            ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildTransitionPage({
    required String title,
    bool showIcon = false,
    String iconType = 'plant',
  }) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          if (showIcon) ...[
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.orange.shade100,
                    Colors.blue.shade100,
                  ],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                iconType == 'phone' ? Icons.phone_iphone : Icons.eco_outlined,
                size: 50,
                color: AppTheme.primaryText.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 60),
          ],
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  height: 1.3,
                ),
          ),
          const Spacer(),
          GradientButton(
            text: 'Continue',
            onPressed: _nextPage,
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildNamePage() {
    return _buildPageWrapper(
      title: 'What do you want to\nbe called?',
      canContinue: _userName.isNotEmpty,
      content: Column(
        children: [
          TextField(
            onChanged: (value) => setState(() => _userName = value),
            decoration: const InputDecoration(
              hintText: 'Your name',
            ),
            style: const TextStyle(fontSize: 16),
            textCapitalization: TextCapitalization.words,
          ),
        ],
      ),
    );
  }

  Widget _buildAgePage() {
    return _buildPageWrapper(
      title: 'How old are you?',
      content: ListView.separated(
        itemCount: _ageRanges.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          return OptionCard(
            text: _ageRanges[index],
            isSelected: _selectedAge == index,
            onTap: () => setState(() => _selectedAge = index),
          );
        },
      ),
    );
  }

  Widget _buildGenderPage() {
    return _buildPageWrapper(
      title: 'Which option represents\nyou best${_userName.isNotEmpty ? ', $_userName' : ''}?',
      content: ListView.separated(
        itemCount: _genders.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          return OptionCard(
            text: _genders[index],
            isSelected: _selectedGender == _genders[index],
            onTap: () => setState(() => _selectedGender = _genders[index]),
          );
        },
      ),
    );
  }

  Widget _buildRelationshipPage() {
    return _buildPageWrapper(
      title: 'What\'s your\nrelationship status?',
      content: ListView.separated(
        itemCount: _relationships.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          return OptionCard(
            text: _relationships[index],
            isSelected: _selectedRelationship == _relationships[index],
            onTap: () => setState(() => _selectedRelationship = _relationships[index]),
          );
        },
      ),
    );
  }

  Widget _buildBibleFamiliarityPage() {
    return _buildPageWrapper(
      title: 'How familiar are you\nwith God\'s word?',
      content: ListView.separated(
        itemCount: _bibleFamiliarities.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          return OptionCard(
            text: _bibleFamiliarities[index],
            isSelected: _selectedBibleFamiliarity == _bibleFamiliarities[index],
            onTap: () => setState(() => _selectedBibleFamiliarity = _bibleFamiliarities[index]),
          );
        },
      ),
    );
  }

  Widget _buildFaithPracticePage() {
    return _buildPageWrapper(
      title: 'How would you describe\nyour current faith\npractice?',
      content: ListView.separated(
        itemCount: _faithPractices.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          return OptionCard(
            text: _faithPractices[index],
            isSelected: _selectedFaithPractice == _faithPractices[index],
            onTap: () => setState(() => _selectedFaithPractice = _faithPractices[index]),
          );
        },
      ),
    );
  }

  Widget _buildDenominationPage() {
    return _buildPageWrapper(
      title: 'Do you prefer quotes\nfrom a specific\ndenomination?',
      content: ListView.separated(
        itemCount: _denominations.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          return OptionCard(
            text: _denominations[index],
            isSelected: _selectedDenomination == _denominations[index],
            onTap: () => setState(() => _selectedDenomination = _denominations[index]),
          );
        },
      ),
    );
  }

  Widget _buildPrayerFrequencyPage() {
    return _buildPageWrapper(
      title: 'How often do you pause\nto check in with God?',
      content: ListView.separated(
        itemCount: _prayerFrequencies.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          return OptionCard(
            text: _prayerFrequencies[index],
            isSelected: _selectedPrayerFrequency == _prayerFrequencies[index],
            onTap: () => setState(() => _selectedPrayerFrequency = _prayerFrequencies[index]),
          );
        },
      ),
    );
  }

  Widget _buildStreakGoalPage() {
    return _buildPageWrapper(
      title: 'What goal do you want\nto start with?',
      content: ListView.separated(
        itemCount: _streakGoals.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final goal = _streakGoals[index];
          return OptionCard(
            text: goal['label'],
            isSelected: _selectedStreakGoal == goal['days'],
            onTap: () => setState(() => _selectedStreakGoal = goal['days']),
          );
        },
      ),
    );
  }

  Widget _buildStreakIntroPage() {
    final days = ['Fr', 'Sa', 'Su', 'Mo', 'Tu', 'We', 'Th'];

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          // Streak circle with rays
          SizedBox(
            width: 160,
            height: 160,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Rays
                ...List.generate(12, (index) {
                  final angle = index * 30.0 * 3.14159 / 180;
                  return Transform.rotate(
                    angle: angle,
                    child: Container(
                      width: 2,
                      height: 140,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.transparent,
                            AppTheme.primaryText.withOpacity(0.3),
                            Colors.transparent,
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  );
                }),
                // Center circle
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.orange.shade200,
                        Colors.blue.shade200,
                      ],
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text(
                      '1',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryText,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          Text(
            'Grow closer to God with\na consistent routine',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  height: 1.3,
                ),
          ),
          const SizedBox(height: 32),
          // Week days row
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppTheme.cardBackground,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: days.map((day) {
                    final isFirst = day == 'Fr';
                    return Column(
                      children: [
                        Text(
                          day,
                          style: TextStyle(
                            fontSize: 12,
                            color: AppTheme.secondaryText.withOpacity(0.7),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: isFirst
                                ? AppTheme.accent
                                : AppTheme.secondaryText.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: isFirst
                              ? const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 18,
                                )
                              : null,
                        ),
                      ],
                    );
                  }).toList(),
                ),
                const SizedBox(height: 12),
                Text(
                  'Build a streak, one day at a time',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.secondaryText.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          GradientButton(
            text: 'Continue',
            onPressed: _nextPage,
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildReminderPage() {
    final hour12 = _reminderTime.hourOfPeriod == 0 ? 12 : _reminderTime.hourOfPeriod;
    final timeString = '$hour12:${_reminderTime.minute.toString().padLeft(2, '0')} ${_reminderTime.period == DayPeriod.am ? 'AM' : 'PM'}';

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                setState(() => _enableReminder = false);
                _nextPage();
              },
              child: const Text(
                'Skip',
                style: TextStyle(
                  color: AppTheme.primaryText,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Get reminders\nthroughout the day',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displaySmall,
          ),
          const SizedBox(height: 12),
          Text(
            'Brief moments of reflection can make a\nbig difference in your faith',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.secondaryText.withOpacity(0.8),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 32),
          // Preview notification
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.cardBackground,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppTheme.accent.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.menu_book_rounded,
                    color: AppTheme.accent,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Bible Widgets',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        'Let go and let God.',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppTheme.secondaryText.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  'Now',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.secondaryText.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          // Time picker - iOS style wheel picker in bottom sheet
          GestureDetector(
            onTap: () => _showTimePickerSheet(),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: AppTheme.cardBackground,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Reminder time',
                    style: TextStyle(fontSize: 16),
                  ),
                  Row(
                    children: [
                      Text(
                        timeString,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.accent,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.chevron_right,
                        color: AppTheme.secondaryText.withOpacity(0.5),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
          GradientButton(
            text: 'Allow and Save',
            onPressed: () {
              setState(() => _enableReminder = true);
              _nextPage();
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  void _showTimePickerSheet() {
    int selectedHour = _reminderTime.hourOfPeriod == 0 ? 12 : _reminderTime.hourOfPeriod;
    int selectedMinute = _reminderTime.minute;
    bool isAM = _reminderTime.period == DayPeriod.am;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Container(
              decoration: const BoxDecoration(
                color: AppTheme.cardBackground,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 12),
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(sheetContext),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(
                              color: AppTheme.secondaryText,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        const Text(
                          'Set Time',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            // Convert back to 24-hour format
                            int hour24 = selectedHour;
                            if (isAM && selectedHour == 12) {
                              hour24 = 0;
                            } else if (!isAM && selectedHour != 12) {
                              hour24 = selectedHour + 12;
                            }
                            setState(() {
                              _reminderTime = TimeOfDay(hour: hour24, minute: selectedMinute);
                            });
                            Navigator.pop(sheetContext);
                          },
                          child: const Text(
                            'Done',
                            style: TextStyle(
                              color: AppTheme.accent,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 200,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Hour picker
                        SizedBox(
                          width: 70,
                          child: ListWheelScrollView.useDelegate(
                            itemExtent: 50,
                            physics: const FixedExtentScrollPhysics(),
                            onSelectedItemChanged: (index) {
                              setSheetState(() => selectedHour = index + 1);
                            },
                            controller: FixedExtentScrollController(
                              initialItem: selectedHour - 1,
                            ),
                            childDelegate: ListWheelChildBuilderDelegate(
                              childCount: 12,
                              builder: (context, index) {
                                final hour = index + 1;
                                final isSelected = hour == selectedHour;
                                return Center(
                                  child: Text(
                                    hour.toString(),
                                    style: TextStyle(
                                      fontSize: isSelected ? 28 : 20,
                                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                      color: isSelected ? AppTheme.primaryText : AppTheme.secondaryText,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        const Text(
                          ':',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        // Minute picker
                        SizedBox(
                          width: 70,
                          child: ListWheelScrollView.useDelegate(
                            itemExtent: 50,
                            physics: const FixedExtentScrollPhysics(),
                            onSelectedItemChanged: (index) {
                              setSheetState(() => selectedMinute = index);
                            },
                            controller: FixedExtentScrollController(
                              initialItem: selectedMinute,
                            ),
                            childDelegate: ListWheelChildBuilderDelegate(
                              childCount: 60,
                              builder: (context, index) {
                                final isSelected = index == selectedMinute;
                                return Center(
                                  child: Text(
                                    index.toString().padLeft(2, '0'),
                                    style: TextStyle(
                                      fontSize: isSelected ? 28 : 20,
                                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                      color: isSelected ? AppTheme.primaryText : AppTheme.secondaryText,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        // AM/PM picker
                        SizedBox(
                          width: 60,
                          child: ListWheelScrollView.useDelegate(
                            itemExtent: 50,
                            physics: const FixedExtentScrollPhysics(),
                            onSelectedItemChanged: (index) {
                              setSheetState(() => isAM = index == 0);
                            },
                            controller: FixedExtentScrollController(
                              initialItem: isAM ? 0 : 1,
                            ),
                            childDelegate: ListWheelChildBuilderDelegate(
                              childCount: 2,
                              builder: (context, index) {
                                final text = index == 0 ? 'AM' : 'PM';
                                final isSelected = (index == 0) == isAM;
                                return Center(
                                  child: Text(
                                    text,
                                    style: TextStyle(
                                      fontSize: isSelected ? 24 : 18,
                                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                      color: isSelected ? AppTheme.primaryText : AppTheme.secondaryText,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).padding.bottom + 24),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildTopicsPage() {
    return _buildPageWrapper(
      title: 'Which topics do you\nwant to follow?',
      canContinue: true,
      content: SingleChildScrollView(
        child: Wrap(
          spacing: 10,
          runSpacing: 10,
          children: ContentData.topics.map((topic) {
            final isSelected = _selectedTopics.contains(topic.id);
            return TopicChip(
              text: topic.name,
              isSelected: isSelected,
              onTap: () {
                setState(() {
                  if (isSelected) {
                    _selectedTopics.remove(topic.id);
                  } else {
                    _selectedTopics.add(topic.id);
                  }
                });
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildThemePage() {
    // Use themes with background images for a better visual selection
    final onboardingThemes = [
      VisualThemes.getById('autumn_forest'),
      VisualThemes.getById('ocean_deep'),
      VisualThemes.getById('lavender_fields'),
      VisualThemes.getById('tropical_sunset'),
      VisualThemes.getById('spring_meadow'),
      VisualThemes.getById('sapphire_night'),
    ];

    return _buildPageWrapper(
      title: 'Which theme would you\nlike to start with?',
      showSkip: false,
      content: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.7,
        ),
        itemCount: onboardingThemes.length,
        itemBuilder: (context, index) {
          final theme = onboardingThemes[index];
          return ThemePreviewCard(
            name: theme.name,
            gradient: theme.gradient,
            backgroundImage: theme.backgroundImage,
            isSelected: _selectedThemeId == theme.id,
            isVideo: false,
            onTap: () => setState(() => _selectedThemeId = theme.id),
          );
        },
      ),
    );
  }

  Widget _buildPersonalizedWelcome() {
    // Use the selected theme from the previous page
    final selectedTheme = VisualThemes.getById(_selectedThemeId);

    return Container(
      decoration: BoxDecoration(
        gradient: selectedTheme.gradient,
        image: selectedTheme.backgroundImage != null
            ? DecorationImage(
                image: AssetImage(selectedTheme.backgroundImage!),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Text(
                _userName.isNotEmpty
                    ? 'Everything you\'ve experienced is leading you to the path God created for you, $_userName.'
                    : 'Everything you\'ve experienced is leading you to the path God created for you.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: selectedTheme.textColor,
                      height: 1.4,
                    ),
              ),
              const Spacer(),
              GradientButton(
                text: 'Continue',
                onPressed: _completeOnboarding,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
