import SwiftUI

// MARK: - 시간 그리드 (일간/주간 공용)

struct TimeGridView: View {
    let hourHeight: CGFloat
    let currentTimePosition: Double
    let showCurrentTime: Bool

    init(hourHeight: CGFloat = 72, currentTimePosition: Double = 0, showCurrentTime: Bool = true) {
        self.hourHeight = hourHeight
        self.currentTimePosition = currentTimePosition
        self.showCurrentTime = showCurrentTime
    }

    var body: some View {
        ZStack(alignment: .topLeading) {
            hourLines
            if showCurrentTime {
                currentTimeLine
            }
        }
        .frame(height: hourHeight * 24)
    }

    // MARK: - 시간 라인

    private var hourLines: some View {
        VStack(spacing: 0) {
            ForEach(0..<24, id: \.self) { hour in
                HStack(alignment: .top, spacing: Spacing.sm) {
                    Text(hourLabel(hour))
                        .font(.system(size: 11, weight: .medium))
                        .monospacedDigit()
                        .foregroundStyle(Color.neutral400)
                        .frame(width: 40, alignment: .trailing)

                    VStack {
                        Divider()
                        Spacer()
                    }
                }
                .frame(height: hourHeight)
            }
        }
    }

    // MARK: - 현재 시간 빨간 선

    private var currentTimeLine: some View {
        let yOffset = currentTimePosition * hourHeight

        return HStack(spacing: 0) {
            Circle()
                .fill(Color.error)
                .frame(width: 8, height: 8)
                .offset(x: 36)

            Rectangle()
                .fill(Color.error)
                .frame(height: 1.5)
        }
        .offset(y: yOffset)
    }

    // MARK: - 시간 라벨

    private func hourLabel(_ hour: Int) -> String {
        if hour == 0 { return "오전 12" }
        if hour < 12 { return "오전 \(hour)" }
        if hour == 12 { return "오후 12" }
        return "오후 \(hour - 12)"
    }
}
