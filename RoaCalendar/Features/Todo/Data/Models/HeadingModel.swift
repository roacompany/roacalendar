import SwiftData
import Foundation

// MARK: - Heading 모델 (Project 내 Task 컨테이너)

@Model
final class HeadingModel {
    var id: UUID
    var title: String
    var sortOrder: Int

    // MARK: - 관계

    var project: ProjectModel?

    // MARK: - 초기화

    init(title: String, project: ProjectModel? = nil, sortOrder: Int = 0) {
        self.id = UUID()
        self.title = title
        self.sortOrder = sortOrder
        self.project = project
    }
}
