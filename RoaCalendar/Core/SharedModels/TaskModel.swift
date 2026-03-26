import SwiftData
import Foundation

// MARK: - Task 상태

enum TaskStatus: Int, Codable {
    case inbox = 0
    case active = 1
    case someday = 2
    case completed = 3
    case trashed = 4
}

// MARK: - Task 종류

enum TaskKind: Int, Codable {
    case task = 0
    case reminder = 1
}

// MARK: - 우선순위

enum Priority: Int, Codable, CaseIterable {
    case none = 0
    case low = 1
    case medium = 2
    case high = 3
}

// MARK: - Task 모델 (Core 공유 — Calendar + Todo)

@Model
final class TaskModel {
    var id: UUID
    var title: String
    var notes: String?
    var status: TaskStatus
    var taskKind: TaskKind
    var priorityRawValue: Int
    var isUrgent: Bool
    var isFlagged: Bool

    // MARK: - 날짜 (3종)

    var deferDate: Date?
    var plannedDate: Date?
    var dueDate: Date?

    // MARK: - 뽀모도로 연동

    var estimatedPomodoros: Int?
    var completedPomodoros: Int
    var estimatedDuration: Int?

    // MARK: - 태그 (JSON 저장)

    var tagsData: Data?

    // MARK: - 정렬/메타

    var sortOrder: Int
    var completedAt: Date?
    var trashedAt: Date?
    var createdAt: Date
    var modifiedAt: Date

    // MARK: - 관계

    var calendar: RoaCalendar?
    var project: ProjectModel?
    var heading: HeadingModel?
    var recurrenceRule: RecurrenceRule?
    var reminders: [Reminder]?

    // MARK: - 계산 프로퍼티

    var priority: Priority {
        get { Priority(rawValue: priorityRawValue) ?? .none }
        set { priorityRawValue = newValue.rawValue }
    }

    var tags: [String] {
        get {
            guard let data = tagsData else { return [] }
            return (try? JSONDecoder().decode([String].self, from: data)) ?? []
        }
        set {
            tagsData = try? JSONEncoder().encode(newValue)
        }
    }

    var isOverdue: Bool {
        guard let due = dueDate, status != .completed, status != .trashed else { return false }
        return due < Date()
    }

    // MARK: - 초기화

    init(
        title: String,
        taskKind: TaskKind = .task,
        calendar: RoaCalendar? = nil
    ) {
        self.id = UUID()
        self.title = title
        self.status = .inbox
        self.taskKind = taskKind
        self.priorityRawValue = Priority.none.rawValue
        self.isUrgent = false
        self.isFlagged = false
        self.completedPomodoros = 0
        self.sortOrder = 0
        self.createdAt = Date()
        self.modifiedAt = Date()
        self.calendar = calendar
    }
}
