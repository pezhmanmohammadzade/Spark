import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), level: 5, streak: 3)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), level: 5, streak: 3)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        let currentDate = Date()
        let entry = SimpleEntry(date: currentDate, level: 5, streak: 3)
        entries.append(entry)

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let level: Int
    let streak: Int
}

struct SparkWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("SPARK")
                    .font(.system(size: 10, weight: .black))
                    .tracking(1)
                Spacer()
                Text("LVL \(entry.level)")
                    .font(.system(size: 10, weight: .bold))
            }
            .foregroundColor(.white.opacity(0.6))
            
            Spacer()
            
            Text("\(entry.streak)")
                .font(.system(size: 36, weight: .black))
                .foregroundColor(.white)
            Text("DAY STREAK")
                .font(.system(size: 8, weight: .bold))
                .foregroundColor(.blue)
        }
        .padding()
        .containerBackground(for: .widget) {
            Color(red: 0.02, green: 0.03, blue: 0.08)
        }
    }
}

struct SparkWidget: Widget {
    let kind: String = "SparkWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            SparkWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Spark Vitals")
        .description("Track your mission progress at a glance.")
        .supportedFamilies([.systemSmall])
    }
}
