import SwiftUI
import SwiftData
import Observation

// MARK: - Todo Today ViewModel

@MainActor
@Observable
final class TodoTodayViewModel {

    // MARK: - 스마트 뷰 탭

    enum SmartView: String, CaseIterable {
        case inbox = "Inbox"
        case today = "오늘"
        case upcoming = "예정"
        case anytime = "언제든"
        case someday = "나중에"
        case flagged = "깃발"
    }

    var selectedView: SmartView = .today
    var tasks: [TaskModel] = []

    // MARK: - 데이터 로드

    func loadTasks(context: ModelContext) {
        let service = TaskService(context: context)
        switch selectedView {
        case .inbox:
            tasks = service.fetchInboxTasks()
        case .today:
            tasks = service.fetchTodayTasks()
        case .anytime:
            tasks = service.fetchActiveTasks()
        default:
            tasks = service.fetchActiveTasks()
        }
    }

    // MARK: - Task 완료

    func toggleComplete(_ task: TaskModel, context: ModelContext) {
        let service = TaskService(context: context)
        if task.status == .completed {
            service.activateTask(task)
        } else {
            service.completeTask(task)
        }
        loadTasks(context: context)
    }

    // MARK: - Quick Add

    func quickAdd(title: String, context: ModelContext) {
        guard !title.isEmpty else { return }
        let service = TaskService(context: context)
        _ = service.createTask(title: title)
        loadTasks(context: context)
    }

    // MARK: - 통계

    var taskCount: Int { tasks.count }

    var estimatedHours: Double {
        let totalMinutes = tasks.compactMap(\.estimatedDuration).reduce(0, +)
        return Double(totalMinutes) / 60.0
    }

    var freeHours: Double { 5.0 } // TODO: CalendarQueryService에서 계산

    var isOverloaded: Bool { estimatedHours > freeHours }

    var loadSummary: String {
        "📊 \(taskCount)개 Task · 예상 ~\(String(format: "%.1f", estimatedHours))시간 | 빈 시간: \(String(format: "%.1f", freeHours))시간"
    }
}
