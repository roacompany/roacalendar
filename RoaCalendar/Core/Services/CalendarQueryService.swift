import SwiftData
import Foundation

// MARK: - 캘린더 이벤트 조회 서비스 (Core)

@MainActor
final class CalendarQueryService {
    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    // MARK: - 이벤트 조회

    func fetchEvents(for date: Date) -> [CalendarEventModel] {
        let start = date.startOfDay
        let end = start.adding(days: 1)

        let descriptor = FetchDescriptor<CalendarEventModel>(
            predicate: #Predicate<CalendarEventModel> { event in
                event.startDate >= start && event.startDate < end
            },
            sortBy: [SortDescriptor(\.startDate)]
        )

        return (try? context.fetch(descriptor)) ?? []
    }

    func fetchEvents(from startDate: Date, to endDate: Date) -> [CalendarEventModel] {
        let descriptor = FetchDescriptor<CalendarEventModel>(
            predicate: #Predicate<CalendarEventModel> { event in
                event.startDate >= startDate && event.startDate < endDate
            },
            sortBy: [SortDescriptor(\.startDate)]
        )

        return (try? context.fetch(descriptor)) ?? []
    }

    // MARK: - 이벤트 생성

    func createEvent(
        title: String,
        startDate: Date,
        endDate: Date,
        isAllDay: Bool = false,
        calendar: RoaCalendar? = nil
    ) -> CalendarEventModel {
        let event = CalendarEventModel(
            title: title,
            isAllDay: isAllDay,
            startDate: startDate,
            endDate: endDate,
            calendar: calendar
        )
        context.insert(event)
        try? context.save()
        return event
    }

    // MARK: - 이벤트 삭제

    func deleteEvent(_ event: CalendarEventModel) {
        context.delete(event)
        try? context.save()
    }

    // MARK: - 캘린더 목록 조회

    func fetchCalendars() -> [RoaCalendar] {
        let descriptor = FetchDescriptor<RoaCalendar>(
            sortBy: [SortDescriptor(\.sortOrder)]
        )
        return (try? context.fetch(descriptor)) ?? []
    }

    // MARK: - 성과 점수용: 오늘 참석 이벤트 수

    func todayAttendedCount() -> (attended: Int, total: Int) {
        let events = fetchEvents(for: Date())
        let total = events.count
        let attended = events.filter(\.isAttended).count
        return (attended, total)
    }
}
