import SwiftUI

// MARK: - 일정 생성/편집 화면

struct EventCreateView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var title = ""
    @State private var isAllDay = false
    @State private var startDate = Date()
    @State private var endDate = Date().addingTimeInterval(3600)
    @State private var locationText = ""
    @State private var urlText = ""
    @State private var notes = ""
    @State private var selectedColor: EventColor?

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    titleSection
                    formSections
                    colorSection
                }
                .padding(.bottom, Spacing.xxxl)
            }
            .background(Color.bgLight)
            .navigationTitle("새 일정")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("취소") { dismiss() }
                        .foregroundStyle(Color.neutral600)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("저장") { dismiss() }
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.primary600)
                }
            }
        }
    }

    // MARK: - 제목 입력

    private var titleSection: some View {
        TextField("제목", text: $title)
            .font(.roaTitle2)
            .padding(.horizontal, Spacing.md)
            .padding(.vertical, Spacing.md)
    }

    // MARK: - 폼 섹션

    private var formSections: some View {
        VStack(spacing: Spacing.sm) {
            formGroup {
                toggleRow(icon: "clock", title: "종일", isOn: $isAllDay)
                formDivider
                dateRow(icon: "calendar", title: "시작", date: $startDate, showTime: !isAllDay)
                formDivider
                dateRow(icon: "calendar", title: "종료", date: $endDate, showTime: !isAllDay)
            }

            formGroup {
                navigationRow(icon: "repeat", title: "반복", value: "반복 안 함")
                formDivider
                navigationRow(icon: "bell", title: "알림", value: "10분 전")
            }

            formGroup {
                iconTextField(icon: "mappin.and.ellipse", placeholder: "위치", text: $locationText)
                formDivider
                iconTextField(icon: "link", placeholder: "URL", text: $urlText)
            }

            formGroup {
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    Label("메모", systemImage: "note.text")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundStyle(Color.neutral600)
                    TextEditor(text: $notes)
                        .font(.roaBody)
                        .frame(minHeight: 80)
                        .scrollContentBackground(.hidden)
                }
                .padding(Spacing.md)
            }

            formGroup {
                navigationRow(icon: "folder", title: "캘린더", value: "개인")
                formDivider
                navigationRow(icon: "photo", title: "사진 첨부", value: "")
            }
        }
    }

    // MARK: - 색상 선택

    private var colorSection: some View {
        formGroup {
            VStack(alignment: .leading, spacing: Spacing.sm) {
                Label("색상", systemImage: "paintpalette")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(Color.neutral600)

                HStack(spacing: Spacing.sm) {
                    ForEach(EventColor.allCases, id: \.self) { color in
                        Circle()
                            .fill(color.color)
                            .frame(width: 28, height: 28)
                            .overlay {
                                if selectedColor == color {
                                    Image(systemName: "checkmark")
                                        .font(.system(size: 12, weight: .bold))
                                        .foregroundStyle(.white)
                                }
                            }
                            .onTapGesture { selectedColor = color }
                    }
                }
            }
            .padding(Spacing.md)
        }
        .padding(.top, Spacing.sm)
    }

    // MARK: - 폼 컴포넌트

    private func formGroup<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        VStack(spacing: 0) {
            content()
        }
        .background(Color.surfaceLight)
        .clipShape(RoundedRectangle(cornerRadius: Radius.md))
        .padding(.horizontal, Spacing.md)
    }

    private func toggleRow(icon: String, title: String, isOn: Binding<Bool>) -> some View {
        HStack {
            Label(title, systemImage: icon)
                .font(.system(size: 15, weight: .medium))
            Spacer()
            Toggle("", isOn: isOn)
                .tint(Color.success)
        }
        .padding(Spacing.md)
    }

    private func dateRow(icon: String, title: String, date: Binding<Date>, showTime: Bool) -> some View {
        HStack {
            Label(title, systemImage: icon)
                .font(.system(size: 15, weight: .medium))
            Spacer()
            DatePicker("", selection: date, displayedComponents: showTime ? [.date, .hourAndMinute] : [.date])
                .labelsHidden()
        }
        .padding(Spacing.md)
    }

    private func navigationRow(icon: String, title: String, value: String) -> some View {
        HStack {
            Label(title, systemImage: icon)
                .font(.system(size: 15, weight: .medium))
            Spacer()
            Text(value)
                .font(.system(size: 15))
                .foregroundStyle(Color.neutral400)
            Image(systemName: "chevron.right")
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(Color.neutral300)
        }
        .padding(Spacing.md)
    }

    private func iconTextField(icon: String, placeholder: String, text: Binding<String>) -> some View {
        HStack(spacing: Spacing.sm) {
            Image(systemName: icon)
                .font(.system(size: 15))
                .foregroundStyle(Color.neutral400)
                .frame(width: 20)
            TextField(placeholder, text: text)
                .font(.system(size: 15))
        }
        .padding(Spacing.md)
    }

    private var formDivider: some View {
        Divider().padding(.leading, 52)
    }
}

#Preview {
    EventCreateView()
}
