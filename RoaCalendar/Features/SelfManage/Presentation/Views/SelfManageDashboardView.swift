import SwiftUI

// MARK: - 자기관리 대시보드

struct SelfManageDashboardView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var scorePercent: Int?

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: Spacing.md) {
                    scoreCard
                    todaySummary
                    energyCheckIn
                    sectionNav
                    insightCard
                }
                .padding(.horizontal, Spacing.md)
                .padding(.bottom, Spacing.xxxl)
            }
            .background(Color.bgLight)
            .navigationTitle("자기관리")
            .navigationBarTitleDisplayMode(.large)
            .onAppear { loadScore() }
        }
    }

    private func loadScore() {
        let service = PerformanceScoreService(context: modelContext)
        let score = service.calculateTodayScore()
        scorePercent = score.displayPercent
    }

    private var scoreColor: Color {
        guard let s = scorePercent else { return .neutral400 }
        if s >= 80 { return .success }
        if s >= 60 { return .warning }
        return .error
    }

    // MARK: - 성과 점수 카드

    private var scoreCard: some View {
        VStack(spacing: Spacing.xs) {
            Text("오늘의 성과")
                .font(.roaCaption)
                .foregroundStyle(Color.neutral400)

            Text(scorePercent.map { "\($0)%" } ?? "—")
                .font(.system(size: 52, weight: .heavy))
                .foregroundStyle(scoreColor)
                .monospacedDigit()

            HStack(spacing: Spacing.md) {
                statChip(emoji: "🍅", text: "4/5 세션")
                statChip(emoji: "☑️", text: "8/10 완료")
                statChip(emoji: "📅", text: "3/3 참석")
            }
        }
        .padding(Spacing.lg)
        .frame(maxWidth: .infinity)
        .background(Color.surfaceLight)
        .clipShape(RoundedRectangle(cornerRadius: Radius.lg))
        .shadow(color: .black.opacity(0.04), radius: 4, y: 2)
    }

    // MARK: - 오늘 요약

    private var todaySummary: some View {
        HStack(spacing: Spacing.md) {
            miniStatCard(title: "집중", value: "1.8h", icon: "🍅")
            miniStatCard(title: "완료", value: "80%", icon: "☑️")
            miniStatCard(title: "에너지", value: "4.2", icon: "⚡")
        }
    }

    // MARK: - 에너지 체크인

    private var energyCheckIn: some View {
        VStack(spacing: Spacing.sm) {
            HStack {
                Text("에너지 레벨")
                    .font(.system(size: 14, weight: .semibold))
                Spacer()
                Text("오후 체크인")
                    .font(.roaCaption)
                    .foregroundStyle(Color.neutral400)
            }

            HStack(spacing: Spacing.sm) {
                ForEach(["😴", "😐", "🙂", "😊", "🔥"], id: \.self) { emoji in
                    Text(emoji)
                        .font(.system(size: 28))
                        .padding(Spacing.xs)
                        .background(emoji == "😊" ? Color.primary600.opacity(0.1) : Color.clear)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .strokeBorder(emoji == "😊" ? Color.primary600 : Color.clear, lineWidth: 2)
                        )
                }
            }
        }
        .padding(Spacing.md)
        .background(Color.surfaceLight)
        .clipShape(RoundedRectangle(cornerRadius: Radius.lg))
        .shadow(color: .black.opacity(0.04), radius: 4, y: 2)
    }

    // MARK: - 섹션 네비게이션 (2x2)

    private var sectionNav: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: Spacing.sm) {
            navCard(icon: "chart.bar.fill", title: "통계", color: .primary600)
            navCard(icon: "checkmark.circle.fill", title: "리뷰", color: .success)
            navCard(icon: "target", title: "목표", color: .accent500)
            navCard(icon: "leaf.fill", title: "습관", color: .info)
        }
    }

    // MARK: - 인사이트 카드

    private var insightCard: some View {
        VStack(alignment: .leading, spacing: Spacing.xs) {
            Text("💡 집중 인사이트")
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(Color.primary600)
            Text("오전 10~12시에 3세션 연속 완료 — 가장 집중력 높은 시간입니다.")
                .font(.roaCaption)
                .foregroundStyle(Color.neutral600)
        }
        .padding(Spacing.sm + 4)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.primary600.opacity(0.06))
        .clipShape(RoundedRectangle(cornerRadius: Radius.md))
        .overlay(
            RoundedRectangle(cornerRadius: Radius.md)
                .strokeBorder(Color.primary600.opacity(0.15), lineWidth: 1)
        )
    }

    // MARK: - 컴포넌트

    private func statChip(emoji: String, text: String) -> some View {
        HStack(spacing: Spacing.xxs) {
            Text(emoji).font(.system(size: 12))
            Text(text)
                .font(.system(size: 12))
                .foregroundStyle(Color.neutral600)
        }
    }

    private func miniStatCard(title: String, value: String, icon: String) -> some View {
        VStack(spacing: Spacing.xs) {
            Text(icon).font(.system(size: 20))
            Text(value)
                .font(.system(size: 17, weight: .bold))
                .monospacedDigit()
            Text(title)
                .font(.roaCaption)
                .foregroundStyle(Color.neutral400)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, Spacing.sm + 4)
        .background(Color.surfaceLight)
        .clipShape(RoundedRectangle(cornerRadius: Radius.md))
        .shadow(color: .black.opacity(0.04), radius: 2, y: 1)
    }

    private func navCard(icon: String, title: String, color: Color) -> some View {
        VStack(spacing: Spacing.sm) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundStyle(color)
            Text(title)
                .font(.system(size: 14, weight: .semibold))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, Spacing.lg)
        .background(Color.surfaceLight)
        .clipShape(RoundedRectangle(cornerRadius: Radius.md))
        .shadow(color: .black.opacity(0.04), radius: 2, y: 1)
    }
}

#Preview {
    SelfManageDashboardView()
}
