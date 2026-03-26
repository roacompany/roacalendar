import SwiftUI

// MARK: - 색상 enum (Core 레이어, 전 Feature 공유)

enum EventColor: Int, Codable, CaseIterable {
    case lavender = 0
    case sage = 1
    case grape = 2
    case flamingo = 3
    case banana = 4
    case tangerine = 5
    case peacock = 6
    case graphite = 7
    case blueberry = 8
    case basil = 9
    case tomato = 10

    var color: Color {
        switch self {
        case .lavender: Color(hex: "#7986CB")
        case .sage: Color(hex: "#33B679")
        case .grape: Color(hex: "#8E24AA")
        case .flamingo: Color(hex: "#E67C73")
        case .banana: Color(hex: "#F6BF26")
        case .tangerine: Color(hex: "#F4511E")
        case .peacock: Color(hex: "#039BE5")
        case .graphite: Color(hex: "#616161")
        case .blueberry: Color(hex: "#3F51B5")
        case .basil: Color(hex: "#0B8043")
        case .tomato: Color(hex: "#D50000")
        }
    }

    var name: String {
        switch self {
        case .lavender: "라벤더"
        case .sage: "세이지"
        case .grape: "포도"
        case .flamingo: "플라밍고"
        case .banana: "바나나"
        case .tangerine: "탄저린"
        case .peacock: "피콕"
        case .graphite: "그래파이트"
        case .blueberry: "블루베리"
        case .basil: "바질"
        case .tomato: "토마토"
        }
    }
}
