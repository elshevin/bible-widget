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
    cardTheme: CardThemeData(
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
  final String? lottieAsset; // Local Lottie animation asset path

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
    this.lottieAsset,
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
    ),
    VisualTheme(
      id: 'peaceful_green',
      name: 'Peaceful Green',
      category: 'Nature',
      gradientColors: [Color(0xFF56ab2f), Color(0xFFa8e6cf)],
      backgroundImage: '${_bgPath}peaceful_green.png',
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
    ),
    VisualTheme(
      id: 'rose_gold',
      name: 'Rose Gold',
      category: 'Gradient',
      gradientColors: [Color(0xFFf4c4f3), Color(0xFFfc67fa)],
      textColor: Color(0xFF2D2D2D),
      backgroundImage: '${_bgPath}rose_gold.png',
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
    ),
    VisualTheme(
      id: 'dark_elegant',
      name: 'Dark Elegant',
      category: 'Elegant',
      gradientColors: [Color(0xFF1a1a2e), Color(0xFF16213e)],
      backgroundImage: '${_bgPath}dark_elegant.png',
    ),
    // New Gradient themes
    VisualTheme(
      id: 'peach_coral',
      name: 'Peach Coral',
      category: 'Gradient',
      gradientColors: [Color(0xFFFFB8A0), Color(0xFFFF8B6A)],
      textColor: Color(0xFF2D2D2D),
      backgroundImage: '${_bgPath}peach_coral.png',
    ),
    VisualTheme(
      id: 'lavender_dream',
      name: 'Lavender Dream',
      category: 'Gradient',
      gradientColors: [Color(0xFFE6E6FA), Color(0xFF9BB5E0)],
      textColor: Color(0xFF2D2D2D),
      backgroundImage: '${_bgPath}lavender_dream.png',
    ),
    VisualTheme(
      id: 'amber_honey',
      name: 'Amber Honey',
      category: 'Gradient',
      gradientColors: [Color(0xFFFFC107), Color(0xFFFF8F00)],
      textColor: Color(0xFF2D2D2D),
      backgroundImage: '${_bgPath}amber_honey.png',
    ),
    VisualTheme(
      id: 'mint_serenity',
      name: 'Mint Serenity',
      category: 'Gradient',
      gradientColors: [Color(0xFF98D8C8), Color(0xFF16A085)],
      backgroundImage: '${_bgPath}mint_serenity.png',
    ),
    // New Nature themes
    VisualTheme(
      id: 'cherry_blossom',
      name: 'Cherry Blossom',
      category: 'Nature',
      gradientColors: [Color(0xFFFFB7C5), Color(0xFFFF69B4)],
      textColor: Color(0xFF2D2D2D),
      backgroundImage: '${_bgPath}cherry_blossom.png',
    ),
    VisualTheme(
      id: 'wheat_sunset',
      name: 'Wheat Sunset',
      category: 'Nature',
      gradientColors: [Color(0xFFF5DEB3), Color(0xFFD4A76A)],
      textColor: Color(0xFF2D2D2D),
      backgroundImage: '${_bgPath}wheat_sunset.png',
    ),
    VisualTheme(
      id: 'misty_mountains',
      name: 'Misty Mountains',
      category: 'Nature',
      gradientColors: [Color(0xFF8E9AAF), Color(0xFF5C6378)],
      backgroundImage: '${_bgPath}misty_mountains.png',
    ),
    VisualTheme(
      id: 'calm_lake',
      name: 'Calm Lake',
      category: 'Nature',
      gradientColors: [Color(0xFF87CEEB), Color(0xFF4682B4)],
      backgroundImage: '${_bgPath}calm_lake.png',
    ),
    // New Elegant dark themes
    VisualTheme(
      id: 'navy_stars',
      name: 'Navy Stars',
      category: 'Elegant',
      gradientColors: [Color(0xFF0D1B2A), Color(0xFF1B263B)],
      backgroundImage: '${_bgPath}navy_stars.png',
    ),
    VisualTheme(
      id: 'burgundy_wine',
      name: 'Burgundy Wine',
      category: 'Elegant',
      gradientColors: [Color(0xFF4A0E0E), Color(0xFF722F37)],
      backgroundImage: '${_bgPath}burgundy_wine.png',
    ),
    VisualTheme(
      id: 'charcoal_marble',
      name: 'Charcoal Marble',
      category: 'Elegant',
      gradientColors: [Color(0xFF36454F), Color(0xFF2F4F4F)],
      backgroundImage: '${_bgPath}charcoal_marble.png',
    ),
    VisualTheme(
      id: 'forest_moonlight',
      name: 'Forest Moonlight',
      category: 'Elegant',
      gradientColors: [Color(0xFF1A3A1A), Color(0xFF2E4A2E)],
      backgroundImage: '${_bgPath}forest_moonlight.png',
    ),
    // New Plain/Warm themes
    VisualTheme(
      id: 'beige_linen',
      name: 'Beige Linen',
      category: 'Plain',
      gradientColors: [Color(0xFFF5F5DC), Color(0xFFE8DCC8)],
      textColor: Color(0xFF2D2D2D),
      backgroundImage: '${_bgPath}beige_linen.png',
    ),
    VisualTheme(
      id: 'sand_rays',
      name: 'Sand Rays',
      category: 'Plain',
      gradientColors: [Color(0xFFF4E4C1), Color(0xFFE6D5A8)],
      textColor: Color(0xFF2D2D2D),
      backgroundImage: '${_bgPath}sand_rays.png',
    ),
    VisualTheme(
      id: 'yellow_bokeh',
      name: 'Yellow Bokeh',
      category: 'Plain',
      gradientColors: [Color(0xFFFFF9E6), Color(0xFFFFF176)],
      textColor: Color(0xFF2D2D2D),
      backgroundImage: '${_bgPath}yellow_bokeh.png',
    ),
    VisualTheme(
      id: 'cream_watercolor',
      name: 'Cream Watercolor',
      category: 'Plain',
      gradientColors: [Color(0xFFFFFFF0), Color(0xFFF5F5F5)],
      textColor: Color(0xFF2D2D2D),
      backgroundImage: '${_bgPath}cream_watercolor.png',
    ),
    // === 20 NEW THEMES ===
    // New Nature themes (5)
    VisualTheme(
      id: 'autumn_forest',
      name: 'Autumn Forest',
      category: 'Nature',
      gradientColors: [Color(0xFFD4A76A), Color(0xFF8B4513), Color(0xFF5C4033)],
      backgroundImage: '${_bgPath}autumn_forest.png',
    ),
    VisualTheme(
      id: 'spring_meadow',
      name: 'Spring Meadow',
      category: 'Nature',
      gradientColors: [Color(0xFF87CEAB), Color(0xFF3CB371), Color(0xFF228B22)],
      backgroundImage: '${_bgPath}spring_meadow.png',
    ),
    VisualTheme(
      id: 'winter_snow',
      name: 'Winter Snow',
      category: 'Nature',
      gradientColors: [Color(0xFFE8F4F8), Color(0xFFB0C4DE), Color(0xFF708090)],
      textColor: Color(0xFF2D2D2D),
      backgroundImage: '${_bgPath}winter_snow.png',
    ),
    VisualTheme(
      id: 'tropical_sunset',
      name: 'Tropical Sunset',
      category: 'Nature',
      gradientColors: [Color(0xFFFF7F50), Color(0xFFFF6347), Color(0xFF4169E1)],
      backgroundImage: '${_bgPath}tropical_sunset.png',
    ),
    VisualTheme(
      id: 'lavender_fields',
      name: 'Lavender Fields',
      category: 'Nature',
      gradientColors: [Color(0xFFE6E6FA), Color(0xFF9370DB), Color(0xFF663399)],
      backgroundImage: '${_bgPath}lavender_fields.png',
    ),
    // New Gradient themes (5)
    VisualTheme(
      id: 'indigo_teal',
      name: 'Indigo Teal',
      category: 'Gradient',
      gradientColors: [Color(0xFF4B0082), Color(0xFF008B8B)],
      backgroundImage: '${_bgPath}indigo_teal.png',
    ),
    VisualTheme(
      id: 'coral_peach',
      name: 'Coral Peach',
      category: 'Gradient',
      gradientColors: [Color(0xFFFF7F7F), Color(0xFFFFDAB9)],
      textColor: Color(0xFF2D2D2D),
      backgroundImage: '${_bgPath}coral_peach.png',
    ),
    VisualTheme(
      id: 'ocean_deep',
      name: 'Ocean Deep',
      category: 'Gradient',
      gradientColors: [Color(0xFF000080), Color(0xFF00CED1)],
      backgroundImage: '${_bgPath}ocean_deep.png',
    ),
    VisualTheme(
      id: 'dusty_rose',
      name: 'Dusty Rose',
      category: 'Gradient',
      gradientColors: [Color(0xFFDC9A9A), Color(0xFFE6B8B8), Color(0xFFC8A2C8)],
      backgroundImage: '${_bgPath}dusty_rose.png',
    ),
    VisualTheme(
      id: 'terracotta_rust',
      name: 'Terracotta Rust',
      category: 'Gradient',
      gradientColors: [Color(0xFFE07850), Color(0xFFC45C3A), Color(0xFF8B4513)],
      backgroundImage: '${_bgPath}terracotta_rust.png',
    ),
    // New Elegant themes (5)
    VisualTheme(
      id: 'emerald_gold',
      name: 'Emerald Gold',
      category: 'Elegant',
      gradientColors: [Color(0xFF004D40), Color(0xFF00695C), Color(0xFF1B5E20)],
      backgroundImage: '${_bgPath}emerald_gold.png',
    ),
    VisualTheme(
      id: 'royal_purple',
      name: 'Royal Purple',
      category: 'Elegant',
      gradientColors: [Color(0xFF301934), Color(0xFF4A235A), Color(0xFF6B3A70)],
      backgroundImage: '${_bgPath}royal_purple.png',
    ),
    VisualTheme(
      id: 'sapphire_night',
      name: 'Sapphire Night',
      category: 'Elegant',
      gradientColors: [Color(0xFF0C1445), Color(0xFF1A237E), Color(0xFF283593)],
      backgroundImage: '${_bgPath}sapphire_night.png',
    ),
    VisualTheme(
      id: 'chocolate_bronze',
      name: 'Chocolate Bronze',
      category: 'Elegant',
      gradientColors: [Color(0xFF3E2723), Color(0xFF5D4037), Color(0xFF795548)],
      backgroundImage: '${_bgPath}chocolate_bronze.png',
    ),
    VisualTheme(
      id: 'obsidian_silver',
      name: 'Obsidian Silver',
      category: 'Elegant',
      gradientColors: [Color(0xFF1C1C1C), Color(0xFF363636), Color(0xFF4F4F4F)],
      backgroundImage: '${_bgPath}obsidian_silver.png',
    ),
    // New Plain themes (5)
    VisualTheme(
      id: 'ivory_warm',
      name: 'Ivory Warm',
      category: 'Plain',
      gradientColors: [Color(0xFFFFFFF0), Color(0xFFFAF0E6)],
      textColor: Color(0xFF2D2D2D),
      backgroundImage: '${_bgPath}ivory_warm.png',
    ),
    VisualTheme(
      id: 'rose_blush',
      name: 'Rose Blush',
      category: 'Plain',
      gradientColors: [Color(0xFFFFF0F5), Color(0xFFFFE4E1)],
      textColor: Color(0xFF2D2D2D),
      backgroundImage: '${_bgPath}rose_blush.png',
    ),
    VisualTheme(
      id: 'sage_linen',
      name: 'Sage Linen',
      category: 'Plain',
      gradientColors: [Color(0xFFE8F5E9), Color(0xFFC8E6C9)],
      textColor: Color(0xFF2D2D2D),
      backgroundImage: '${_bgPath}sage_linen.png',
    ),
    VisualTheme(
      id: 'powder_blue',
      name: 'Powder Blue',
      category: 'Plain',
      gradientColors: [Color(0xFFF0F8FF), Color(0xFFE6F2FF)],
      textColor: Color(0xFF2D2D2D),
      backgroundImage: '${_bgPath}powder_blue.png',
    ),
    VisualTheme(
      id: 'soft_peach',
      name: 'Soft Peach',
      category: 'Plain',
      gradientColors: [Color(0xFFFFF5EE), Color(0xFFFFEBD6)],
      textColor: Color(0xFF2D2D2D),
      backgroundImage: '${_bgPath}soft_peach.png',
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
