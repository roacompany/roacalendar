import SwiftData
import Foundation

// MARK: - Task CRUD 서비스 (Core — Calendar + Todo 공유)

@MainActor
final class TaskService {
    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    // MARK: - 생성

    func createTask(
        title: String,
        taskKind: TaskKind = .task,
        calendar: RoaCalendar? = nil
    ) -> TaskModel {
        let task = TaskModel(title: title, taskKind: taskKind, calendar: calendar)

        if task.calendar == nil {
            task.calendar = fetchDefaultCalendar()
        }

        context.insert(task)
        try? context.save()
        return task
    }

    // MARK: - 조회

    func fetchTodayTasks() -> [TaskModel] {
        let completedRaw = TaskStatus.completed.rawValue
        let trashedRaw = TaskStatus.trashed.rawValue

        let descriptor = FetchDescriptor<TaskModel>(
            predicate: #Predicate<TaskModel> { task in
                task.status.rawValue != completedRaw &&
                task.status.rawValue != trashedRaw
            },
            sortBy: [SortDescriptor(\.sortOrder)]
        )

        let allTasks = (try? context.fetch(descriptor)) ?? []
        let today = Date().startOfDay
        let tomorrow = today.adding(days: 1)

        return allTasks.filter { task in
            if let planned = task.plannedDate, planned >= today, planned < tomorrow { return true }
            if let due = task.dueDate, due < tomorrow { return true }
            return false
        }
    }

    func fetchInboxTasks() -> [TaskModel] {
        let inboxRaw = TaskStatus.inbox.rawValue
        let descriptor = FetchDescriptor<TaskModel>(
            predicate: #Predicate<TaskModel> { task in
                task.status.rawValue == inboxRaw
            },
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
        )
        return (try? context.fetch(descriptor)) ?? []
    }

    func fetchActiveTasks() -> [TaskModel] {
        let activeRaw = TaskStatus.active.rawValue
        let descriptor = FetchDescriptor<TaskModel>(
            predicate: #Predicate<TaskModel> { task in
                task.status.rawValue == activeRaw
            },
            sortBy: [SortDescriptor(\.sortOrder)]
        )
        return (try? context.fetch(descriptor)) ?? []
    }

    // MARK: - 상태 변경

    func completeTask(_ task: TaskModel) {
        task.status = .completed
        task.completedAt = Date()
        task.modifiedAt = Date()
        try? context.save()
    }

    func trashTask(_ task: TaskModel) {
        task.status = .trashed
        task.trashedAt = Date()
        task.modifiedAt = Date()
        try? context.save()
    }

    func activateTask(_ task: TaskModel) {
        task.status = .active
        task.modifiedAt = Date()
        try? context.save()
    }

    func somedayTask(_ task: TaskModel) {
        task.status = .someday
        task.modifiedAt = Date()
        try? context.save()
    }

    // MARK: - 삭제 (영구)

    func permanentlyDelete(_ task: TaskModel) {
        context.delete(task)
        try? context.save()
    }

    // MARK: - 기본 캘린더

    func fetchDefaultCalendar() -> RoaCalendar? {
        let descriptor = FetchDescriptor<RoaCalendar>(
            predicate: #Predicate<RoaCalendar> { $0.isDefault }
        )
        return try? context.fetch(descriptor).first
    }
}
