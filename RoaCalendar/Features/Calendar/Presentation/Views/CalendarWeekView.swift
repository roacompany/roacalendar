import SwiftUI

// MARK: - 캘린더 주간 뷰

struct CalendarWeekView: View {
    @State private var viewModel = CalendarDayViewModel()
    let hourHeight: CGFloat = 64
    let weekdays = ["월", "화", "수", "목", "금", "토", "일"]

    var body: some View {
        VStack(spacing: 0) {
            header
            weekdayHeader
            divider

            ScrollView {
                ZStack(alignment: .topLeading) {
                    weekTimeGrid
                    if viewModel.isToday {
                        currentTimeLine
                    }
                }
            }
        }
        .background(Color.bgLight)
    }

    // MARK: - 헤더

    private var header: some View {
        HStack {
            Text("3월 4주차")
                .font(.roaTitle1)
            Text("2026")
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(Color.neutral600)

            Spacer()

            Button {
                withAnimation(.spring(duration: 0.3)) { viewModel.goToToday() }
            } label: {
                Text("오늘")
                    .font(.roaCaption)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .padding(.horizontal, Spacing.md)
                    .padding(.vertical, Spacing.xs + 2)
                    .background(Color.primary600)
                    .clipShape(Capsule())
            }
        }
        .padding(.horizontal, Spacing.md)
        .padding(.vertical, Spacing.sm)
    }

    // MARK: - 요일 헤더 (날짜 포함)

    private var weekdayHeader: some View {
        HStack(spacing: 0) {
            Color.clear.frame(width: 44)

            ForEach(0..<7, id: \.self) { index in
                let date = viewModel.currentDate.adding(days: index - currentWeekdayOffset)
                VStack(spacing: 2) {
                    Text(weekdays[index])
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundStyle(weekdayColor(index))
                    Text("\(date.day)")
                        .font(.system(size: 14, weight: date.isToday ? .bold : .medium))
                        .foregroundStyle(date.isToday ? .white : weekdayColor(index))
                        .frame(width: 28, height: 28)
                        .background(
                            Circle().fill(date.isToday ? Color.primary600 : Color.clear)
                        )
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding(.vertical, Spacing.xs)
    }

    // MARK: - 주간 시간 그리드

    private var weekTimeGrid: some View {
        HStack(alignment: .top, spacing: 0) {
            // 시간 라벨
            VStack(spacing: 0) {
                ForEach(6..<22, id: \.self) { hour in
                    Text(hourLabel(hour))
                        .font(.system(size: 10, weight: .medium))
                        .monospacedDigit()
                        .foregroundStyle(Color.neutral400)
                        .frame(width: 40, height: hourHeight, alignment: .topTrailing)
                        .padding(.trailing, Spacing.xs)
                }
            }

            // 7일 열
            ForEach(0..<7, id: \.self) { dayIndex in
                ZStack(alignment: .top) {
                    // 그리드 라인
                    VStack(spacing: 0) {
                        ForEach(6..<22, id: \.self) { _ in
                            Rectangle()
                                .fill(Color.neutral100)
                                .frame(height: 1)
                                .frame(maxWidth: .infinity)
                                .frame(height: hourHeight, alignment: .top)
                        }
                    }

                    // 샘플 이벤트 (목요일에 배치)
                    if dayIndex == 3 {
                        EventBlockView(
                            title: "팀 미팅",
                            timeText: "10-11",
                            subtitle: nil,
                            color: .primary600,
                            hourHeight: hourHeight,
                            startHour: 4.0,
                            durationHours: 1.0
                        )
                        .padding(.horizontal, 1)
                    }
                }
                .frame(maxWidth: .infinity)
                .overlay(alignment: .leading) {
                    Rectangle().fill(Color.neutral100).frame(width: 0.5)
                }
            }
        }
        .frame(height: hourHeight * 16)
    }

    // MARK: - 현재 시간 선

    private var currentTimeLine: some View {
        let yOffset = (viewModel.currentTimePosition - 6) * hourHeight
        return Rectangle()
            .fill(Color.error)
            .frame(height: 1.5)
            .offset(x: 44, y: yOffset)
    }

    // MARK: - 헬퍼

    private var currentWeekdayOffset: Int {
        let cal = Calendar(identifier: .gregorian)
        let wd = cal.component(.weekday, from: viewModel.currentDate)
        return (wd + 5) % 7
    }

    private func weekdayColor(_ index: Int) -> Color {
        switch index {
        case 5: .info
        case 6: .error
        default: .neutral600
        }
    }

    private func hourLabel(_ hour: Int) -> String {
        if hour < 12 { return "\(hour)" }
        if hour == 12 { return "12" }
        return "\(hour)"
    }

    private var divider: some View {
        Rectangle().fill(Color.neutral100).frame(height: 1)
    }
}

#Preview {
    CalendarWeekView()
}
