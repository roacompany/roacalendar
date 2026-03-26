import SwiftUI

// MARK: - 캘린더 일간 뷰

struct CalendarDayView: View {
    @State private var viewModel = CalendarDayViewModel()
    let hourHeight: CGFloat = 72

    var body: some View {
        VStack(spacing: 0) {
            header
            allDayStrip
            divider

            ScrollViewReader { proxy in
                ScrollView {
                    ZStack(alignment: .topLeading) {
                        TimeGridView(
                            hourHeight: hourHeight,
                            currentTimePosition: viewModel.currentTimePosition,
                            showCurrentTime: viewModel.isToday
                        )

                        eventsOverlay
                    }
                    .padding(.trailing, Spacing.md)
                    .id("timeGrid")
                }
                .onAppear {
                    // 8시 위치로 스크롤
                }
            }
        }
        .background(Color.bgLight)
        .gesture(
            DragGesture(minimumDistance: 50)
                .onEnded { value in
                    if value.translation.width > 50 {
                        withAnimation(.spring(duration: 0.3)) { viewModel.goToPreviousDay() }
                    } else if value.translation.width < -50 {
                        withAnimation(.spring(duration: 0.3)) { viewModel.goToNextDay() }
                    }
                }
        )
    }

    // MARK: - 헤더

    private var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(viewModel.dateTitle)
                    .font(.roaTitle1)
                if viewModel.isToday {
                    Text("오늘")
                        .font(.roaCaption)
                        .foregroundStyle(Color.primary600)
                        .fontWeight(.semibold)
                }
            }

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

    // MARK: - 종일 이벤트 스트립

    private var allDayStrip: some View {
        HStack(spacing: Spacing.sm) {
            Text("종일")
                .font(.system(size: 11, weight: .medium))
                .foregroundStyle(Color.neutral400)
                .frame(width: 40, alignment: .trailing)

            HStack(spacing: Spacing.xs) {
                allDayChip(title: "삼일절", color: .error)
            }

            Spacer()
        }
        .padding(.horizontal, Spacing.sm)
        .padding(.vertical, Spacing.xs)
    }

    // MARK: - 이벤트 오버레이

    private var eventsOverlay: some View {
        let leftPadding: CGFloat = 52

        return ZStack(alignment: .topLeading) {
            EventBlockView(
                title: "팀 주간 미팅",
                timeText: "10:00 - 11:00",
                subtitle: "📍 회의실 A",
                color: .primary600,
                hourHeight: hourHeight,
                startHour: 10.0,
                durationHours: 1.0
            )
            .padding(.leading, leftPadding)

            EventBlockView(
                title: "🍅 기획안 작성",
                timeText: "14:00 - 16:00",
                subtitle: "뽀모도로 3세션",
                color: .accent500,
                hourHeight: hourHeight,
                startHour: 14.0,
                durationHours: 2.0
            )
            .padding(.leading, leftPadding)

            EventBlockView(
                title: "운동",
                timeText: "18:00 - 18:30",
                subtitle: "💪 건강",
                color: .success,
                hourHeight: hourHeight,
                startHour: 18.0,
                durationHours: 0.5
            )
            .padding(.leading, leftPadding)
        }
    }

    // MARK: - 구분선

    private var divider: some View {
        Rectangle()
            .fill(Color.neutral100)
            .frame(height: 1)
    }

    // MARK: - 종일 이벤트 칩

    private func allDayChip(title: String, color: Color) -> some View {
        Text(title)
            .font(.system(size: 11, weight: .semibold))
            .foregroundStyle(.white)
            .padding(.horizontal, Spacing.sm)
            .padding(.vertical, Spacing.xxs + 1)
            .background(color)
            .clipShape(Capsule())
    }
}

#Preview {
    CalendarDayView()
}
