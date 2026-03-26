import SwiftData
import Foundation

// MARK: - 서브태스크 모델 (1단계만, 재귀 금지)

@Model
final class SubtaskModel {
    var id: UUID
    var title: String
    var isCompleted: Bool
    var sortOrder: Int

    // MARK: - 관계

    var parentTask: TaskModel?

    // MARK: - 초기화

    init(title: String, parentTask: TaskModel? = nil, sortOrder: Int = 0) {
        self.id = UUID()
        self.title = title
        self.isCompleted = false
        self.sortOrder = sortOrder
        self.parentTask = parentTask
    }
}
