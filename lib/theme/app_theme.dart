import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Core colors
  static const Color background = Color(0xFFF5EDE4);
  static const Color cardBackground = Color(0xFFEDE5DC);
  static const Color primaryText = Color(0xFF2D2D2D);
  static const Color secondaryText = Color(0xFF6B6B6B);
  static const Color accent = Color(0xFFD4A574);
  static const Color accentDark = Color(0xFFC49A6C);
  
  // Gradient for buttons
  static const LinearGradient goldGradient = LinearGradient(
    colors: [Color(0xFFE8C47C), Color(0xFFD4A574)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient darkGoldGradient = LinearGradient(
    colors: [Color(0xFFD4A574), Color(0xFFC49A6C)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static ThemeData get theme => ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: background,
    colorScheme: ColorScheme.fromSeed(
      seedColor: accent,
      background: background,
      surface: cardBackground,
      brightness: Brightness.light,
    ),
    textTheme: TextTheme(
      displayLarge: GoogleFonts.playfairDisplay(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: primaryText,
      ),
      displayMedium: GoogleFonts.playfairDisplay(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: primaryText,
      ),
      displaySmall: GoogleFonts.playfairDisplay(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: primaryText,
      ),
      headlineLarge: GoogleFonts.playfairDisplay(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: primaryText,
      ),
      headlineMedium: GoogleFonts.playfairDisplay(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: primaryText,
      ),
      headlineSmall: GoogleFonts.playfairDisplay(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: primaryText,
      ),
      titleLarge: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: primaryText,
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: primaryText,
      ),
      titleSmall: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: primaryText,
      ),
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        color: primaryText,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        color: primaryText,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 12,
        color: secondaryText,
      ),
      labelLarge: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: primaryText,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryText,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryText,
        minimumSize: const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
        ),
        side: const BorderSide(color: primaryText, width: 1.5),
        textStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: accent, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      hintStyle: GoogleFonts.inter(
        fontSize: 16,
        color: secondaryText.withOpacity(0.5),
      ),
    ),
    cardTheme: CardTheme(
      color: cardBackground,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),
  );
}

// Visual Themes for verse cards
class VisualTheme {
  final String id;
  final String name;
  final String category; // 'nature', 'plain', 'gradient', 'elegant'
  final List<Color> gradientColors;
  final Color textColor;
  final String? fontFamily;
  final bool isPremium;
  final bool isVideo;
  final String? backgroundImage;

  const VisualTheme({
    required this.id,
    required this.name,
    required this.category,
    required this.gradientColors,
    this.textColor = Colors.white,
    this.fontFamily,
    this.isPremium = false,
    this.isVideo = false,
    this.backgroundImage,
  });

  LinearGradient get gradient => LinearGradient(
    colors: gradientColors,
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  /// Returns true if this theme has a background image
  bool get hasBackgroundImage => backgroundImage != null;
}

class VisualThemes {
  static const String _bgPath = 'assets/images/backgrounds/';

  // Theme categories
  static const List<String> categories = ['All', 'Nature', 'Plain', 'Gradient', 'Elegant'];

  static const List<VisualTheme> all = [
    // Nature themes
    VisualTheme(
      id: 'golden_water',
      name: 'Golden Water',
      category: 'Nature',
      gradientColors: [Color(0xFF2C1810), Color(0xFF8B6914), Color(0xFF2C1810)],
      backgroundImage: '${_bgPath}golden_water.png',
      isVideo: true,
    ),
    VisualTheme(
      id: 'ocean_calm',
      name: 'Ocean Calm',
      category: 'Nature',
      gradientColors: [Color(0xFF4facfe), Color(0xFF00f2fe)],
      backgroundImage: '${_bgPath}ocean_calm.png',
    ),
    VisualTheme(
      id: 'forest_mist',
      name: 'Forest Mist',
      category: 'Nature',
      gradientColors: [Color(0xFF134e5e), Color(0xFF71b280)],
      backgroundImage: '${_bgPath}forest_mist.png',
    ),
    VisualTheme(
      id: 'mountain_sunrise',
      name: 'Mountain Sunrise',
      category: 'Nature',
      gradientColors: [Color(0xFFFF512F), Color(0xFFDD2476)],
      backgroundImage: '${_bgPath}mountain_sunrise.png',
      isPremium: true,
    ),
    VisualTheme(
      id: 'peaceful_green',
      name: 'Peaceful Green',
      category: 'Nature',
      gradientColors: [Color(0xFF56ab2f), Color(0xFFa8e6cf)],
      backgroundImage: '${_bgPath}peaceful_green.png',
      isPremium: true,
    ),
    // Gradient themes
    VisualTheme(
      id: 'sunset_sky',
      name: 'Sunset Sky',
      category: 'Gradient',
      gradientColors: [Color(0xFF667eea), Color(0xFF764ba2), Color(0xFFf093fb)],
      backgroundImage: '${_bgPath}sunset_sky.png',
    ),
    VisualTheme(
      id: 'warm_dawn',
      name: 'Warm Dawn',
      category: 'Gradient',
      gradientColors: [Color(0xFFffecd2), Color(0xFFfcb69f)],
      textColor: Color(0xFF2D2D2D),
      backgroundImage: '${_bgPath}warm_dawn.png',
    ),
    VisualTheme(
      id: 'purple_haze',
      name: 'Purple Haze',
      category: 'Gradient',
      gradientColors: [Color(0xFF4a00e0), Color(0xFF8e2de2)],
      backgroundImage: '${_bgPath}purple_haze.png',
      isPremium: true,
    ),
    VisualTheme(
      id: 'rose_gold',
      name: 'Rose Gold',
      category: 'Gradient',
      gradientColors: [Color(0xFFf4c4f3), Color(0xFFfc67fa)],
      textColor: Color(0xFF2D2D2D),
      backgroundImage: '${_bgPath}rose_gold.png',
      isPremium: true,
    ),
    // Plain themes
    VisualTheme(
      id: 'cream_simple',
      name: 'Cream',
      category: 'Plain',
      gradientColors: [Color(0xFFF5EDE4), Color(0xFFEDE5DC)],
      textColor: Color(0xFF2D2D2D),
      backgroundImage: '${_bgPath}cream_simple.png',
    ),
    // Elegant themes
    VisualTheme(
      id: 'midnight',
      name: 'Midnight',
      category: 'Elegant',
      gradientColors: [Color(0xFF0f0c29), Color(0xFF302b63), Color(0xFF24243e)],
      backgroundImage: '${_bgPath}midnight.png',
      isPremium: true,
    ),
    VisualTheme(
      id: 'dark_elegant',
      name: 'Dark Elegant',
      category: 'Elegant',
      gradientColors: [Color(0xFF1a1a2e), Color(0xFF16213e)],
      backgroundImage: '${_bgPath}dark_elegant.png',
      isPremium: true,
    ),
  ];

  static VisualTheme getById(String id) {
    return all.firstWhere(
      (t) => t.id == id,
      orElse: () => all.first,
    );
  }

  static List<VisualTheme> getByCategory(String category) {
    if (category == 'All') return all;
    return all.where((t) => t.category == category).toList();
  }
}
