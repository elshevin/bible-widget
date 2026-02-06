import WidgetKit
import SwiftUI

// MARK: - Widget Entry
struct BibleWidgetEntry: TimelineEntry {
    let date: Date
    let verse: String
    let reference: String
    let startColor: String
    let endColor: String
    let verseId: String
}

// MARK: - Timeline Provider
struct BibleWidgetProvider: TimelineProvider {
    // App Group ID - MUST match exactly with Flutter's HomeWidget.setAppGroupId()
    static let appGroupId = "group.com.oneapp.bibleWidgets"

    func placeholder(in context: Context) -> BibleWidgetEntry {
        BibleWidgetEntry(
            date: Date(),
            verse: "For God so loved the world that he gave his one and only Son, that whoever believes in him shall not perish but have eternal life.",
            reference: "John 3:16",
            startColor: "#c9a962",
            endColor: "#d4b574",
            verseId: ""
        )
    }

    func getSnapshot(in context: Context, completion: @escaping (BibleWidgetEntry) -> Void) {
        let entry = getEntryFromDefaults()
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<BibleWidgetEntry>) -> Void) {
        let entry = getEntryFromDefaults()
        // Update every 30 minutes
        let nextUpdate = Calendar.current.date(byAdding: .minute, value: 30, to: Date())!
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
        completion(timeline)
    }

    private func getEntryFromDefaults() -> BibleWidgetEntry {
        // Create fresh UserDefaults instance each time to ensure we get latest data
        guard let sharedDefaults = UserDefaults(suiteName: BibleWidgetProvider.appGroupId) else {
            // Return default entry if App Group is not available
            return BibleWidgetEntry(
                date: Date(),
                verse: "Trust in the LORD with all your heart and lean not on your own understanding.",
                reference: "Proverbs 3:5",
                startColor: "#c9a962",
                endColor: "#d4b574",
                verseId: ""
            )
        }

        // Force synchronize to get latest data from disk
        sharedDefaults.synchronize()

        // Keys match Flutter's HomeWidget.saveWidgetData() calls
        let verse = sharedDefaults.string(forKey: "widget_verse_text") ?? "Trust in the LORD with all your heart and lean not on your own understanding."
        let reference = sharedDefaults.string(forKey: "widget_verse_reference") ?? "Proverbs 3:5"

        // Get theme colors from Flutter - these should be set by WidgetService.updateWidgetTheme()
        let startColor = sharedDefaults.string(forKey: "widget_start_color") ?? "#c9a962"
        let endColor = sharedDefaults.string(forKey: "widget_end_color") ?? "#d4b574"

        // Get verse ID for deep link navigation
        let verseId = sharedDefaults.string(forKey: "widget_verse_id") ?? ""

        return BibleWidgetEntry(
            date: Date(),
            verse: verse,
            reference: reference,
            startColor: startColor,
            endColor: endColor,
            verseId: verseId
        )
    }
}

// MARK: - Widget View
struct BibleWidgetEntryView: View {
    var entry: BibleWidgetProvider.Entry
    @Environment(\.widgetFamily) var widgetFamily
    var showBackground: Bool = true

    // Build URL for deep linking to specific verse
    private var widgetURL: URL {
        let urlString = "biblewidgets://verse?id=\(entry.verseId)"
        return URL(string: urlString) ?? URL(string: "biblewidgets://")!
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Verse text
            Text(entry.verse)
                .font(verseFontSize)
                .fontWeight(.medium)
                .foregroundColor(.white)
                .lineLimit(lineLimit)
                .minimumScaleFactor(0.7)

            Spacer()

            // Reference
            HStack {
                Spacer()
                Text(entry.reference)
                    .font(referenceFontSize)
                    .fontWeight(.semibold)
                    .foregroundColor(.white.opacity(0.9))
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .widgetURL(widgetURL)
        .background {
            if showBackground {
                LinearGradient(
                    colors: [Color(hex: entry.startColor), Color(hex: entry.endColor)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            }
        }
    }

    private var verseFontSize: Font {
        switch widgetFamily {
        case .systemSmall:
            return .system(size: 13)
        case .systemMedium:
            return .system(size: 15)
        case .systemLarge:
            return .system(size: 18)
        default:
            return .system(size: 14)
        }
    }

    private var referenceFontSize: Font {
        switch widgetFamily {
        case .systemSmall:
            return .system(size: 11)
        case .systemMedium:
            return .system(size: 12)
        case .systemLarge:
            return .system(size: 14)
        default:
            return .system(size: 12)
        }
    }

    private var lineLimit: Int {
        switch widgetFamily {
        case .systemSmall:
            return 5
        case .systemMedium:
            return 3
        case .systemLarge:
            return 10
        default:
            return 4
        }
    }
}

// MARK: - Color Extension
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - Widget Configuration
@main
struct BibleWidget: Widget {
    let kind: String = "BibleWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: BibleWidgetProvider()) { entry in
            if #available(iOS 17.0, *) {
                BibleWidgetEntryView(entry: entry, showBackground: false)
                    .containerBackground(for: .widget) {
                        LinearGradient(
                            colors: [Color(hex: entry.startColor), Color(hex: entry.endColor)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    }
            } else {
                BibleWidgetEntryView(entry: entry, showBackground: true)
            }
        }
        .configurationDisplayName("Bible Verse")
        .description("Display daily Bible verses on your home screen.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

