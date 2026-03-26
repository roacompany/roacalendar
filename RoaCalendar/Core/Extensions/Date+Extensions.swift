import Foundation

// MARK: - 날짜 유틸리티 (CLAUDE.md: Calendar(identifier: .gregorian) 필수)

extension Date {
    private static let gregorian = Calendar(identifier: .gregorian)

    var year: Int { Date.gregorian.component(.year, from: self) }
    var month: Int { Date.gregorian.component(.month, from: self) }
    var day: Int { Date.gregorian.component(.day, from: self) }
    var weekday: Int { Date.gregorian.component(.weekday, from: self) }

    var isToday: Bool { Date.gregorian.isDateInToday(self) }

    var startOfDay: Date {
        Date.gregorian.startOfDay(for: self)
    }

    var startOfMonth: Date {
        let components = Date.gregorian.dateComponents([.year, .month], from: self)
        return Date.gregorian.date(from: components) ?? self
    }

    var endOfMonth: Date {
        guard let range = Date.gregorian.range(of: .day, in: .month, for: self),
              let last = Date.gregorian.date(byAdding: .day, value: range.count - 1, to: startOfMonth)
        else { return self }
        return last
    }

    var daysInMonth: Int {
        Date.gregorian.range(of: .day, in: .month, for: self)?.count ?? 30
    }

    func adding(months: Int) -> Date {
        Date.gregorian.date(byAdding: .month, value: months, to: self) ?? self
    }

    func adding(days: Int) -> Date {
        Date.gregorian.date(byAdding: .day, value: days, to: self) ?? self
    }

    var monthSymbol: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.calendar = Date.gregorian
        formatter.dateFormat = "M월"
        return formatter.string(from: self)
    }

    var dayOfWeekSymbol: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.calendar = Date.gregorian
        formatter.dateFormat = "EEEE"
        return formatter.string(from: self)
    }

    var shortDateString: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.calendar = Date.gregorian
        formatter.dateFormat = "M월 d일 EEEE"
        return formatter.string(from: self)
    }

    // MARK: - 월간 캘린더 그리드 날짜 생성 (월요일 시작)

    func monthGridDates(firstWeekday: Int = 2) -> [Date] {
        let start = startOfMonth
        var cal = Date.gregorian
        cal.firstWeekday = firstWeekday

        let weekdayOfFirst = cal.component(.weekday, from: start)
        let offset = (weekdayOfFirst - firstWeekday + 7) % 7

        let gridStart = start.adding(days: -offset)
        return (0..<42).map { gridStart.adding(days: $0) }
    }

    func isSameDay(as other: Date) -> Bool {
        Date.gregorian.isDate(self, inSameDayAs: other)
    }

    func isSameMonth(as other: Date) -> Bool {
        year == other.year && month == other.month
    }
}
