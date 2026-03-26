import SwiftUI

// MARK: - Task 상세 화면

struct TaskDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var title = "기획안 최종 제출"
    @State private var notes = "마케팅 전략 기획안 최종 버전 작성"
    @State private var isUrgent = true
    @State private var isFlagged = false
    @State private var selectedPriority: Priority = .high

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: Spacing.md) {
                    titleSection
                    statusSection
                    prioritySection
                    dateSection
                    organizationSection
                    subtaskSection
                    pomodoroSection
                    notesSection
                    repeatFlagSection
                    deleteButton
                }
                .padding(.horizontal, Spacing.md)
                .padding(.bottom, Spacing.xxxl)
            }
            .background(Color.bgLight)
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button { dismiss() } label: {
                        Image(systemName: "chevron.left")
                            .foregroundStyle(Color.primary600)
                    }
                }
                ToolbarItem(placement: .primaryAction) {
                    HStack(spacing: Spacing.md) {
                        Button("편집") {}
                            .foregroundStyle(Color.primary600)
                        Button {} label: {
                            Image(systemName: "trash")
                                .foregroundStyle(Color.error)
                        }
                    }
                }
            }
        }
    }

    // MARK: - 제목

    private var titleSection: some View {
        TextField("제목", text: $title)
            .font(.roaTitle1)
            .padding(.top, Spacing.sm)
    }

    // MARK: - 상태

    private var statusSection: some View {
        HStack {
            Text("진행 중")
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(Color.primary600)
                .padding(.horizontal, Spacing.sm + 4)
                .padding(.vertical, Spacing.xxs + 2)
                .background(Color.primary600.opacity(0.1))
                .clipShape(Capsule())
            Spacer()
        }
    }

    // MARK: - 우선순위 + 긴급

    private var prioritySection: some View {
        detailCard {
            VStack(spacing: Spacing.sm) {
                HStack {
                    Text("우선순위")
                        .font(.system(size: 15, weight: .medium))
                    Spacer()
                    HStack(spacing: Spacing.xs) {
                        ForEach(Priority.allCases, id: \.self) { priority in
                            Button {
                                selectedPriority = priority
                            } label: {
                                Text(priorityLabel(priority))
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundStyle(selectedPriority == priority ? .white : Color.neutral600)
                                    .padding(.horizontal, Spacing.sm)
                                    .padding(.vertical, Spacing.xxs + 2)
                                    .background(selectedPriority == priority ? priorityColor(priority) : Color.neutral100)
                                    .clipShape(Capsule())
                            }
                        }
                    }
                }

                HStack {
                    Text("긴급")
                        .font(.system(size: 15, weight: .medium))
                    Spacer()
                    Toggle("", isOn: $isUrgent)
                        .tint(Color.error)
                }
            }
        }
    }

    // MARK: - 날짜 (3종)

    private var dateSection: some View {
        detailCard {
            VStack(spacing: 0) {
                dateRow(icon: "arrow.right.circle", title: "지연일", value: "없음", color: .neutral400)
                Divider().padding(.leading, 36)
                dateRow(icon: "calendar.badge.clock", title: "예정일", value: "3월 26일", color: .primary600)
                Divider().padding(.leading, 36)
                dateRow(icon: "exclamationmark.circle", title: "마감일", value: "3월 26일 (오늘)", color: .error)
            }
        }
    }

    // MARK: - 프로젝트/캘린더/태그

    private var organizationSection: some View {
        detailCard {
            VStack(spacing: 0) {
                navRow(icon: "folder", title: "프로젝트", value: "Q1 마케팅")
                Divider().padding(.leading, 36)
                HStack {
                    Image(systemName: "tray")
                        .frame(width: 20)
                        .foregroundStyle(Color.neutral400)
                    Text("캘린더")
                        .font(.system(size: 15, weight: .medium))
                    Spacer()
                    Circle().fill(EventColor.blueberry.color).frame(width: 10, height: 10)
                    Text("업무")
                        .font(.system(size: 15))
                        .foregroundStyle(Color.neutral400)
                    Image(systemName: "chevron.right")
                        .font(.system(size: 12))
                        .foregroundStyle(Color.neutral300)
                }
                .padding(.vertical, Spacing.sm + 2)
                Divider().padding(.leading, 36)
                HStack {
                    Image(systemName: "tag")
                        .frame(width: 20)
                        .foregroundStyle(Color.neutral400)
                    Text("태그")
                        .font(.system(size: 15, weight: .medium))
                    Spacer()
                    HStack(spacing: Spacing.xs) {
                        tagChip("기획")
                        tagChip("긴급")
                        Image(systemName: "plus")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundStyle(Color.primary600)
                    }
                }
                .padding(.vertical, Spacing.sm + 2)
            }
        }
    }

    // MARK: - 서브태스크

    private var subtaskSection: some View {
        detailCard {
            VStack(alignment: .leading, spacing: Spacing.sm) {
                Text("서브태스크")
                    .font(.system(size: 15, weight: .semibold))

                subtaskRow(title: "초안 작성", isDone: true)
                subtaskRow(title: "팀장 리뷰", isDone: false)
                subtaskRow(title: "최종 수정", isDone: false)

                Button {
                } label: {
                    HStack(spacing: Spacing.xs) {
                        Image(systemName: "plus.circle")
                        Text("서브태스크 추가")
                    }
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(Color.primary600)
                }
            }
        }
    }

    // MARK: - 뽀모도로

    private var pomodoroSection: some View {
        detailCard {
            HStack {
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    Text("🍅 뽀모도로")
                        .font(.system(size: 15, weight: .semibold))
                    Text("3/3 세션 완료")
                        .font(.roaCaption)
                        .foregroundStyle(Color.success)
                }
                Spacer()
                Button("집중 시작") {}
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, Spacing.md)
                    .padding(.vertical, Spacing.sm)
                    .background(Color.accent500)
                    .clipShape(Capsule())
            }
        }
    }

    // MARK: - 메모

    private var notesSection: some View {
        detailCard {
            VStack(alignment: .leading, spacing: Spacing.xs) {
                Text("메모")
                    .font(.system(size: 15, weight: .semibold))
                TextEditor(text: $notes)
                    .font(.roaBody)
                    .frame(minHeight: 60)
                    .scrollContentBackground(.hidden)
            }
        }
    }

    // MARK: - 반복/깃발

    private var repeatFlagSection: some View {
        detailCard {
            VStack(spacing: 0) {
                navRow(icon: "repeat", title: "반복", value: "반복 안 함")
                Divider().padding(.leading, 36)
                HStack {
                    Image(systemName: "flag")
                        .frame(width: 20)
                        .foregroundStyle(Color.neutral400)
                    Text("깃발")
                        .font(.system(size: 15, weight: .medium))
                    Spacer()
                    Toggle("", isOn: $isFlagged)
                        .tint(Color.accent500)
                }
                .padding(.vertical, Spacing.sm + 2)
            }
        }
    }

    // MARK: - 삭제

    private var deleteButton: some View {
        Button {
        } label: {
            Text("삭제")
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(Color.error)
                .frame(maxWidth: .infinity)
                .padding(.vertical, Spacing.sm + 4)
                .background(Color.error.opacity(0.08))
                .clipShape(RoundedRectangle(cornerRadius: Radius.md))
        }
    }

    // MARK: - 컴포넌트

    private func detailCard<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        VStack(spacing: 0) {
            content()
        }
        .padding(Spacing.md)
        .background(Color.surfaceLight)
        .clipShape(RoundedRectangle(cornerRadius: Radius.lg))
        .shadow(color: .black.opacity(0.04), radius: 2, y: 1)
    }

    private func dateRow(icon: String, title: String, value: String, color: Color) -> some View {
        HStack {
            Image(systemName: icon)
                .frame(width: 20)
                .foregroundStyle(color)
            Text(title)
                .font(.system(size: 15, weight: .medium))
            Spacer()
            Text(value)
                .font(.system(size: 15))
                .foregroundStyle(color)
        }
        .padding(.vertical, Spacing.sm + 2)
    }

    private func navRow(icon: String, title: String, value: String) -> some View {
        HStack {
            Image(systemName: icon)
                .frame(width: 20)
                .foregroundStyle(Color.neutral400)
            Text(title)
                .font(.system(size: 15, weight: .medium))
            Spacer()
            Text(value)
                .font(.system(size: 15))
                .foregroundStyle(Color.neutral400)
            Image(systemName: "chevron.right")
                .font(.system(size: 12))
                .foregroundStyle(Color.neutral300)
        }
        .padding(.vertical, Spacing.sm + 2)
    }

    private func subtaskRow(title: String, isDone: Bool) -> some View {
        HStack(spacing: Spacing.sm) {
            Circle()
                .strokeBorder(isDone ? Color.success : Color.neutral200, lineWidth: 2)
                .background(Circle().fill(isDone ? Color.success : Color.clear))
                .frame(width: 18, height: 18)
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .strikethrough(isDone)
                .foregroundStyle(isDone ? Color.neutral400 : Color.neutral900)
        }
    }

    private func tagChip(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 11, weight: .semibold))
            .foregroundStyle(Color.primary600)
            .padding(.horizontal, Spacing.sm)
            .padding(.vertical, Spacing.xxs + 1)
            .background(Color.primary600.opacity(0.1))
            .clipShape(Capsule())
    }

    private func priorityLabel(_ level: Priority) -> String {
        switch level {
        case .none: "없음"
        case .low: "낮음"
        case .medium: "보통"
        case .high: "높음"
        }
    }

    private func priorityColor(_ level: Priority) -> Color {
        switch level {
        case .high: .error
        case .medium: .warning
        case .low: .info
        case .none: .neutral400
        }
    }
}

#Preview {
    TaskDetailView()
}
