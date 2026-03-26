import SwiftUI

// MARK: - 이벤트 시간 블록 (일간/주간 뷰)

struct EventBlockView: View {
    let title: String
    let timeText: String
    let subtitle: String?
    let color: Color
    let hourHeight: CGFloat
    let startHour: Double
    let durationHours: Double

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title)
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(.white)
                .lineLimit(1)

            Text(timeText)
                .font(.system(size: 10, weight: .medium))
                .foregroundStyle(.white.opacity(0.8))

            if let sub = subtitle {
                Text(sub)
                    .font(.system(size: 10))
                    .foregroundStyle(.white.opacity(0.7))
                    .lineLimit(1)
            }
        }
        .padding(.horizontal, Spacing.sm)
        .padding(.vertical, Spacing.xs)
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(height: max(durationHours * hourHeight - 2, 24))
        .background(color)
        .clipShape(RoundedRectangle(cornerRadius: Radius.sm))
        .offset(y: startHour * hourHeight)
    }
}
