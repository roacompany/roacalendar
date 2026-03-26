import SwiftUI

// MARK: - 뽀모도로 세션 기록 (전/후)

struct PomodoroSessionRecordView: View {
    @State private var intention = ""
    @State private var reflection = ""
    @State private var selectedPreset = 0

    let presets = ["클래식 25/5", "숏 15/5", "확장 50/10", "52/17", "울트라 90/20", "커스텀"]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: Spacing.lg) {
                    preSession
                    divider
                    postSession
                }
                .padding(.horizontal, Spacing.md)
                .padding(.bottom, Spacing.xxxl)
            }
            .background(Color.bgLight)
            .navigationTitle("세션 기록")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    // MARK: - 세션 전

    private var preSession: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            Text("세션 시작 전")
                .font(.roaHeadline)

            VStack(alignment: .leading, spacing: Spacing.xs) {
                Text("무엇에 집중할 것인가?")
                    .font(.roaCaption)
                    .foregroundStyle(Color.neutral400)
                TextField("오늘의 집중 목표", text: $intention)
                    .font(.roaBody)
                    .padding(Spacing.sm + 4)
                    .background(Color.surfaceLight)
                    .clipShape(RoundedRectangle(cornerRadius: Radius.md))
            }

            Button {} label: {
                HStack {
                    Image(systemName: "checkmark.circle")
                    Text("할 일에서 선택")
                }
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(Color.primary600)
                .padding(Spacing.sm + 4)
                .frame(maxWidth: .infinity)
                .background(Color.primary600.opacity(0.06))
                .clipShape(RoundedRectangle(cornerRadius: Radius.md))
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: Spacing.sm) {
                    ForEach(Array(presets.enumerated()), id: \.offset) { index, name in
                        Text(name)
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundStyle(selectedPreset == index ? .white : Color.neutral600)
                            .padding(.horizontal, Spacing.sm + 4)
                            .padding(.vertical, Spacing.xs + 2)
                            .background(selectedPreset == index ? Color.accent500 : Color.neutral100)
                            .clipShape(Capsule())
                            .onTapGesture { selectedPreset = index }
                    }
                }
            }

            Button {} label: {
                Text("🍅 집중 시작")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, Spacing.sm + 6)
                    .background(Color.accent500)
                    .clipShape(Capsule())
            }
        }
    }

    // MARK: - 구분선

    private var divider: some View {
        HStack {
            Rectangle().fill(Color.neutral200).frame(height: 1)
            Text("세션 완료 후")
                .font(.roaCaption)
                .foregroundStyle(Color.neutral400)
                .fixedSize()
            Rectangle().fill(Color.neutral200).frame(height: 1)
        }
    }

    // MARK: - 세션 후

    private var postSession: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            VStack(spacing: Spacing.xs) {
                Text("25분 집중 완료 🎉")
                    .font(.roaTitle2)
                HStack(spacing: Spacing.md) {
                    Text("계획: 25:00")
                        .font(.roaCaption)
                        .foregroundStyle(Color.neutral400)
                    Text("실제: 27:34")
                        .font(.roaCaption)
                        .foregroundStyle(Color.accent500)
                        .fontWeight(.semibold)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(Spacing.md)
            .background(Color.surfaceLight)
            .clipShape(RoundedRectangle(cornerRadius: Radius.lg))

            VStack(alignment: .leading, spacing: Spacing.xs) {
                Text("무엇을 달성했는가?")
                    .font(.roaCaption)
                    .foregroundStyle(Color.neutral400)
                TextField("오늘의 성과", text: $reflection)
                    .font(.roaBody)
                    .padding(Spacing.sm + 4)
                    .background(Color.surfaceLight)
                    .clipShape(RoundedRectangle(cornerRadius: Radius.md))
            }

            HStack(spacing: Spacing.sm) {
                Button {} label: {
                    Text("저장")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, Spacing.sm + 4)
                        .background(Color.primary600)
                        .clipShape(Capsule())
                }

                Button {} label: {
                    Text("건너뛰기")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(Color.primary600)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, Spacing.sm + 4)
                        .background(Color.clear)
                        .clipShape(Capsule())
                        .overlay(Capsule().strokeBorder(Color.primary600, lineWidth: 1.5))
                }
            }
        }
    }
}

#Preview {
    PomodoroSessionRecordView()
}
