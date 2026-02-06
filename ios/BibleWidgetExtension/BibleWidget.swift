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

        // Try different key formats - home_widget may prefix keys differently
        let keyFormats = [
            // Standard keys (home_widget default)
            ["widget_verse_text", "widget_verse_reference", "widget_start_color", "widget_end_color", "widget_verse_id"],
            // With flutter prefix
            ["flutter.widget_verse_text", "flutter.widget_verse_reference", "flutter.widget_start_color", "flutter.widget_end_color", "flutter.widget_verse_id"]
        ]

        var verse: String?
        var reference: String?
        var startColor: String?
        var endColor: String?
        var verseId: String?

        for keys in keyFormats {
            let v = sharedDefaults.string(forKey: keys[0])
            if v != nil && !v!.isEmpty {
                verse = v
                reference = sharedDefaults.string(forKey: keys[1])
                startColor = sharedDefaults.string(forKey: keys[2])
                endColor = sharedDefaults.string(forKey: keys[3])
                verseId = sharedDefaults.string(forKey: keys[4])
                break
            }
        }

        return BibleWidgetEntry(
            date: Date(),
            verse: verse ?? "Trust in the LORD with all your heart and lean not on your own understanding.",
            reference: reference ?? "Proverbs 3:5",
            startColor: startColor ?? "#c9a962",
            endColor: endColor ?? "#d4b574",
            verseId: verseId ?? ""
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

