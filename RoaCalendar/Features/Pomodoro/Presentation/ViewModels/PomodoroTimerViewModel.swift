import SwiftUI
import Observation

// MARK: - 뽀모도로 타이머 ViewModel

@MainActor
@Observable
final class PomodoroTimerViewModel {

    enum TimerState {
        case idle
        case running
        case paused
        case overflow
        case onBreak
    }

    var state: TimerState = .idle
    var remainingSeconds: Int = 25 * 60
    var totalSeconds: Int = 25 * 60
    var sessionNumber: Int = 1
    var totalSessions: Int = 4
    var selectedTask: String? = "기획안 작성"
    var presetName: String = "클래식 25/5"
    var ambientSound: String? = "빗소리"

    // MARK: - 계산 프로퍼티

    var progress: Double {
        guard totalSeconds > 0 else { return 0 }
        return 1.0 - Double(remainingSeconds) / Double(totalSeconds)
    }

    var timeDisplay: String {
        let minutes = remainingSeconds / 60
        let seconds = remainingSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    var stateLabel: String {
        switch state {
        case .idle: "시작 대기"
        case .running: "집중 중"
        case .paused: "일시정지"
        case .overflow: "오버플로우"
        case .onBreak: "휴식 중"
        }
    }

    var sessionLabel: String { "세션 \(sessionNumber)/\(totalSessions)" }

    var isRunning: Bool { state == .running || state == .overflow }

    // MARK: - 액션

    func start() {
        state = .running
    }

    func pause() {
        state = .paused
    }

    func resume() {
        state = .running
    }

    func stop() {
        state = .idle
        remainingSeconds = totalSeconds
    }

    func skip() {
        state = .onBreak
        remainingSeconds = 5 * 60
        totalSeconds = 5 * 60
    }
}
