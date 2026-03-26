import SwiftUI

// MARK: - Todo Today 뷰

struct TodoTodayView: View {
    @State private var viewModel = TodoTodayViewModel()

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                header
                loadIndicator
                smartViewTabs
                todoList
            }
            .background(Color.bgLight)
            .overlay(alignment: .bottomTrailing) { fab }
        }
    }

    // MARK: - 헤더

    private var header: some View {
        HStack {
            Text("오늘")
                .font(.roaDisplay)

            Text("\(viewModel.taskCount)")
                .font(.roaCaption)
                .fontWeight(.bold)
                .foregroundStyle(.white)
                .padding(.horizontal, Spacing.sm)
                .padding(.vertical, Spacing.xxs + 1)
                .background(Color.primary600)
                .clipShape(Capsule())

            Spacer()

            Button {} label: {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 16))
                    .foregroundStyle(Color.neutral600)
            }
        }
        .padding(.horizontal, Spacing.md)
        .padding(.vertical, Spacing.sm)
    }

    // MARK: - 일일 부하 표시

    private var loadIndicator: some View {
        Text(viewModel.loadSummary)
            .font(.roaCaption)
            .foregroundStyle(viewModel.isOverloaded ? Color.error : Color.neutral600)
            .padding(.horizontal, Spacing.sm + 4)
            .padding(.vertical, Spacing.sm)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(viewModel.isOverloaded ? Color.error.opacity(0.06) : Color.neutral100)
            .clipShape(RoundedRectangle(cornerRadius: Radius.md))
            .padding(.horizontal, Spacing.md)
            .padding(.bottom, Spacing.sm)
    }

    // MARK: - 스마트 뷰 탭

    private var smartViewTabs: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: Spacing.xs) {
                ForEach(TodoTodayViewModel.SmartView.allCases, id: \.self) { tab in
                    Text(tab.rawValue)
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(viewModel.selectedView == tab ? .white : Color.neutral400)
                        .padding(.horizontal, Spacing.md)
                        .padding(.vertical, Spacing.xs + 2)
                        .background(viewModel.selectedView == tab ? Color.primary600 : Color.clear)
                        .clipShape(Capsule())
                        .onTapGesture {
                            withAnimation(.spring(duration: 0.2)) {
                                viewModel.selectedView = tab
                            }
                        }
                }
            }
            .padding(.horizontal, Spacing.md)
        }
        .padding(.bottom, Spacing.sm)
    }

    // MARK: - Todo 리스트

    private var todoList: some View {
        ScrollView {
            VStack(spacing: Spacing.sm) {
                TodoItemView(title: "기획안 최종 제출", priority: .high, isDone: false, dueLabel: "오늘 마감", tag: "업무", pomodoroText: "🍅 3/3", streakText: nil)
                TodoItemView(title: "주간 보고서 작성", priority: .medium, isDone: false, dueLabel: "내일 마감", tag: "업무", pomodoroText: "🍅 0/2", streakText: nil)
                TodoItemView(title: "이메일 정리", priority: .low, isDone: true, dueLabel: nil, tag: "업무", pomodoroText: nil, streakText: nil)
                TodoItemView(title: "운동 30분", priority: .high, isDone: false, dueLabel: nil, tag: "건강", pomodoroText: nil, streakText: "🔥 12일")
                TodoItemView(title: "독서 20분", priority: .medium, isDone: true, dueLabel: nil, tag: "학습", pomodoroText: nil, streakText: nil)
                TodoItemView(title: "팀 회의 준비", priority: .medium, isDone: false, dueLabel: nil, tag: "업무", pomodoroText: nil, streakText: nil)
                TodoItemView(title: "장보기", priority: .none, isDone: false, dueLabel: nil, tag: "개인", pomodoroText: nil, streakText: nil)
                TodoItemView(title: "명상 10분", priority: .low, isDone: false, dueLabel: nil, tag: "건강", pomodoroText: nil, streakText: nil)
            }
            .padding(.horizontal, Spacing.md)
            .padding(.bottom, 80)
        }
    }

    // MARK: - FAB

    private var fab: some View {
        Button {} label: {
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
}

#Preview {
    TodoTodayView()
}
