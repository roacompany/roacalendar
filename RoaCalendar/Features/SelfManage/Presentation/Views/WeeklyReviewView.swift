import SwiftUI

// MARK: - 주간 리뷰

struct WeeklyReviewView: View {
    @State private var wellDone = ""
    @State private var blocked = ""
    @State private var nextPriority = ""

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: Spacing.md) {
                    autoStats
                    incompleteTasksSection
                    weeklySummary
                    reflectionSection
                    completeButton
                }
                .padding(.horizontal, Spacing.md)
                .padding(.bottom, Spacing.xxxl)
            }
            .background(Color.bgLight)
            .navigationTitle("주간 리뷰")
            .navigationBarTitleDisplayMode(.large)
        }
    }

    // MARK: - 자동 집계

    private var autoStats: some View {
        VStack(spacing: Spacing.sm) {
            statRow(label: "Task 완료율", value: "34/42 (81%)", progress: 0.81, color: .primary600)
            statRow(label: "집중 시간", value: "12.5시간 (25세션)", progress: 0.63, color: .accent500)
            statRow(label: "에너지 평균", value: "3.4/5", progress: 0.68, color: .success)
            statRow(label: "성과 점수", value: "72%", progress: 0.72, color: .primary600)
        }
        .padding(Spacing.md)
        .background(Color.surfaceLight)
        .clipShape(RoundedRectangle(cornerRadius: Radius.lg))
        .shadow(color: .black.opacity(0.04), radius: 4, y: 2)
    }

    // MARK: - 미완료 Task

    private var incompleteTasksSection: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text("미완료 Task (8개)")
                .font(.system(size: 15, weight: .semibold))

            ForEach(["디자인 리뷰", "테스트 코드 작성", "문서 업데이트"], id: \.self) { task in
                HStack {
                    Text(task)
                        .font(.system(size: 14, weight: .medium))
                    Spacer()
                    HStack(spacing: Spacing.xs) {
                        miniAction("이월", color: .primary600)
                        miniAction("나중에", color: .neutral400)
                        miniAction("삭제", color: .error)
                    }
                }
                .padding(.vertical, Spacing.xs)
            }
        }
        .padding(Spacing.md)
        .background(Color.surfaceLight)
        .clipShape(RoundedRectangle(cornerRadius: Radius.lg))
        .shadow(color: .black.opacity(0.04), radius: 4, y: 2)
    }

    // MARK: - 주간 한 줄 요약

    private var weeklySummary: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text("주간 요약")
                .font(.system(size: 15, weight: .semibold))
            Text("이번 주: 25세션, 34태스크 완료(81%), 에너지 평균 3.4/5")
                .font(.roaCaption)
                .foregroundStyle(Color.neutral600)
                .padding(Spacing.sm + 4)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.neutral100)
                .clipShape(RoundedRectangle(cornerRadius: Radius.md))
        }
        .padding(Spacing.md)
        .background(Color.surfaceLight)
        .clipShape(RoundedRectangle(cornerRadius: Radius.lg))
        .shadow(color: .black.opacity(0.04), radius: 4, y: 2)
    }

    // MARK: - 회고

    private var reflectionSection: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            reflectionField(label: "이번 주 잘한 점은?", text: $wellDone)
            reflectionField(label: "무엇이 막혔나?", text: $blocked)
            reflectionField(label: "다음 주 최우선 과제는?", text: $nextPriority)
        }
        .padding(Spacing.md)
        .background(Color.surfaceLight)
        .clipShape(RoundedRectangle(cornerRadius: Radius.lg))
        .shadow(color: .black.opacity(0.04), radius: 4, y: 2)
    }

    // MARK: - 완료 버튼

    private var completeButton: some View {
        Button {} label: {
            Text("리뷰 완료")
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, Spacing.sm + 6)
                .background(Color.primary600)
                .clipShape(Capsule())
        }
    }

    // MARK: - 컴포넌트

    private func statRow(label: String, value: String, progress: Double, color: Color) -> some View {
        VStack(alignment: .leading, spacing: Spacing.xs) {
            HStack {
                Text(label).font(.system(size: 13, weight: .medium)).foregroundStyle(Color.neutral600)
                Spacer()
                Text(value).font(.system(size: 13, weight: .semibold)).monospacedDigit()
            }
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4).fill(Color.neutral100).frame(height: 6)
                    RoundedRectangle(cornerRadius: 4).fill(color).frame(width: geo.size.width * progress, height: 6)
                }
            }
            .frame(height: 6)
        }
    }

    private func miniAction(_ title: String, color: Color) -> some View {
        Text(title)
            .font(.system(size: 10, weight: .semibold))
            .foregroundStyle(color)
            .padding(.horizontal, Spacing.sm)
            .padding(.vertical, Spacing.xxs + 1)
            .background(color.opacity(0.1))
            .clipShape(Capsule())
    }

    private func reflectionField(label: String, text: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: Spacing.xs) {
            Text(label)
                .font(.system(size: 14, weight: .semibold))
            TextField("입력하세요", text: text)
                .font(.roaBody)
                .padding(Spacing.sm + 4)
                .background(Color.neutral100)
                .clipShape(RoundedRectangle(cornerRadius: Radius.md))
        }
    }
}

#Preview {
    WeeklyReviewView()
}
