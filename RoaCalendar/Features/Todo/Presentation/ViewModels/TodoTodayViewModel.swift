import SwiftUI
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
    var taskCount: Int = 8
    var estimatedHours: Double = 4.5
    var freeHours: Double = 5.0

    var isOverloaded: Bool { estimatedHours > freeHours }

    var loadSummary: String {
        "📊 \(taskCount)개 Task · 예상 ~\(String(format: "%.1f", estimatedHours))시간 | 빈 시간: \(String(format: "%.1f", freeHours))시간"
    }
}
