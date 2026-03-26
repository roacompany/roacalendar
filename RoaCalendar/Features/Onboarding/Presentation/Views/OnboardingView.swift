import SwiftUI

// MARK: - 온보딩 화면

struct OnboardingView: View {
    @State private var currentStep = 0
    @Binding var hasCompletedOnboarding: Bool

    struct FeatureItem {
        let icon: String
        let title: String
        let description: String
    }

    let features: [FeatureItem] = [
        FeatureItem(icon: "📅", title: "캘린더", description: "구글 캘린더 수준의 일정 관리"),
        FeatureItem(icon: "🍅", title: "집중", description: "뽀모도로 타이머로 생산성 향상"),
        FeatureItem(icon: "☑️", title: "할 일", description: "3가지 날짜 시스템으로 체계적 관리"),
        FeatureItem(icon: "📊", title: "자기관리", description: "통계, 리뷰, 목표로 성장 추적")
    ]

    var body: some View {
        VStack(spacing: 0) {
            if currentStep == 0 {
                welcomeScreen
            } else if currentStep <= 4 {
                featureScreen(index: currentStep - 1)
            } else {
                completeScreen
            }
        }
        .background(Color.bgLight)
        .animation(.spring(duration: 0.3), value: currentStep)
    }

    // MARK: - 환영

    private var welcomeScreen: some View {
        VStack(spacing: Spacing.lg) {
            Spacer()

            Text("📅")
                .font(.system(size: 80))

            Text("로아 캘린더")
                .font(.system(size: 36, weight: .heavy))

            Text("일정을 정리하세요")
                .font(.roaBody)
                .foregroundStyle(Color.neutral600)

            Spacer()

            Button {
                currentStep = 1
            } label: {
                Text("시작하기")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, Spacing.sm + 6)
                    .background(Color.primary600)
                    .clipShape(Capsule())
            }
            .padding(.horizontal, Spacing.lg)
            .padding(.bottom, Spacing.xxxl)
        }
    }

    // MARK: - 기능 소개

    private func featureScreen(index: Int) -> some View {
        let feature = features[index]

        return VStack(spacing: Spacing.lg) {
            HStack {
                Spacer()
                Button("건너뛰기") {
                    currentStep = 5
                }
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(Color.neutral400)
            }
            .padding(.horizontal, Spacing.md)
            .padding(.top, Spacing.sm)

            Spacer()

            Text(feature.icon)
                .font(.system(size: 80))

            Text(feature.title)
                .font(.system(size: 28, weight: .bold))

            Text(feature.description)
                .font(.roaBody)
                .foregroundStyle(Color.neutral600)

            Spacer()

            HStack(spacing: Spacing.sm) {
                ForEach(0..<4, id: \.self) { i in
                    Capsule()
                        .fill(i == index ? Color.primary600 : Color.neutral200)
                        .frame(width: i == index ? 24 : 8, height: 8)
                }
            }

            Button {
                currentStep += 1
            } label: {
                Text(index < 3 ? "다음" : "시작")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, Spacing.sm + 6)
                    .background(Color.primary600)
                    .clipShape(Capsule())
            }
            .padding(.horizontal, Spacing.lg)
            .padding(.bottom, Spacing.xxxl)
        }
    }

    // MARK: - 완료

    private var completeScreen: some View {
        VStack(spacing: Spacing.lg) {
            Spacer()

            Text("✅")
                .font(.system(size: 80))

            Text("준비 완료!")
                .font(.system(size: 28, weight: .bold))

            Text("로아 캘린더를 시작하세요")
                .font(.roaBody)
                .foregroundStyle(Color.neutral600)

            Spacer()

            Button {
                hasCompletedOnboarding = true
            } label: {
                Text("시작")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, Spacing.sm + 6)
                    .background(Color.primary600)
                    .clipShape(Capsule())
            }
            .padding(.horizontal, Spacing.lg)
            .padding(.bottom, Spacing.xxxl)
        }
    }
}

#Preview {
    OnboardingView(hasCompletedOnboarding: .constant(false))
}
