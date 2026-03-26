import SwiftUI
import SwiftData

// MARK: - 캘린더 월간 뷰

struct CalendarMonthView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = CalendarMonthViewModel()
    @State private var showCreateEvent = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                header
                viewSwitcher
                CalendarGridView(viewModel: viewModel)
                divider
                dayDetail
            }
            .background(Color.bgLight)
            .overlay(alignment: .bottomTrailing) {
                Button {
                    showCreateEvent = true
                } label: {
                    Image(systemName: "plus")
                        .font(.system(size: 24, weight: .medium))
                        .foregroundStyle(.white)
                        .frame(width: 52, height: 52)
                        .background(Color.primary600)
                        .clipShape(Circle())
                        .shadow(color: .primary600.opacity(0.3), radius: 8, y: 4)
                }
                .padding(.trailing, Spacing.lg)
                .padding(.bottom, Spacing.lg)
            }
            .sheet(isPresented: $showCreateEvent) {
                EventCreateView()
            }
        }
    }

    // MARK: - 헤더

    private var header: some View {
        HStack {
            HStack(alignment: .firstTextBaseline, spacing: Spacing.sm) {
                Text(viewModel.monthTitle)
                    .font(.roaDisplay)
                Text(viewModel.yearTitle)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(Color.neutral600)
            }

            Spacer()

            HStack(spacing: Spacing.sm) {
                Button("오늘") {
                    withAnimation(.spring(duration: 0.3)) {
                        viewModel.goToToday()
                    }
                }
                .font(.roaCaption)
                .fontWeight(.semibold)
                .foregroundStyle(.white)
                .padding(.horizontal, Spacing.md)
                .padding(.vertical, Spacing.xs + 2)
                .background(Color.primary600)
                .clipShape(Capsule())

                headerButton(icon: "magnifyingglass")
                headerButton(icon: "line.3.horizontal.decrease")
            }
        }
        .padding(.horizontal, Spacing.md)
        .padding(.vertical, Spacing.sm)
    }

    // MARK: - 뷰 전환 탭

    private var viewSwitcher: some View {
        HStack(spacing: Spacing.xs) {
            ForEach(["연간", "월간", "주간", "일간"], id: \.self) { tab in
                Text(tab)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(tab == "월간" ? .white : Color.neutral400)
                    .padding(.horizontal, Spacing.md)
                    .padding(.vertical, Spacing.xs + 2)
                    .background(tab == "월간" ? Color.primary600 : Color.clear)
                    .clipShape(Capsule())
            }
        }
        .padding(.horizontal, Spacing.md)
        .padding(.bottom, Spacing.sm)
    }

    // MARK: - 구분선

    private var divider: some View {
        Rectangle()
            .fill(Color.neutral100)
            .frame(height: 1)
            .padding(.horizontal, Spacing.md)
            .padding(.top, Spacing.sm)
    }

    // MARK: - 선택 날짜 상세

    private var dayDetail: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.sm) {
                Text(viewModel.selectedDateTitle)
                    .font(.system(size: 15, weight: .bold))
                    .padding(.horizontal, Spacing.md)
                    .padding(.top, Spacing.sm)

                eventRow(time: "10:00", title: "팀 주간 미팅", subtitle: "📍 회의실 A · 1시간", color: .primary600)
                eventRow(time: "14:00", title: "🍅 기획안 작성", subtitle: "뽀모도로 3세션 예정", color: .accent500)
                taskRow(title: "주간 보고서 제출", dueLabel: "오늘 마감", isDone: false)
                eventRow(time: "18:00", title: "운동", subtitle: "💪 30분 · 건강", color: .success)
                taskRow(title: "이메일 정리", dueLabel: nil, isDone: true)
            }
            .padding(.bottom, 80)
        }
    }

    // MARK: - 이벤트 행

    private func eventRow(time: String, title: String, subtitle: String, color: Color) -> some View {
        HStack(spacing: Spacing.sm) {
            Text(time)
                .font(.roaCaption)
                .fontWeight(.semibold)
                .foregroundStyle(Color.neutral400)
                .monospacedDigit()
                .frame(width: 44, alignment: .leading)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 14, weight: .medium))
                Text(subtitle)
                    .font(.system(size: 11))
                    .foregroundStyle(Color.neutral400)
            }

            Spacer()
        }
        .padding(Spacing.sm + 4)
        .background(Color.surfaceLight)
        .overlay(alignment: .leading) {
            Rectangle().fill(color).frame(width: 3)
        }
        .clipShape(RoundedRectangle(cornerRadius: Radius.md))
        .shadow(color: .black.opacity(0.04), radius: 2, y: 1)
        .padding(.horizontal, Spacing.md)
    }

    // MARK: - Task 행

    private func taskRow(title: String, dueLabel: String?, isDone: Bool) -> some View {
        HStack(spacing: Spacing.sm) {
            Circle()
                .strokeBorder(isDone ? Color.success : Color.neutral200, lineWidth: 2)
                .background(Circle().fill(isDone ? Color.success : Color.clear))
                .frame(width: 20, height: 20)

            Text(title)
                .font(.system(size: 14, weight: .medium))
                .strikethrough(isDone)
                .foregroundStyle(isDone ? Color.neutral400 : Color.primary)

            Spacer()

            if let due = dueLabel {
                Text(due)
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundStyle(Color.error)
            }
        }
        .padding(Spacing.sm + 4)
        .background(Color.surfaceLight)
        .clipShape(RoundedRectangle(cornerRadius: Radius.md))
        .shadow(color: .black.opacity(0.04), radius: 2, y: 1)
        .padding(.horizontal, Spacing.md)
    }

    // MARK: - 헤더 버튼

    private func headerButton(icon: String) -> some View {
        Button {} label: {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundStyle(Color.neutral600)
                .frame(width: 36, height: 36)
                .background(Color.surfaceLight)
                .clipShape(Circle())
                .overlay(Circle().strokeBorder(Color.neutral100, lineWidth: 1))
        }
    }
}

#Preview {
    CalendarMonthView()
}
