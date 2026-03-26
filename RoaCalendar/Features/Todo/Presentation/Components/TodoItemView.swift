import SwiftUI

// MARK: - Todo 아이템 행

struct TodoItemView: View {
    let title: String
    let priority: Priority
    let isDone: Bool
    let dueLabel: String?
    let tag: String?
    let pomodoroText: String?
    let streakText: String?
    var onToggle: () -> Void = {}

    var body: some View {
        HStack(spacing: 0) {
            priorityBar
            checkbox
            content
        }
        .padding(.vertical, Spacing.sm + 2)
        .padding(.trailing, Spacing.md)
        .background(Color.surfaceLight)
        .clipShape(RoundedRectangle(cornerRadius: Radius.md))
        .shadow(color: .black.opacity(0.04), radius: 2, y: 1)
        .opacity(isDone ? 0.7 : 1.0)
    }

    // MARK: - 우선순위 바

    private var priorityBar: some View {
        Rectangle()
            .fill(priorityColor)
            .frame(width: 3)
            .clipShape(RoundedRectangle(cornerRadius: 2))
    }

    // MARK: - 체크박스

    private var checkbox: some View {
        Button(action: onToggle) {
            Circle()
                .strokeBorder(isDone ? Color.success : Color.neutral200, lineWidth: 2)
                .background(Circle().fill(isDone ? Color.success : Color.clear))
                .frame(width: 22, height: 22)
                .overlay {
                    if isDone {
                        Image(systemName: "checkmark")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundStyle(.white)
                    }
                }
        }
        .padding(.horizontal, Spacing.sm + 2)
    }

    // MARK: - 내용

    private var content: some View {
        VStack(alignment: .leading, spacing: Spacing.xs) {
            Text(title)
                .font(.system(size: 15, weight: .medium))
                .strikethrough(isDone)
                .foregroundStyle(isDone ? Color.neutral400 : Color.primary)
                .lineLimit(1)

            if !isDone {
                HStack(spacing: Spacing.sm) {
                    if let due = dueLabel {
                        Text(due)
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundStyle(Color.error)
                    }
                    if let tagName = tag {
                        Text(tagName)
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundStyle(Color.primary600)
                    }
                    if let pomo = pomodoroText {
                        Text(pomo)
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundStyle(Color.accent500)
                    }
                    if let streak = streakText {
                        Text(streak)
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundStyle(Color.success)
                    }
                    Spacer()
                }
            }
        }
    }

    // MARK: - 우선순위 색상

    private var priorityColor: Color {
        switch priority {
        case .high: .error
        case .medium: .warning
        case .low: .info
        case .none: .neutral200
        }
    }
}
