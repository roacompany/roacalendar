import SwiftUI
import SwiftData

@main
struct RoaCalendarApp: App {
    let container: ModelContainer

    init() {
        let schema = Schema([
            // Core 공유 모델
        ])
        let config = ModelConfiguration(
            schema: schema,
            groupContainer: .identifier("group.com.roacompany.roacalendar")
        )
        do {
            container = try ModelContainer(for: schema, configurations: [config])
        } catch {
            fatalError("ModelContainer 초기화 실패: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(container)
    }
}
