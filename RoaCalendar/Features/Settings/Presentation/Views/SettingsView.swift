import SwiftUI

// MARK: - 설정 화면

struct SettingsView: View {
    @State private var firstWeekday = 0  // 0=월, 1=일
    @State private var autoStart = false
    @State private var overflowMode = true
    @State private var focusMode = true
    @State private var keepScreenOn = false
    @State private var calendarAutoLog = true
    @State private var meetingWarning = true
    @State private var dueDateAutoAlert = true
    @State private var overdueRollover = true
    @State private var completionSound = true
    @State private var burnoutWarning = true

    var body: some View {
        NavigationStack {
            List {
                generalSection
                pomodoroSection
                todoSection
                selfManageSection
                infoSection
            }
            .navigationTitle("설정")
            .navigationBarTitleDisplayMode(.large)
        }
    }

    // MARK: - 일반

    private var generalSection: some View {
        Section("일반") {
            Picker("첫 요일", selection: $firstWeekday) {
                Text("월요일").tag(0)
                Text("일요일").tag(1)
            }
            HStack {
                Text("언어")
                Spacer()
                Text("한국어")
                    .foregroundStyle(Color.neutral400)
            }
            HStack {
                Text("기본 캘린더")
                Spacer()
                HStack(spacing: Spacing.xs) {
                    Circle().fill(EventColor.blueberry.color).frame(width: 10, height: 10)
                    Text("개인")
                        .foregroundStyle(Color.neutral400)
                }
            }
        }
    }

    // MARK: - 뽀모도로

    private var pomodoroSection: some View {
        Section("뽀모도로") {
            HStack {
                Text("기본 프리셋")
                Spacer()
                Text("클래식 25/5")
                    .foregroundStyle(Color.neutral400)
                Image(systemName: "chevron.right")
                    .font(.system(size: 12))
                    .foregroundStyle(Color.neutral300)
            }
            Stepper("긴 휴식 주기: 4회", value: .constant(4), in: 2...8)
            Toggle("자동 시작", isOn: $autoStart)
            Toggle("오버플로우 모드", isOn: $overflowMode)
            Toggle("Apple Focus Mode", isOn: $focusMode)
            Toggle("화면 꺼짐 방지", isOn: $keepScreenOn)
            Toggle("캘린더 자동 기록", isOn: $calendarAutoLog)
            Toggle("회의 경고", isOn: $meetingWarning)
        }
        .tint(Color.success)
    }

    // MARK: - 할 일

    private var todoSection: some View {
        Section("할 일") {
            Toggle("마감일 자동 알림", isOn: $dueDateAutoAlert)
            Toggle("오버듀 롤오버", isOn: $overdueRollover)
            Toggle("완료 사운드", isOn: $completionSound)
            HStack {
                Text("기본 뷰")
                Spacer()
                Text("Today")
                    .foregroundStyle(Color.neutral400)
            }
        }
        .tint(Color.success)
    }

    // MARK: - 자기관리

    private var selfManageSection: some View {
        Section("자기관리") {
            HStack {
                Text("퇴근 시간")
                Spacer()
                Text("오후 6시")
                    .foregroundStyle(Color.neutral400)
            }
            HStack {
                Text("에너지 체크인")
                Spacer()
                Text("3회/일")
                    .foregroundStyle(Color.neutral400)
            }
            HStack {
                Text("주간 리뷰 요일")
                Spacer()
                Text("일요일")
                    .foregroundStyle(Color.neutral400)
            }
            Toggle("번아웃 경고", isOn: $burnoutWarning)
        }
        .tint(Color.success)
    }

    // MARK: - 정보

    private var infoSection: some View {
        Section("정보") {
            HStack {
                Text("버전")
                Spacer()
                Text("1.0.0 (빌드 1)")
                    .foregroundStyle(Color.neutral400)
            }
            Button("온보딩 다시 보기") {}
            Button("개인정보처리방침") {}
            Button("오픈소스 라이선스") {}
        }
    }
}

#Preview {
    SettingsView()
}
