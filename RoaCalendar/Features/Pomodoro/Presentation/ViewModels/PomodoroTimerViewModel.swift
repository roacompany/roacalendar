import SwiftUI
import Observation

// MARK: - 뽀모도로 타이머 ViewModel (실제 카운트다운)

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

    // MARK: - 상태

    var state: TimerState = .idle
    var totalSeconds: Int = 25 * 60
    var sessionNumber: Int = 1
    var totalSessions: Int = 4
    var selectedTask: String? = nil
    var presetName: String = "클래식 25/5"
    var ambientSound: String? = nil

    // MARK: - 타이머 엔진 (Date 기반 재계산)

    private var sessionStartDate: Date?
    private var pauseStartDate: Date?
    private var accumulatedPauseSeconds: TimeInterval = 0
    private var timerTask: Task<Void, Never>?

    // MARK: - 계산 프로퍼티

    var elapsedSeconds: Int {
        guard let start = sessionStartDate else { return 0 }
        let elapsed = Date().timeIntervalSince(start) - accumulatedPauseSeconds
        if let pauseStart = pauseStartDate {
            let currentPause = Date().timeIntervalSince(pauseStart)
            return max(0, Int(elapsed - currentPause))
        }
        return max(0, Int(elapsed))
    }

    var remainingSeconds: Int {
        let remaining = totalSeconds - elapsedSeconds
        if remaining <= 0 && state == .running {
            return 0
        }
        return max(0, remaining)
    }

    var overflowSeconds: Int {
        guard state == .overflow else { return 0 }
        return max(0, elapsedSeconds - totalSeconds)
    }

    var progress: Double {
        guard totalSeconds > 0 else { return 0 }
        return min(1.0, Double(elapsedSeconds) / Double(totalSeconds))
    }

    var timeDisplay: String {
        let seconds = state == .overflow ? overflowSeconds : remainingSeconds
        let min = seconds / 60
        let sec = seconds % 60
        return String(format: "%02d:%02d", min, sec)
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

    // MARK: - 프리셋

    struct Preset {
        let name: String
        let focusMinutes: Int
        let shortBreakMinutes: Int
        let longBreakMinutes: Int?
    }

    static let presets: [Preset] = [
        Preset(name: "클래식 25/5", focusMinutes: 25, shortBreakMinutes: 5, longBreakMinutes: 15),
        Preset(name: "숏 15/5", focusMinutes: 15, shortBreakMinutes: 5, longBreakMinutes: 15),
        Preset(name: "확장 50/10", focusMinutes: 50, shortBreakMinutes: 10, longBreakMinutes: 20),
        Preset(name: "52/17", focusMinutes: 52, shortBreakMinutes: 17, longBreakMinutes: nil),
        Preset(name: "울트라 90/20", focusMinutes: 90, shortBreakMinutes: 20, longBreakMinutes: nil),
    ]

    // MARK: - 액션

    func selectPreset(_ preset: Preset) {
        guard state == .idle else { return }
        presetName = preset.name
        totalSeconds = preset.focusMinutes * 60
    }

    func start() {
        sessionStartDate = Date()
        accumulatedPauseSeconds = 0
        pauseStartDate = nil
        state = .running
        startTick()
    }

    func pause() {
        pauseStartDate = Date()
        state = .paused
        timerTask?.cancel()
    }

    func resume() {
        if let pauseStart = pauseStartDate {
            accumulatedPauseSeconds += Date().timeIntervalSince(pauseStart)
            pauseStartDate = nil
        }
        state = .running
        startTick()
    }

    func stop() {
        timerTask?.cancel()
        state = .idle
        sessionStartDate = nil
        pauseStartDate = nil
        accumulatedPauseSeconds = 0
    }

    func skip() {
        timerTask?.cancel()

        // 다음 세션으로
        if sessionNumber < totalSessions {
            state = .onBreak
            sessionStartDate = Date()
            accumulatedPauseSeconds = 0
            pauseStartDate = nil
            // 짧은 휴식 5분
            totalSeconds = 5 * 60
            startTick()
        } else {
            // 4세션 완료 → 긴 휴식
            state = .onBreak
            sessionStartDate = Date()
            accumulatedPauseSeconds = 0
            pauseStartDate = nil
            totalSeconds = 15 * 60
            startTick()
        }
    }

    // MARK: - 타이머 틱

    private func startTick() {
        timerTask?.cancel()
        timerTask = Task { [weak self] in
            while !Task.isCancelled {
                try? await Task.sleep(for: .seconds(1))
                guard !Task.isCancelled else { return }

                guard let self else { return }

                if self.state == .running && self.remainingSeconds <= 0 {
                    self.state = .overflow
                }

                if self.state == .onBreak && self.remainingSeconds <= 0 {
                    self.finishBreak()
                    return
                }
            }
        }
    }

    private func finishBreak() {
        timerTask?.cancel()
        sessionNumber += 1
        if sessionNumber > totalSessions {
            sessionNumber = 1
        }
        state = .idle
        sessionStartDate = nil
        // 집중 시간 복원
        if let preset = Self.presets.first(where: { $0.name == presetName }) {
            totalSeconds = preset.focusMinutes * 60
        } else {
            totalSeconds = 25 * 60
        }
    }
}
