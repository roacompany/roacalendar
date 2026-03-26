import SwiftData
import Foundation

// MARK: - 사용자 캘린더 모델 (Core, 유일한 분류 체계)

@Model
final class RoaCalendar {
    var id: UUID
    var title: String
    var colorRawValue: Int
    var isDefault: Bool
    var isReadOnly: Bool
    var sortOrder: Int
    var createdAt: Date

    // MARK: - 계산 프로퍼티

    var eventColor: EventColor {
        get { EventColor(rawValue: colorRawValue) ?? .blueberry }
        set { colorRawValue = newValue.rawValue }
    }

    // MARK: - 초기화

    init(
        title: String,
        color: EventColor = .blueberry,
        isDefault: Bool = false,
        isReadOnly: Bool = false,
        sortOrder: Int = 0
    ) {
        self.id = UUID()
        self.title = title
        self.colorRawValue = color.rawValue
        self.isDefault = isDefault
        self.isReadOnly = isReadOnly
        self.sortOrder = sortOrder
        self.createdAt = Date()
    }
}
