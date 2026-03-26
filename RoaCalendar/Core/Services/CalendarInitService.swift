import SwiftData
import Foundation

// MARK: - 캘린더 초기 데이터 생성 서비스

struct CalendarInitService {

    /// 기본 캘린더 3개 생성 (중복 방지)
    static func createDefaultCalendars(context: ModelContext) {
        let descriptor = FetchDescriptor<RoaCalendar>()
        let existingCount = (try? context.fetchCount(descriptor)) ?? 0

        guard existingCount == 0 else { return }

        let personal = RoaCalendar(
            title: "개인",
            color: .blueberry,
            isDefault: true,
            sortOrder: 0
        )

        let pomodoro = RoaCalendar(
            title: "뽀모도로",
            color: .sage,
            sortOrder: 1
        )

        let holiday = RoaCalendar(
            title: "공휴일",
            color: .tomato,
            isReadOnly: true,
            sortOrder: 2
        )

        context.insert(personal)
        context.insert(pomodoro)
        context.insert(holiday)

        try? context.save()
    }
}
