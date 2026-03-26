import WidgetKit
import SwiftUI

// MARK: - Widget Placeholder

struct RoaCalendarWidget: Widget {
    let kind: String = "RoaCalendarWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            RoaCalendarWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("로아 캘린더")
        .description("오늘 일정을 확인하세요.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        completion(SimpleEntry(date: Date()))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> Void) {
        let entry = SimpleEntry(date: Date())
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
}

struct RoaCalendarWidgetEntryView: View {
    var entry: SimpleEntry

    var body: some View {
        Text("로아 캘린더")
            .font(.headline)
    }
}
