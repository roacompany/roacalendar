import SwiftUI
import SwiftData
import Observation

// MARK: - 월간 캘린더 ViewModel

@MainActor
@Observable
final class CalendarMonthViewModel {
    var currentMonth: Date = Date()
    var selectedDate: Date = Date()
    var gridDates: [Date] = []

    // MARK: - 초기화

    init() {
        updateGrid()
    }

    // MARK: - 월 네비게이션

    func goToPreviousMonth() {
        currentMonth = currentMonth.adding(months: -1)
        updateGrid()
    }

    func goToNextMonth() {
        currentMonth = currentMonth.adding(months: 1)
        updateGrid()
    }

    func goToToday() {
        currentMonth = Date()
        selectedDate = Date()
        updateGrid()
    }

    func selectDate(_ date: Date) {
        selectedDate = date
        if !date.isSameMonth(as: currentMonth) {
            currentMonth = date
            updateGrid()
        }
    }

    // MARK: - 그리드 업데이트

    private func updateGrid() {
        gridDates = currentMonth.monthGridDates()
    }

    // MARK: - 헤더 텍스트

    var monthTitle: String { currentMonth.monthSymbol }
    var yearTitle: String { "\(currentMonth.year)" }

    var selectedDateTitle: String {
        let suffix = selectedDate.isToday ? " · 오늘" : ""
        return "\(selectedDate.day)일 \(selectedDate.dayOfWeekSymbol)\(suffix)"
    }

    // MARK: - 날짜 상태 판별

    func isToday(_ date: Date) -> Bool { date.isToday }
    func isCurrentMonth(_ date: Date) -> Bool { date.isSameMonth(as: currentMonth) }
    func isSelected(_ date: Date) -> Bool { date.isSameDay(as: selectedDate) }

    func isWeekend(_ date: Date) -> Bool {
        let wd = date.weekday
        return wd == 1 || wd == 7
    }

    func isSunday(_ date: Date) -> Bool { date.weekday == 1 }
    func isSaturday(_ date: Date) -> Bool { date.weekday == 7 }
}
