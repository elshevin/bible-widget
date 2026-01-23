import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';
import '../providers/app_state.dart';
import '../data/content_data.dart';
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
  final List<String> _selectedTopics = [];
  String _selectedThemeId = 'golden_water';

  final List<String> _ageRanges = [
    '13 to 17',
    '18 to 24',
    '25 to 34',
    '35 to 44',
    '45 to 54',
    '55+',
  ];

  final List<String> _genders = ['Female', 'Male', 'Prefer not to say'];

  void _nextPage() {
    if (_currentPage < 5) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _completeOnboarding() {
    final appState = context.read<AppState>();
    appState.setUserName(_userName);
    if (_selectedAge != null) appState.setAgeRange(_selectedAge!);
    if (_selectedGender != null) appState.setGender(_selectedGender!);
    appState.setSelectedTopics(_selectedTopics);
    appState.setTheme(_selectedThemeId);
    appState.completeOnboarding();
    
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          onPageChanged: (index) => setState(() => _currentPage = index),
          children: [
            _buildNamePage(),
            _buildAgePage(),
            _buildGenderPage(),
            _buildTopicsPage(),
            _buildThemePage(),
            _buildPersonalizedWelcome(),
          ],
        ),
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
          GradientButton(
            text: continueText,
            onPressed: canContinue ? (onContinue ?? _nextPage) : null,
          ),
          const SizedBox(height: 16),
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
    final themes = [
      ('golden_water', 'Golden Water', const [Color(0xFF2C1810), Color(0xFF8B6914)]),
      ('sunset_sky', 'Sunset Sky', const [Color(0xFF667eea), Color(0xFFf093fb)]),
      ('ocean_calm', 'Ocean Calm', const [Color(0xFF4facfe), Color(0xFF00f2fe)]),
      ('warm_dawn', 'Warm Dawn', const [Color(0xFFffecd2), Color(0xFFfcb69f)]),
      ('forest_mist', 'Forest Mist', const [Color(0xFF134e5e), Color(0xFF71b280)]),
      ('cream_simple', 'Cream', const [Color(0xFFF5EDE4), Color(0xFFEDE5DC)]),
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
        itemCount: themes.length,
        itemBuilder: (context, index) {
          final theme = themes[index];
          return ThemePreviewCard(
            name: theme.$2,
            gradient: LinearGradient(
              colors: theme.$3,
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            isSelected: _selectedThemeId == theme.$1,
            isVideo: index == 0,
            onTap: () => setState(() => _selectedThemeId = theme.$1),
          );
        },
      ),
    );
  }

  Widget _buildPersonalizedWelcome() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF2C1810),
            const Color(0xFF8B6914).withOpacity(0.8),
            const Color(0xFF2C1810),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
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
                  color: Colors.white,
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
