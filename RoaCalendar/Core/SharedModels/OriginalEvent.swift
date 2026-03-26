import Foundation

// MARK: - 반복 이벤트 원본 참조 (Core)

struct OriginalEvent: Codable, Hashable {
    let originalEventID: UUID
    let originalStartDate: Date
}
