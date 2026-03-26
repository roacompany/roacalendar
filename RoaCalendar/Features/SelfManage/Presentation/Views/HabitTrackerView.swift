import SwiftUI

// MARK: - 습관 트래커

struct HabitTrackerView: View {
    struct HabitItem: Identifiable {
        let id = UUID()
        let emoji: String
        let title: String
        var isDone: Bool
        let streak: String?
    }

    @State private var habits: [HabitItem] = [
        HabitItem(emoji: "💪", title: "운동 30분", isDone: true, streak: "🔥 12일"),
        HabitItem(emoji: "📚", title: "독서 20분", isDone: true, streak: "🔥 5일"),
        HabitItem(emoji: "🧘", title: "명상 10분", isDone: false, streak: nil),
        HabitItem(emoji: "💧", title: "물 8잔", isDone: false, streak: nil),
        HabitItem(emoji: "📝", title: "일기 쓰기", isDone: false, streak: nil)
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: Spacing.md) {
                    todayChecklist
                    heatmapSection
                    correlationCard
                    addButton
                }
                .padding(.horizontal, Spacing.md)
                .padding(.bottom, Spacing.xxxl)
            }
            .background(Color.bgLight)
            .navigationTitle("습관")
            .navigationBarTitleDisplayMode(.large)
        }
    }

    // MARK: - 오늘 체크리스트

    private var todayChecklist: some View {
        VStack(spacing: 0) {
            ForEach(Array(habits.enumerated()), id: \.offset) { index, habit in
                HStack(spacing: Spacing.sm) {
                    Text(habit.emoji).font(.system(size: 22))

                    Text(habit.title)
                        .font(.system(size: 15, weight: .medium))
                        .strikethrough(habit.isDone)
                        .foregroundStyle(habit.isDone ? Color.neutral400 : Color.neutral900)

                    Spacer()

                    if let streak = habit.streak {
                        Text(streak)
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundStyle(Color.success)
                    }

                    Circle()
                        .strokeBorder(habit.isDone ? Color.success : Color.neutral200, lineWidth: 2)
                        .background(Circle().fill(habit.isDone ? Color.success : Color.clear))
                        .frame(width: 24, height: 24)
                        .overlay {
                            if habit.isDone {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 11, weight: .bold))
                                    .foregroundStyle(.white)
                            }
                        }
                        .onTapGesture {
                            withAnimation(.spring(duration: 0.2)) {
                                habits[index].isDone.toggle()
                            }
                        }
                }
                .padding(.vertical, Spacing.sm + 2)

                if index < habits.count - 1 {
                    Divider()
                }
            }
        }
        .padding(.horizontal, Spacing.md)
        .background(Color.surfaceLight)
        .clipShape(RoundedRectangle(cornerRadius: Radius.lg))
        .shadow(color: .black.opacity(0.04), radius: 4, y: 2)
    }

    // MARK: - 히트맵 (GitHub 잔디)

    private var heatmapSection: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text("연간 기록")
                .font(.system(size: 15, weight: .semibold))

            let columns = Array(repeating: GridItem(.flexible(), spacing: 2), count: 52)

            ScrollView(.horizontal, showsIndicators: false) {
                LazyHGrid(rows: Array(repeating: GridItem(.fixed(10), spacing: 2), count: 7), spacing: 2) {
                    ForEach(0..<364, id: \.self) { day in
                        let intensity = heatmapIntensity(day: day)
                        RoundedRectangle(cornerRadius: 2)
                            .fill(heatmapColor(intensity: intensity))
                            .frame(width: 10, height: 10)
                    }
                }
            }
            .frame(height: 82)

            HStack(spacing: Spacing.xs) {
                Text("적음").font(.system(size: 9)).foregroundStyle(Color.neutral400)
                ForEach([0.0, 0.25, 0.5, 0.75, 1.0], id: \.self) { intensity in
                    RoundedRectangle(cornerRadius: 2)
                        .fill(heatmapColor(intensity: intensity))
                        .frame(width: 10, height: 10)
                }
                Text("많음").font(.system(size: 9)).foregroundStyle(Color.neutral400)
            }
        }
        .padding(Spacing.md)
        .background(Color.surfaceLight)
        .clipShape(RoundedRectangle(cornerRadius: Radius.lg))
        .shadow(color: .black.opacity(0.04), radius: 4, y: 2)
    }

    // MARK: - 습관-에너지 상관분석

    private var correlationCard: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text("습관-에너지 상관관계")
                .font(.system(size: 15, weight: .semibold))

            HStack(spacing: Spacing.lg) {
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    Text("운동한 날")
                        .font(.roaCaption)
                        .foregroundStyle(Color.neutral400)
                    Text("에너지 4.2")
                        .font(.system(size: 17, weight: .bold))
                        .foregroundStyle(Color.success)
                }

                VStack(alignment: .leading, spacing: Spacing.xs) {
                    Text("안 한 날")
                        .font(.roaCaption)
                        .foregroundStyle(Color.neutral400)
                    Text("에너지 2.8")
                        .font(.system(size: 17, weight: .bold))
                        .foregroundStyle(Color.neutral600)
                }

                Text("+50%")
                    .font(.system(size: 20, weight: .heavy))
                    .foregroundStyle(Color.success)
            }
        }
        .padding(Spacing.md)
        .background(Color.surfaceLight)
        .clipShape(RoundedRectangle(cornerRadius: Radius.lg))
        .shadow(color: .black.opacity(0.04), radius: 4, y: 2)
    }

    // MARK: - 추가 버튼

    private var addButton: some View {
        Button {} label: {
            HStack {
                Image(systemName: "plus.circle.dashed")
                Text("습관 추가")
            }
            .font(.system(size: 15, weight: .medium))
            .foregroundStyle(Color.primary600)
            .frame(maxWidth: .infinity)
            .padding(.vertical, Spacing.sm + 4)
            .background(Color.primary600.opacity(0.06))
            .clipShape(RoundedRectangle(cornerRadius: Radius.md))
            .overlay(
                RoundedRectangle(cornerRadius: Radius.md)
                    .strokeBorder(Color.primary600.opacity(0.2), style: StrokeStyle(lineWidth: 1, dash: [6]))
            )
        }
    }

    // MARK: - 헬퍼

    private func heatmapIntensity(day: Int) -> Double {
        if day > 350 { return 0.0 }
        let seed = (day * 7 + 13) % 100
        if seed < 30 { return 0.0 }
        if seed < 50 { return 0.25 }
        if seed < 70 { return 0.5 }
        if seed < 85 { return 0.75 }
        return 1.0
    }

    private func heatmapColor(intensity: Double) -> Color {
        if intensity <= 0 { return Color.neutral100 }
        return Color.success.opacity(0.2 + intensity * 0.8)
    }
}

#Preview {
    HabitTrackerView()
}
