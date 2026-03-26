import SwiftData
import Foundation

// MARK: - 캘린더 이벤트 모델 (.event 전용)

@Model
final class CalendarEventModel {
    var id: UUID
    var title: String
    var isAllDay: Bool
    var startDate: Date
    var endDate: Date
    var timeZoneIdentifier: String?
    var locationText: String?
    var latitude: Double?
    var longitude: Double?
    var locationName: String?
    var url: String?
    var notes: String?
    var colorRawValue: Int?
    var isAttended: Bool
    var sortOrder: Int
    var createdAt: Date
    var modifiedAt: Date

    // MARK: - 관계

    var calendar: RoaCalendar?
    var recurrenceRule: RecurrenceRule?
    var reminders: [Reminder]?

    // MARK: - 반복 이벤트 원본 참조 (JSON 저장)

    var originalEventData: Data?

    // MARK: - 반복 예외 날짜 (JSON 저장)

    var exceptionDatesData: Data?

    // MARK: - 계산 프로퍼티

    var eventColor: EventColor? {
        get {
            guard let raw = colorRawValue else { return nil }
            return EventColor(rawValue: raw)
        }
        set { colorRawValue = newValue?.rawValue }
    }

    var displayColor: EventColor {
        eventColor ?? (calendar.flatMap { EventColor(rawValue: $0.colorRawValue) } ?? .blueberry)
    }

    var originalEvent: OriginalEvent? {
        get {
            guard let data = originalEventData else { return nil }
            return try? JSONDecoder().decode(OriginalEvent.self, from: data)
        }
        set {
            originalEventData = try? JSONEncoder().encode(newValue)
        }
    }

    var exceptionDates: [Date] {
        get {
            guard let data = exceptionDatesData else { return [] }
            return (try? JSONDecoder().decode([Date].self, from: data)) ?? []
        }
        set {
            exceptionDatesData = try? JSONEncoder().encode(newValue)
        }
    }

    // MARK: - 초기화

    init(
        title: String,
        isAllDay: Bool = false,
        startDate: Date,
        endDate: Date,
        calendar: RoaCalendar? = nil
    ) {
        self.id = UUID()
        self.title = title
        self.isAllDay = isAllDay
        self.startDate = startDate
        self.endDate = endDate
        self.calendar = calendar
        self.isAttended = true
        self.sortOrder = 0
        self.createdAt = Date()
        self.modifiedAt = Date()
    }
}
