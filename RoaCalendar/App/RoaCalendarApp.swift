import SwiftUI
import SwiftData

@main
struct RoaCalendarApp: App {
    let container: ModelContainer
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false

    init() {
        let schema = Schema([
            RoaCalendar.self,
            Reminder.self,
            RecurrenceRule.self,
            CalendarEventModel.self,
            TaskModel.self,
            ProjectModel.self,
            HeadingModel.self,
            SubtaskModel.self
        ])
        // App Group은 Widget 추가 시 활성화 (v1.1)
        let config = ModelConfiguration(schema: schema)
        do {
            container = try ModelContainer(for: schema, configurations: [config])
        } catch {
            fatalError("ModelContainer 초기화 실패: \(error)")
        }

        // 기본 캘린더 초기화
        let context = container.mainContext
        CalendarInitService.createDefaultCalendars(context: context)
    }

    var body: some Scene {
        WindowGroup {
            if hasCompletedOnboarding {
                ContentView()
            } else {
                OnboardingView(hasCompletedOnboarding: $hasCompletedOnboarding)
            }
        }
        .modelContainer(container)
    }
}
