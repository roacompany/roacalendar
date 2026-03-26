import SwiftUI

// MARK: - 아이젠하워 매트릭스 뷰

struct EisenhowerMatrixView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                axisLabels
                matrixGrid
            }
            .background(Color.bgLight)
            .navigationTitle("아이젠하워 매트릭스")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    // MARK: - 축 라벨

    private var axisLabels: some View {
        HStack {
            Spacer()
            Text("긴급")
                .font(.system(size: 11, weight: .semibold))
                .foregroundStyle(Color.neutral400)
            Spacer()
            Text("긴급하지 않음")
                .font(.system(size: 11, weight: .semibold))
                .foregroundStyle(Color.neutral400)
            Spacer()
        }
        .padding(.top, Spacing.sm)
    }

    // MARK: - 2x2 그리드

    private var matrixGrid: some View {
        VStack(spacing: Spacing.sm) {
            HStack(spacing: Spacing.sm) {
                quadrant(
                    title: "즉시 실행",
                    subtitle: "긴급 + 중요",
                    color: .error,
                    tasks: ["기획안 최종 제출", "서버 장애 대응"]
                )
                quadrant(
                    title: "일정 잡기",
                    subtitle: "중요 + 긴급하지 않음",
                    color: .primary600,
                    tasks: ["주간 보고서 작성", "운동 루틴", "독서"]
                )
            }

            HStack(spacing: Spacing.sm) {
                quadrant(
                    title: "위임",
                    subtitle: "긴급 + 중요하지 않음",
                    color: .accent500,
                    tasks: ["이메일 정리", "회의 자료 복사"]
                )
                quadrant(
                    title: "제거",
                    subtitle: "긴급하지 않음 + 중요하지 않음",
                    color: .neutral400,
                    tasks: ["SNS 확인"]
                )
            }
        }
        .padding(Spacing.md)
    }

    // MARK: - 쿼드런트

    private func quadrant(title: String, subtitle: String, color: Color, tasks: [String]) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text(title)
                    .font(.system(size: 13, weight: .bold))
                    .foregroundStyle(.white)
                Spacer()
                Text("\(tasks.count)")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundStyle(.white.opacity(0.8))
            }
            .padding(.horizontal, Spacing.sm)
            .padding(.vertical, Spacing.xs + 2)
            .background(color)

            VStack(alignment: .leading, spacing: Spacing.xs) {
                Text(subtitle)
                    .font(.system(size: 9, weight: .medium))
                    .foregroundStyle(Color.neutral400)
                    .padding(.top, Spacing.xs)

                ForEach(tasks, id: \.self) { task in
                    HStack(spacing: Spacing.sm) {
                        Circle()
                            .strokeBorder(Color.neutral200, lineWidth: 1.5)
                            .frame(width: 16, height: 16)
                        Text(task)
                            .font(.system(size: 12, weight: .medium))
                            .lineLimit(1)
                    }
                }
            }
            .padding(.horizontal, Spacing.sm)
            .padding(.bottom, Spacing.sm)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(Color.surfaceLight)
        .clipShape(RoundedRectangle(cornerRadius: Radius.md))
        .shadow(color: .black.opacity(0.04), radius: 2, y: 1)
    }
}

#Preview {
    EisenhowerMatrixView()
}
