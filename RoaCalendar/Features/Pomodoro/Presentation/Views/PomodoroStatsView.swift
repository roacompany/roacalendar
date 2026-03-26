import SwiftUI

// MARK: - 뽀모도로 통계 화면

struct PomodoroStatsView: View {
    @State private var selectedTab = 1 // 0=일간, 1=주간, 2=월간

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: Spacing.md) {
                    tabSelector
                    weeklyChart
                    statsCards
                    categorySection
                    streakSection
                    goalSection
                }
                .padding(.horizontal, Spacing.md)
                .padding(.bottom, Spacing.xxxl)
            }
            .background(Color.bgLight)
            .navigationTitle("집중 통계")
            .navigationBarTitleDisplayMode(.large)
        }
    }

    // MARK: - 탭

    private var tabSelector: some View {
        HStack(spacing: Spacing.xs) {
            ForEach(["일간", "주간", "월간"], id: \.self) { tab in
                let index = ["일간", "주간", "월간"].firstIndex(of: tab) ?? 0
                Text(tab)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(selectedTab == index ? .white : Color.neutral400)
                    .padding(.horizontal, Spacing.md)
                    .padding(.vertical, Spacing.xs + 2)
                    .background(selectedTab == index ? Color.primary600 : Color.clear)
                    .clipShape(Capsule())
                    .onTapGesture { withAnimation { selectedTab = index } }
            }
        }
    }

    // MARK: - 주간 바 차트

    struct ChartData: Identifiable {
        let id: String
        let focus: Double
        let overflow: Double
        init(_ day: String, _ focus: Double, _ overflow: Double) {
            self.id = day; self.focus = focus; self.overflow = overflow
        }
    }

    private var weeklyChart: some View {
        let data: [ChartData] = [
            ChartData("월", 1.5, 0.2), ChartData("화", 2.0, 0.5), ChartData("수", 1.8, 0.0),
            ChartData("목", 2.5, 0.3), ChartData("금", 1.0, 0.0), ChartData("토", 0.5, 0.0), ChartData("일", 0.0, 0.0)
        ]
        let maxVal = 3.0

        return VStack(alignment: .leading, spacing: Spacing.sm) {
            Text("이번 주 집중 시간")
                .font(.system(size: 15, weight: .semibold))

            HStack(alignment: .bottom, spacing: Spacing.sm) {
                ForEach(Array(data.enumerated()), id: \.offset) { index, item in
                    VStack(spacing: Spacing.xxs) {
                        ZStack(alignment: .bottom) {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.neutral100)
                                .frame(width: 32, height: 120)

                            VStack(spacing: 0) {
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(Color.accent500)
                                    .frame(width: 32, height: max(CGFloat(item.overflow / maxVal) * 120, 0))

                                RoundedRectangle(cornerRadius: 4)
                                    .fill(Color.primary600)
                                    .frame(width: 32, height: max(CGFloat(item.focus / maxVal) * 120, 0))
                            }
                        }

                        Text(item.id)
                            .font(.system(size: 11, weight: index == 3 ? .bold : .medium))
                            .foregroundStyle(index == 3 ? Color.primary600 : Color.neutral400)
                    }
                }
            }
            .frame(maxWidth: .infinity)

            HStack(spacing: Spacing.md) {
                HStack(spacing: Spacing.xs) {
                    Circle().fill(Color.primary600).frame(width: 8, height: 8)
                    Text("집중").font(.roaCaption).foregroundStyle(Color.neutral400)
                }
                HStack(spacing: Spacing.xs) {
                    Circle().fill(Color.accent500).frame(width: 8, height: 8)
                    Text("초과").font(.roaCaption).foregroundStyle(Color.neutral400)
                }
            }
        }
        .padding(Spacing.md)
        .background(Color.surfaceLight)
        .clipShape(RoundedRectangle(cornerRadius: Radius.lg))
        .shadow(color: .black.opacity(0.04), radius: 4, y: 2)
    }

    // MARK: - 통계 카드

    private var statsCards: some View {
        HStack(spacing: Spacing.sm) {
            statCard(value: "12.5h", label: "이번 주")
            statCard(value: "1.8h", label: "일 평균")
            statCard(value: "82%", label: "완료율")
        }
    }

    // MARK: - 카테고리

    private var categorySection: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text("카테고리별 분포")
                .font(.system(size: 15, weight: .semibold))

            HStack(spacing: Spacing.md) {
                VStack(spacing: Spacing.xs) {
                    categoryBar(label: "업무", percent: 60, color: .primary600)
                    categoryBar(label: "학습", percent: 25, color: .accent500)
                    categoryBar(label: "기타", percent: 15, color: .neutral400)
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding(Spacing.md)
        .background(Color.surfaceLight)
        .clipShape(RoundedRectangle(cornerRadius: Radius.lg))
        .shadow(color: .black.opacity(0.04), radius: 4, y: 2)
    }

    // MARK: - 스트릭

    private var streakSection: some View {
        HStack {
            Text("🔥")
                .font(.system(size: 28))
            VStack(alignment: .leading, spacing: Spacing.xxs) {
                Text("현재 8일 연속")
                    .font(.system(size: 15, weight: .semibold))
                Text("최장 15일")
                    .font(.roaCaption)
                    .foregroundStyle(Color.neutral400)
            }
            Spacer()
        }
        .padding(Spacing.md)
        .background(Color.surfaceLight)
        .clipShape(RoundedRectangle(cornerRadius: Radius.lg))
        .shadow(color: .black.opacity(0.04), radius: 4, y: 2)
    }

    // MARK: - 주간 목표

    private var goalSection: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            HStack {
                Text("주간 목표")
                    .font(.system(size: 15, weight: .semibold))
                Spacer()
                Text("12.5 / 20시간")
                    .font(.roaCaption)
                    .foregroundStyle(Color.neutral400)
                    .monospacedDigit()
            }

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color.neutral100)
                        .frame(height: 12)
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color.primary600)
                        .frame(width: geo.size.width * 0.63, height: 12)
                }
            }
            .frame(height: 12)

            Text("63% 달성")
                .font(.roaCaption)
                .foregroundStyle(Color.primary600)
                .fontWeight(.semibold)
        }
        .padding(Spacing.md)
        .background(Color.surfaceLight)
        .clipShape(RoundedRectangle(cornerRadius: Radius.lg))
        .shadow(color: .black.opacity(0.04), radius: 4, y: 2)
    }

    // MARK: - 컴포넌트

    private func statCard(value: String, label: String) -> some View {
        VStack(spacing: Spacing.xs) {
            Text(value)
                .font(.system(size: 20, weight: .bold))
                .monospacedDigit()
            Text(label)
                .font(.roaCaption)
                .foregroundStyle(Color.neutral400)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, Spacing.sm + 4)
        .background(Color.surfaceLight)
        .clipShape(RoundedRectangle(cornerRadius: Radius.md))
        .shadow(color: .black.opacity(0.04), radius: 2, y: 1)
    }

    private func categoryBar(label: String, percent: Int, color: Color) -> some View {
        HStack(spacing: Spacing.sm) {
            Text(label)
                .font(.system(size: 12, weight: .medium))
                .frame(width: 40, alignment: .leading)
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.neutral100)
                    RoundedRectangle(cornerRadius: 4)
                        .fill(color)
                        .frame(width: geo.size.width * CGFloat(percent) / 100)
                }
            }
            .frame(height: 8)
            Text("\(percent)%")
                .font(.system(size: 11, weight: .semibold))
                .foregroundStyle(Color.neutral400)
                .monospacedDigit()
                .frame(width: 32, alignment: .trailing)
        }
    }
}

#Preview {
    PomodoroStatsView()
}
