import SwiftUI

// MARK: - Todo Today 뷰

struct TodoTodayView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = TodoTodayViewModel()
    @State private var quickAddText = ""
    @State private var showQuickAdd = false

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
                if viewModel.tasks.isEmpty {
                    VStack(spacing: Spacing.md) {
                        Text("☑️")
                            .font(.system(size: 48))
                        Text("할 일이 없습니다")
                            .font(.roaBody)
                            .foregroundStyle(Color.neutral400)
                        Text("+ 버튼으로 할 일을 추가하세요")
                            .font(.roaCaption)
                            .foregroundStyle(Color.neutral400)
                    }
                    .padding(.top, Spacing.xxxl)
                } else {
                    ForEach(viewModel.tasks, id: \.id) { task in
                        TodoItemView(
                            title: task.title,
                            priority: task.priority,
                            isDone: task.status == .completed,
                            dueLabel: task.isOverdue ? "기한 초과" : nil,
                            tag: task.calendar?.title,
                            pomodoroText: task.estimatedPomodoros.map { "🍅 \(task.completedPomodoros)/\($0)" },
                            streakText: nil,
                            onToggle: {
                                withAnimation(.spring(duration: 0.2)) {
                                    viewModel.toggleComplete(task, context: modelContext)
                                }
                            }
                        )
                    }
                }
            }
            .padding(.horizontal, Spacing.md)
            .padding(.bottom, 80)
        }
        .onAppear {
            viewModel.loadTasks(context: modelContext)
        }
        .onChange(of: viewModel.selectedView) {
            viewModel.loadTasks(context: modelContext)
        }
    }

    // MARK: - FAB

    private var fab: some View {
        Button {
            showQuickAdd = true
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
        .alert("할 일 추가", isPresented: $showQuickAdd) {
            TextField("무엇을 해야 하나요?", text: $quickAddText)
            Button("추가") {
                viewModel.quickAdd(title: quickAddText, context: modelContext)
                quickAddText = ""
            }
            Button("취소", role: .cancel) { quickAddText = "" }
        }
    }
}

#Preview {
    TodoTodayView()
}
