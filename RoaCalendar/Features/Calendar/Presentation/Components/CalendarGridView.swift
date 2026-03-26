import SwiftUI

// MARK: - 월간 캘린더 그리드

struct CalendarGridView: View {
    let viewModel: CalendarMonthViewModel
    let weekdays = ["월", "화", "수", "목", "금", "토", "일"]

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 1), count: 7)

    var body: some View {
        VStack(spacing: 0) {
            weekdayHeader
            daysGrid
        }
    }

    // MARK: - 요일 헤더

    private var weekdayHeader: some View {
        LazyVGrid(columns: columns, spacing: 0) {
            ForEach(Array(weekdays.enumerated()), id: \.offset) { index, day in
                Text(day)
                    .font(.roaCaption)
                    .fontWeight(.semibold)
                    .foregroundStyle(weekdayColor(index: index))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, Spacing.xs)
            }
        }
        .padding(.horizontal, Spacing.sm)
    }

    // MARK: - 날짜 그리드

    private var daysGrid: some View {
        LazyVGrid(columns: columns, spacing: 2) {
            ForEach(viewModel.gridDates, id: \.self) { date in
                CalendarDayCellView(
                    date: date,
                    isToday: viewModel.isToday(date),
                    isCurrentMonth: viewModel.isCurrentMonth(date),
                    isSelected: viewModel.isSelected(date),
                    isSunday: viewModel.isSunday(date),
                    isSaturday: viewModel.isSaturday(date),
                    events: []
                )
                .onTapGesture {
                    withAnimation(.spring(duration: 0.2)) {
                        viewModel.selectDate(date)
                    }
                }
            }
        }
        .padding(.horizontal, Spacing.sm)
    }

    // MARK: - 요일 색상

    private func weekdayColor(index: Int) -> Color {
        switch index {
        case 5: .info
        case 6: .error
        default: .neutral400
        }
    }
}
