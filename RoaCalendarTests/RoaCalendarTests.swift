import Testing
@testable import RoaCalendar

// MARK: - 기본 테스트

@Suite("로아 캘린더 기본 테스트")
struct RoaCalendarBasicTests {
    @Test("EventColor 전체 11색 확인")
    func eventColorCount() {
        #expect(EventColor.allCases.count == 11)
    }

    @Test("EventColor 이름 존재 확인")
    func eventColorNames() {
        for eventColor in EventColor.allCases {
            #expect(!eventColor.name.isEmpty)
        }
    }
}
