import SwiftData
import Foundation

// MARK: - 알림 타입 (Core, Calendar + Todo 공유)

enum ReminderType: Int, Codable {
    case relative = 0   // N분 전
    case absolute = 1   // 특정 시각
}

@Model
final class Reminder {
    var id: UUID
    var type: ReminderType
    var offsetMinutes: Int?
    var absoluteDate: Date?

    init(type: ReminderType, offsetMinutes: Int? = nil, absoluteDate: Date? = nil) {
        self.id = UUID()
        self.type = type
        self.offsetMinutes = offsetMinutes
        self.absoluteDate = absoluteDate
    }

    // MARK: - 편의 생성자

    static func relative(minutes: Int) -> Reminder {
        Reminder(type: .relative, offsetMinutes: minutes)
    }

    static func absolute(date: Date) -> Reminder {
        Reminder(type: .absolute, absoluteDate: date)
    }
}
