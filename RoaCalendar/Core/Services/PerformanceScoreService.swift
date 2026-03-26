import SwiftData
import Foundation

// MARK: - 일일 성과 점수 서비스 (Core)

@MainActor
final class PerformanceScoreService {
    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    // MARK: - 일일 성과 점수 계산

    struct DailyScore {
        let pomodoroScore: Double?  // 0.0 ~ 1.0
        let todoScore: Double?       // 0.0 ~ 1.0
        let calendarScore: Double?   // 0.0 ~ 1.0
        let composite: Double?       // 가중 평균

        var displayPercent: Int? {
            guard let c = composite else { return nil }
            return Int(c * 100)
        }
    }

    func calculateTodayScore() -> DailyScore {
        let todoScore = calculateTodoScore()
        let calendarScore = calculateCalendarScore()
        // 뽀모도로 점수는 PomodoroLogService에서 가져옴 (미구현)
        let pomodoroScore: Double? = nil

        let composite = calculateComposite(
            pomodoro: pomodoroScore,
            todo: todoScore,
            calendar: calendarScore
        )

        return DailyScore(
            pomodoroScore: pomodoroScore,
            todoScore: todoScore,
            calendarScore: calendarScore,
            composite: composite
        )
    }

    // MARK: - Todo 완료율

    private func calculateTodoScore() -> Double? {
        let today = Date().startOfDay
        let tomorrow = today.adding(days: 1)

        let completedRaw = TaskStatus.completed.rawValue
        let trashedRaw = TaskStatus.trashed.rawValue

        let descriptor = FetchDescriptor<TaskModel>(
            predicate: #Predicate<TaskModel> { task in
                task.status.rawValue != trashedRaw
            }
        )

        let allTasks = (try? context.fetch(descriptor)) ?? []

        let todayTasks = allTasks.filter { task in
            if let planned = task.plannedDate, planned >= today, planned < tomorrow { return true }
            if let due = task.dueDate, due < tomorrow { return true }
            return false
        }

        guard !todayTasks.isEmpty else { return nil }

        let completed = todayTasks.filter { $0.status == .completed }.count
        return Double(completed) / Double(todayTasks.count)
    }

    // MARK: - 캘린더 참석률

    private func calculateCalendarScore() -> Double? {
        let service = CalendarQueryService(context: context)
        let result = service.todayAttendedCount()

        guard result.total > 0 else { return nil }
        return Double(result.attended) / Double(result.total)
    }

    // MARK: - 가중 합산 (활동 없는 도메인 제외 후 재계산)

    private func calculateComposite(pomodoro: Double?, todo: Double?, calendar: Double?) -> Double? {
        var weights: [(Double, Double)] = []

        if let p = pomodoro { weights.append((p, 0.4)) }
        if let t = todo { weights.append((t, 0.4)) }
        if let c = calendar { weights.append((c, 0.2)) }

        guard !weights.isEmpty else { return nil }

        let totalWeight = weights.reduce(0.0) { $0 + $1.1 }
        let weightedSum = weights.reduce(0.0) { $0 + $1.0 * $1.1 }

        return weightedSum / totalWeight
    }
}
