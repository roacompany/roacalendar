import SwiftUI

// MARK: - 날짜 셀

struct CalendarDayCellView: View {
    let date: Date
    let isToday: Bool
    let isCurrentMonth: Bool
    let isSelected: Bool
    let isSunday: Bool
    let isSaturday: Bool
    let events: [EventColor]

    var body: some View {
        VStack(spacing: 2) {
            dateNumber
            eventDots
        }
        .frame(maxWidth: .infinity)
        .aspectRatio(1.0 / 1.1, contentMode: .fit)
        .padding(.vertical, Spacing.xxs)
    }

    // MARK: - 날짜 숫자

    private var dateNumber: some View {
        Text("\(date.day)")
            .font(.system(size: 14, weight: isToday ? .bold : .medium))
            .foregroundStyle(dateColor)
            .frame(width: 28, height: 28)
            .background(
                Circle()
                    .fill(isToday ? Color.primary600 : (isSelected ? Color.neutral100 : Color.clear))
            )
    }

    // MARK: - 이벤트 점

    private var eventDots: some View {
        HStack(spacing: 2) {
            ForEach(events.prefix(3), id: \.self) { color in
                Circle()
                    .fill(color.color)
                    .frame(width: 4, height: 4)
            }
        }
        .frame(height: 4)
    }

    // MARK: - 날짜 색상

    private var dateColor: Color {
        if isToday { return .white }
        if !isCurrentMonth { return .neutral400.opacity(0.4) }
        if isSunday { return .error }
        if isSaturday { return .info }
        return .neutral900
    }
}
