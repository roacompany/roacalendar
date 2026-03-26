import SwiftUI

// MARK: - 메인 탭바

struct ContentView: View {
    @State private var selectedTab: AppTab = .calendar

    var body: some View {
        TabView(selection: $selectedTab) {
            Tab("캘린더", systemImage: "calendar", value: .calendar) {
                CalendarMonthView()
            }

            Tab("집중", systemImage: "timer", value: .pomodoro) {
                PomodoroPlaceholderView()
            }

            Tab("할 일", systemImage: "checkmark.circle", value: .todo) {
                TodoPlaceholderView()
            }

            Tab("관리", systemImage: "chart.bar", value: .selfManage) {
                SelfManagePlaceholderView()
            }

            Tab("설정", systemImage: "gearshape", value: .settings) {
                SettingsPlaceholderView()
            }
        }
        .tint(Color.primary600)
    }
}

// MARK: - Placeholder Views

struct CalendarPlaceholderView: View {
    var body: some View {
        NavigationStack {
            Text("캘린더")
                .font(.largeTitle)
                .fontWeight(.heavy)
        }
    }
}

struct PomodoroPlaceholderView: View {
    var body: some View {
        NavigationStack {
            Text("집중")
                .font(.largeTitle)
                .fontWeight(.heavy)
        }
    }
}

struct TodoPlaceholderView: View {
    var body: some View {
        NavigationStack {
            Text("할 일")
                .font(.largeTitle)
                .fontWeight(.heavy)
        }
    }
}

struct SelfManagePlaceholderView: View {
    var body: some View {
        NavigationStack {
            Text("관리")
                .font(.largeTitle)
                .fontWeight(.heavy)
        }
    }
}

struct SettingsPlaceholderView: View {
    var body: some View {
        NavigationStack {
            Text("설정")
                .font(.largeTitle)
                .fontWeight(.heavy)
        }
    }
}

#Preview {
    ContentView()
}
