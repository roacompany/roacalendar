import SwiftData
import Foundation

// MARK: - 반복 규칙 (Core, Calendar + Todo 공유)

enum RecurrenceFrequency: Int, Codable {
    case daily = 0
    case weekly = 1
    case monthly = 2
    case yearly = 3
}

enum RecurrenceEndType: Int, Codable {
    case never = 0
    case afterCount = 1
    case onDate = 2
}

@Model
final class RecurrenceRule {
    var id: UUID
    var frequency: RecurrenceFrequency
    var interval: Int
    var daysOfWeek: [Int]?
    var dayOfMonth: Int?
    var nthWeekday: Int?
    var endType: RecurrenceEndType
    var endCount: Int?
    var endDate: Date?
    var isCompletionBased: Bool

    init(
        frequency: RecurrenceFrequency,
        interval: Int = 1,
        daysOfWeek: [Int]? = nil,
        dayOfMonth: Int? = nil,
        nthWeekday: Int? = nil,
        endType: RecurrenceEndType = .never,
        endCount: Int? = nil,
        endDate: Date? = nil,
        isCompletionBased: Bool = false
    ) {
        self.id = UUID()
        self.frequency = frequency
        self.interval = interval
        self.daysOfWeek = daysOfWeek
        self.dayOfMonth = dayOfMonth
        self.nthWeekday = nthWeekday
        self.endType = endType
        self.endCount = endCount
        self.endDate = endDate
        self.isCompletionBased = isCompletionBased
    }

    // MARK: - 프리셋

    static var daily: RecurrenceRule {
        RecurrenceRule(frequency: .daily)
    }

    static func weekly(on days: [Int]) -> RecurrenceRule {
        RecurrenceRule(frequency: .weekly, daysOfWeek: days)
    }

    static var weekdays: RecurrenceRule {
        RecurrenceRule(frequency: .weekly, daysOfWeek: [2, 3, 4, 5, 6])
    }

    static var monthly: RecurrenceRule {
        RecurrenceRule(frequency: .monthly)
    }

    static var yearly: RecurrenceRule {
        RecurrenceRule(frequency: .yearly)
    }
}
