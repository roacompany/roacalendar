import SwiftUI
import Observation

// MARK: - 일간 캘린더 ViewModel

@MainActor
@Observable
final class CalendarDayViewModel {
    var currentDate: Date = Date()
    var hours: [Int] = Array(0...23)

    // MARK: - 네비게이션

    func goToPreviousDay() {
        currentDate = currentDate.adding(days: -1)
    }

    func goToNextDay() {
        currentDate = currentDate.adding(days: 1)
    }

    func goToToday() {
        currentDate = Date()
    }

    // MARK: - 헤더

    var dateTitle: String { currentDate.shortDateString }
    var isToday: Bool { currentDate.isToday }

    // MARK: - 현재 시간 위치 (0.0 ~ 24.0)

    var currentTimePosition: Double {
        let cal = Calendar(identifier: .gregorian)
        let hour = cal.component(.hour, from: Date())
        let minute = cal.component(.minute, from: Date())
        return Double(hour) + Double(minute) / 60.0
    }
}
