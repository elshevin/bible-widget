import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

// Gradient Button (Gold)
class GradientButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final double? width;
  final double height;

  const GradientButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.width,
    this.height = 56,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.infinity,
      height: height,
      decoration: BoxDecoration(
        gradient: AppTheme.goldGradient,
        borderRadius: BorderRadius.circular(height / 2),
        boxShadow: [
          BoxShadow(
            color: AppTheme.accent.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(height / 2),
          child: Center(
            child: isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryText),
                    ),
                  )
                : Text(
                    text,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primaryText,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

// Option Card (for onboarding selections)
class OptionCard extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;
  final Widget? leading;
  final bool showRadio;

  const OptionCard({
    super.key,
    required this.text,
    required this.isSelected,
    required this.onTap,
    this.leading,
    this.showRadio = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : AppTheme.cardBackground,
          borderRadius: BorderRadius.circular(16),
          border: isSelected
              ? Border.all(color: AppTheme.accent, width: 2)
              : null,
        ),
        child: Row(
          children: [
            if (leading != null) ...[
              leading!,
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: AppTheme.primaryText,
                ),
              ),
            ),
            if (showRadio)
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? AppTheme.accent : AppTheme.secondaryText.withOpacity(0.3),
                    width: 2,
                  ),
                  color: isSelected ? AppTheme.accent : Colors.transparent,
                ),
                child: isSelected
                    ? const Icon(Icons.check, size: 16, color: Colors.white)
                    : null,
              ),
          ],
        ),
      ),
    );
  }
}

// Topic Chip
class TopicChip extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const TopicChip({
    super.key,
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryText : AppTheme.cardBackground,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isSelected ? '✓' : '+',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : AppTheme.primaryText,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              text,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : AppTheme.primaryText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Streak Widget
class StreakWidget extends StatelessWidget {
  final int streakCount;
  final bool showFullWeek;

  const StreakWidget({
    super.key,
    required this.streakCount,
    this.showFullWeek = true,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final weekDays = ['Fr', 'Sa', 'Su', 'Mo', 'Tu', 'We', 'Th'];
    final todayIndex = (now.weekday + 4) % 7; // Adjust to start from Friday

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Sun icon with streak count
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.blue.shade200,
                      Colors.orange.shade100,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Sun rays
                    ...List.generate(8, (index) {
                      final angle = index * 0.785; // 45 degrees in radians
                      return Transform.rotate(
                        angle: angle,
                        child: Container(
                          width: 2,
                          height: 70,
                          color: Colors.black.withOpacity(0.1),
                        ),
                      );
                    }),
                    // Center circle with number
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.blue.shade300,
                            Colors.orange.shade200,
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '$streakCount',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryText,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Week days
              if (showFullWeek)
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(7, (index) {
                      final isToday = index == todayIndex;
                      final isPast = index < todayIndex;
                      final isCompleted = isPast || isToday;
                      
                      return Column(
                        children: [
                          Text(
                            weekDays[index],
                            style: TextStyle(
                              fontSize: 12,
                              color: isToday 
                                  ? AppTheme.primaryText 
                                  : AppTheme.secondaryText,
                              fontWeight: isToday 
                                  ? FontWeight.w600 
                                  : FontWeight.normal,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isCompleted && isToday
                                  ? AppTheme.accent
                                  : AppTheme.cardBackground.withOpacity(0.5),
                              border: isToday
                                  ? Border.all(color: AppTheme.accent, width: 2)
                                  : null,
                            ),
                            child: isCompleted && isToday
                                ? const Icon(
                                    Icons.check,
                                    size: 16,
                                    color: Colors.white,
                                  )
                                : null,
                          ),
                        ],
                      );
                    }),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

// Action Icon Button
class ActionIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool isActive;
  final double size;

  const ActionIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.isActive = false,
    this.size = 28,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Icon(
          icon,
          size: size,
          color: isActive ? Colors.red : Colors.white,
        ),
      ),
    );
  }
}

// Bottom Sheet Handle
class BottomSheetHandle extends StatelessWidget {
  const BottomSheetHandle({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 4,
      margin: const EdgeInsets.only(top: 12, bottom: 8),
      decoration: BoxDecoration(
        color: AppTheme.secondaryText.withOpacity(0.3),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}

// Premium Badge
class PremiumBadge extends StatelessWidget {
  final bool small;

  const PremiumBadge({super.key, this.small = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: small ? 6 : 8,
        vertical: small ? 2 : 4,
      ),
      decoration: BoxDecoration(
        color: AppTheme.accent,
        borderRadius: BorderRadius.circular(small ? 4 : 6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.lock,
            size: small ? 10 : 12,
            color: Colors.white,
          ),
          if (!small) ...[
            const SizedBox(width: 4),
            const Text(
              'PRO',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// Theme Preview Card
class ThemePreviewCard extends StatelessWidget {
  final String name;
  final LinearGradient gradient;
  final bool isSelected;
  final bool isPremium;
  final bool isVideo;
  final VoidCallback onTap;

  const ThemePreviewCard({
    super.key,
    required this.name,
    required this.gradient,
    required this.isSelected,
    required this.onTap,
    this.isPremium = false,
    this.isVideo = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 160,
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(16),
          border: isSelected
              ? Border.all(color: AppTheme.primaryText, width: 3)
              : null,
        ),
        child: Stack(
          children: [
            // Font preview
            Center(
              child: Text(
                'Aa',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w500,
                  color: gradient.colors.first.computeLuminance() > 0.5
                      ? AppTheme.primaryText
                      : Colors.white,
                ),
              ),
            ),
            // Selection indicator
            if (isSelected)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: const BoxDecoration(
                    color: AppTheme.primaryText,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    size: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            // Video indicator
            if (isVideo && !isSelected)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.play_arrow,
                    size: 14,
                    color: Colors.white,
                  ),
                ),
              ),
            // Premium indicator
            if (isPremium)
              const Positioned(
                bottom: 8,
                right: 8,
                child: PremiumBadge(small: true),
              ),
            // Edit button for selected
            if (isSelected)
              Positioned(
                bottom: 8,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Edit',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primaryText,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
