import SwiftUI

// MARK: - 뽀모도로 타이머 메인 뷰

struct PomodoroTimerView: View {
    @State private var viewModel = PomodoroTimerViewModel()

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Spacer()
                timerRing
                taskChip
                controls
                presetChips
                sessionDots
                Spacer()
            }
            .background(Color.bgLight)
        }
    }

    // MARK: - 타이머 링

    private var timerRing: some View {
        ZStack {
            // 배경 링
            Circle()
                .stroke(Color.neutral200, lineWidth: 8)
                .frame(width: 220, height: 220)

            // 진행 링
            Circle()
                .trim(from: 0, to: viewModel.progress)
                .stroke(
                    Color.accent500,
                    style: StrokeStyle(lineWidth: 8, lineCap: .round)
                )
                .frame(width: 220, height: 220)
                .rotationEffect(.degrees(-90))
                .animation(.spring(duration: 0.3), value: viewModel.progress)

            // 중앙 텍스트
            VStack(spacing: Spacing.xs) {
                Text(viewModel.timeDisplay)
                    .font(.roaTimerDisplay)
                    .monospacedDigit()

                Text(viewModel.stateLabel)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.accent500)

                Text(viewModel.sessionLabel)
                    .font(.roaCaption)
                    .foregroundStyle(Color.neutral400)
            }
        }
    }

    // MARK: - 선택된 Task 칩

    private var taskChip: some View {
        Group {
            if let task = viewModel.selectedTask {
                HStack(spacing: Spacing.xs) {
                    Text("📝")
                    Text(task)
                        .font(.system(size: 14, weight: .medium))
                }
                .padding(.horizontal, Spacing.lg)
                .padding(.vertical, Spacing.sm)
                .background(Color.surfaceLight)
                .clipShape(Capsule())
                .shadow(color: .black.opacity(0.04), radius: 2, y: 1)
                .overlay(Capsule().strokeBorder(Color.neutral100, lineWidth: 1))
            }
        }
        .padding(.top, Spacing.lg)
    }

    // MARK: - 컨트롤 버튼

    private var controls: some View {
        HStack(spacing: Spacing.md) {
            controlButton(icon: "stop.fill", size: 56) {
                viewModel.stop()
            }
            .foregroundStyle(Color.neutral600)
            .background(Color.neutral100)
            .clipShape(Circle())

            Button {
                if viewModel.isRunning {
                    viewModel.pause()
                } else {
                    viewModel.start()
                }
            } label: {
                Image(systemName: viewModel.isRunning ? "pause.fill" : "play.fill")
                    .font(.system(size: 26))
                    .foregroundStyle(.white)
                    .frame(width: 64, height: 64)
                    .background(Color.accent500)
                    .clipShape(Circle())
                    .shadow(color: .accent500.opacity(0.3), radius: 8, y: 4)
            }

            controlButton(icon: "forward.fill", size: 56) {
                viewModel.skip()
            }
            .foregroundStyle(Color.neutral600)
            .background(Color.neutral100)
            .clipShape(Circle())
        }
        .padding(.top, Spacing.lg)
    }

    // MARK: - 프리셋/사운드 칩

    private var presetChips: some View {
        HStack(spacing: Spacing.sm) {
            chipView(emoji: "🍅", text: viewModel.presetName, color: .accent500)
            if let sound = viewModel.ambientSound {
                chipView(emoji: "☁️", text: sound, color: .primary600)
            }
        }
        .padding(.top, Spacing.lg)
    }

    // MARK: - 세션 진행 도트

    private var sessionDots: some View {
        HStack(spacing: Spacing.sm) {
            ForEach(1...viewModel.totalSessions, id: \.self) { session in
                Circle()
                    .fill(session <= viewModel.sessionNumber ? Color.accent500 : Color.neutral200)
                    .frame(width: 8, height: 8)
            }
        }
        .padding(.top, Spacing.lg)
    }

    // MARK: - 컴포넌트

    private func controlButton(icon: String, size: CGFloat, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .frame(width: size, height: size)
        }
    }

    private func chipView(emoji: String, text: String, color: Color) -> some View {
        HStack(spacing: Spacing.xs) {
            Text(emoji)
            Text(text)
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(color)
        }
        .padding(.horizontal, Spacing.sm + 4)
        .padding(.vertical, Spacing.xs + 2)
        .background(color.opacity(0.1))
        .clipShape(Capsule())
    }
}

#Preview {
    PomodoroTimerView()
}
