import SwiftData
import Foundation

// MARK: - 프로젝트 상태

enum ProjectStatus: Int, Codable {
    case active = 0
    case onHold = 1
    case completed = 2
}

// MARK: - 프로젝트 모델

@Model
final class ProjectModel {
    var id: UUID
    var title: String
    var notes: String?
    var status: ProjectStatus
    var dueDate: Date?
    var sortOrder: Int
    var createdAt: Date
    var modifiedAt: Date

    // MARK: - 관계

    var calendar: RoaCalendar?

    // MARK: - 초기화

    init(
        title: String,
        calendar: RoaCalendar? = nil
    ) {
        self.id = UUID()
        self.title = title
        self.status = .active
        self.sortOrder = 0
        self.createdAt = Date()
        self.modifiedAt = Date()
        self.calendar = calendar
    }
}
