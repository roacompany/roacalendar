import SwiftUI

// MARK: - 캘린더 연간 뷰

struct CalendarYearView: View {
    @State private var currentYear: Int = Date().year
    private let months = Array(1...12)
    private let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        VStack(spacing: 0) {
            header
            ScrollView {
                LazyVGrid(columns: columns, spacing: Spacing.md) {
                    ForEach(months, id: \.self) { month in
                        miniMonthView(month: month)
                    }
                }
                .padding(.horizontal, Spacing.sm)
                .padding(.bottom, Spacing.xxxl)
            }
        }
        .background(Color.bgLight)
    }

    // MARK: - 헤더

    private var header: some View {
        HStack {
            Button {
                withAnimation { currentYear -= 1 }
            } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(Color.neutral600)
            }

            Spacer()

            Text("\(String(currentYear))년")
                .font(.roaTitle1)

            Spacer()

            Button {
                withAnimation { currentYear += 1 }
            } label: {
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(Color.neutral600)
            }
        }
        .padding(.horizontal, Spacing.lg)
        .padding(.vertical, Spacing.sm)
    }

    // MARK: - 미니 월 뷰

    private func miniMonthView(month: Int) -> some View {
        let cal = Calendar(identifier: .gregorian)
        let dateComponents = DateComponents(year: currentYear, month: month, day: 1)
        let firstDay = cal.date(from: dateComponents) ?? Date()
        let daysInMonth = cal.range(of: .day, in: .month, for: firstDay)?.count ?? 30

        var calWithMonday = cal
        calWithMonday.firstWeekday = 2
        let weekdayOfFirst = calWithMonday.component(.weekday, from: firstDay)
        let offset = (weekdayOfFirst - 2 + 7) % 7

        let weekdays = ["월", "화", "수", "목", "금", "토", "일"]
        let miniColumns = Array(repeating: GridItem(.flexible(), spacing: 0), count: 7)

        return VStack(spacing: Spacing.xs) {
            Text("\(month)월")
                .font(.system(size: 14, weight: .bold))
                .foregroundStyle(isCurrentMonth(month) ? Color.primary600 : Color.primary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, Spacing.xs)

            LazyVGrid(columns: miniColumns, spacing: 0) {
                ForEach(weekdays, id: \.self) { day in
                    Text(day)
                        .font(.system(size: 7, weight: .medium))
                        .foregroundStyle(Color.neutral400)
                }

                ForEach(0..<offset, id: \.self) { _ in
                    Text("").frame(height: 12)
                }

                ForEach(1...daysInMonth, id: \.self) { day in
                    let isToday = isToday(year: currentYear, month: month, day: day)
                    Text("\(day)")
                        .font(.system(size: 8, weight: isToday ? .bold : .regular))
                        .foregroundStyle(isToday ? .white : Color.primary)
                        .frame(width: 14, height: 14)
                        .background(
                            Circle().fill(isToday ? Color.primary600 : Color.clear)
                        )
                }
            }
        }
        .padding(Spacing.sm)
        .background(Color.surfaceLight)
        .clipShape(RoundedRectangle(cornerRadius: Radius.md))
        .shadow(color: .black.opacity(0.03), radius: 2, y: 1)
    }

    // MARK: - 헬퍼

    private func isCurrentMonth(_ month: Int) -> Bool {
        let now = Date()
        return currentYear == now.year && month == now.month
    }

    private func isToday(year: Int, month: Int, day: Int) -> Bool {
        let now = Date()
        return year == now.year && month == now.month && day == now.day
    }
}

#Preview {
    CalendarYearView()
}
