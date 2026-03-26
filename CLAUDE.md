# 로아 캘린더 (Roa Calendar)

> 일정을 정리하세요 — 쿠팡급 품질의 자기관리 iOS 앱

## 프로젝트 정보

- **Bundle ID**: `com.roacompany.roacalendar`
- **App Group**: `group.com.roacompany.roacalendar`
- **스택**: SwiftUI + SwiftData (완전 로컬, 백엔드 없음)
- **iOS**: 18+ | **Swift**: 6.0 | **프로젝트**: XcodeGen
- **배포**: App Store (TestFlight 스테이징)
- **디바이스**: iPhone 전용, Portrait 전용
- **시뮬레이터**: iPhone 17 Pro
- **언어**: 한국어 우선 (추후 다국어 확장)

## 빌드/검증 명령어

```bash
make generate   # xcodegen generate (빌드 전 필수)
make build      # xcodebuild build -scheme RoaCalendar
make test       # xcodebuild test -scheme RoaCalendarTests
make lint       # swiftlint lint --strict
make clean      # 빌드 캐시 정리
```

- 빌드 전 반드시 `make generate` 실행. `.xcodeproj`는 생성물이므로 직접 수정 금지
- 빌드/테스트/린트는 각각 수동 실행
- CI/CD는 TestFlight 단계에서 도입

## 워크플로우 (7단계)

모든 태스크는 이 순서를 반드시 지킨다. 완벽을 기다리며 마비되지 않는다. 빠르게 순환하고, 출시 후 개선한다.

1. **기획** — 기능 정의, PRD 작성
2. **디자인** — Figma
3. **퍼블리싱** — UI 구현
4. **개발** — 로직, 데이터
5. **QA** — 테스트, 검증
6. **TestFlight** — 스테이징
7. **배포** — App Store

## 아키텍처 (MVVM + Clean Architecture)

```
App/                          # 진입점, DI 컨테이너, AppState
Features/                     # 기능별 모듈
  Calendar/
    Domain/                   # Entity (순수 Swift struct), UseCase, Protocol
    Data/                     # @Model, Repository 구현체, Mapper
    Presentation/             # ViewModel, View, Components
  Pomodoro/
    Domain/ | Data/ | Presentation/
  Todo/
    Domain/ | Data/ | Presentation/
  SelfManage/
    Domain/ | Data/ | Presentation/
Core/                         # SwiftData 설정, 알림, Extensions
DesignSystem/                 # 컬러, 타이포, 스페이싱, 공통 컴포넌트
Resources/                    # Assets, Fonts, Localization

# Extension 타겟
RoaCalendarWidget/            # Widget Extension (위젯 + Live Activity)
RoaCalendarWatch/             # Apple Watch Extension
RoaCalendarShare/             # Share Extension (Quick Add)
```

### 의존성 규칙

- **Feature 간 직접 참조 금지**. Core 서비스 또는 NotificationCenter로만 통신
- 기능 수정 시 다른 Feature에 미치는 영향을 반드시 확인. 캘린더/뽀모도로/Todo/자기관리는 하나의 경험
- **Domain**: 순수 Swift struct/protocol. SwiftUI/SwiftData import 금지
- **Data**: `@Model` 배치. Domain Entity ↔ Data Model 간 Mapper로 변환
- **Presentation**: Domain 인터페이스(Protocol)만 import. Data 직접 참조 금지
- **전역 상태**: App 레이어 AppState에서 관리. Feature는 Core 서비스를 통해 접근
- **DI**: 생성자 주입. SwiftUI Environment 사용 안 함
- **Navigation**: NavigationStack + NavigationPath
- **탭바**: 캘린더 / 뽀모도로 / Todo / 자기관리 / 설정 (5탭)

### Core 서비스 인터페이스

Feature 간 통신은 아래 Core 서비스를 통해서만 한다:

- **TaskService** — Task CRUD. Calendar과 Todo가 공유하는 Core Task 모델 관리
- **NotificationService** — 알림 통합 관리. 64개 예산 분배, 스케줄링
- **CalendarQueryService** — 캘린더 이벤트 조회. Todo Upcoming, 자기관리 성과 점수에서 사용
- **PomodoroLogService** — 뽀모도로 세션 기록 조회. 자기관리 통계에서 사용
- **EnergyService** — 에너지 체크인 기록/조회. 자기관리, 습관 상관분석에서 사용

### Core 공유 타입 (Feature 간 공유, Core 레이어 배치)

- **RoaCalendar** — 사용자 캘린더 모델 (Foundation.Calendar 충돌 방지)
- **EventColor** — 11색 enum. Calendar, Pomodoro, Habit에서 공유
- **RecurrenceRule** — 반복 규칙. Calendar, Todo에서 공유
- **Reminder** — 알림 타입 (relative/absolute). Calendar, Todo에서 공유
- **OriginalEvent** — 반복 이벤트 원본 참조 (originalEventID: UUID, originalStartDate: Date)

## 코드 스타일

- **들여쓰기**: 4-space
- **Concurrency**: async/await 전용. Combine 사용 안 함
- **Observable**: `@Observable` 전용. `ObservableObject`/`@Published`/`@StateObject` 사용 안 함
- **MainActor**: ViewModel은 class-level `@MainActor` 선언
- **로깅**: `os.Logger` 전용. `print()` 사용 금지
- **에러**: `try?` 사용 금지. `do-catch` + `os.Logger`로 기록
- **Force unwrap**: `!` 프로덕션 코드 금지. 테스트에서만 허용
- **Magic number**: 하드코딩 금지. Constants 또는 DesignSystem 토큰 사용
- **주석**: 한국어, `// MARK: -`로 섹션 구분, 자명한 코드에는 주석 안 달음
- **아이콘**: SF Symbols만 사용. 커스텀 이미지는 사용자 승인 필요
- **Simplify**: 불필요한 추상화 금지. 코드는 필요한 만큼만 복잡하게. 화면 하나에 정보를 과적하지 않는다
- **Hate Waste**: 사용하지 않는 코드, 파일, import는 즉시 제거. 중복 로직 방치 금지

## 네이밍 컨벤션

| 타입 | 규칙 | 예시 |
|------|------|------|
| View | suffix `View` | `CalendarView` |
| ViewModel | suffix `ViewModel` | `CalendarViewModel` |
| Entity | 의미 기반, suffix 없음 | `CalendarEvent`, `TodoItem` |
| Protocol | suffix 없음 (깔끔한 이름) | `CalendarRepository` |
| Repository 구현체 | 설명적 prefix | `SwiftDataCalendarRepository` |
| UseCase | suffix `UseCase` | `FetchEventsUseCase` |
| Service | suffix `Service` (인프라용) | `NotificationService` |
| Manager/Helper | **사용 금지** | — |
| 사용자 캘린더 | `RoaCalendar` | Foundation.Calendar 충돌 방지 |
| 색상 enum | `EventColor` | Core 레이어 배치 (전 Feature 공유) |

## 날짜 연산 (필수)

캘린더 앱이므로 날짜 버그는 치명적이다:

- `Calendar.current` 사용 금지 → `Calendar(identifier: .gregorian)` 사용
- `DateFormatter()` 기본 생성자 금지 → `Locale(identifier: "ko_KR")` 명시
- 한국 기기 불교력 버그 방지

## SwiftData

- `@Model`은 Data 레이어에 배치. Domain은 순수 Swift struct
- `ModelContainer`는 App 진입점에서 1회 초기화. Feature별 별도 생성 금지
- Widget은 App Group container로 데이터 공유
- 스키마 변경 시 `VersionedSchema`로 마이그레이션 관리
- 신규 필드는 반드시 optional 또는 default 값 지정. 데이터 유실 절대 불허

## 테스트

- UseCase/ViewModel 80% 커버리지
- 테스트 타겟: `RoaCalendarTests`
- `@Model` 필드 추가 시 마이그레이션 테스트 필수

## UX 품질 기준 (쿠팡급)

- 모든 터치에 햅틱 피드백
- 모든 화면 전환/상태 변경에 애니메이션
- 모든 화면에서 로딩/빈/에러 3상태 처리
- 다크모드 + 라이트모드 지원 (DesignSystem 토큰 사용)
- VoiceOver, Dynamic Type 접근성 지원
- 온보딩 화면 포함
- 위젯 지원

## 성능/보안/배포

- Cold Launch 1초, 화면 전환 0.3초, 메모리 100MB 이하
- 민감 데이터는 Keychain. SwiftData 평문 저장 금지
- 에러는 친절한 한국어 메시지. 기술 에러 노출 금지
- SemVer + 빌드 넘버 순차 증가, `PrivacyInfo.xcprivacy` 필수
- 개인정보처리방침 URL 출시 전 준비
- 외부 라이브러리 최소화, SPM만, 추가 전 사용자 승인

## 백그라운드/알림

- Pomodoro: 종료 시각 저장 + 복귀 시 재계산. 앰비언트 사운드는 백그라운드 오디오
- 알림: UNUserNotificationCenter (iOS 64개 제한)
- 알림 예산 분배: 캘린더 30 / Todo 15 / 뽀모도로 5 / 자기관리 5 / 습관 5 / 예비 4
- 초과 시 우선순위: 뽀모도로(실시간) > 캘린더(일정) > Todo(마감) > 습관 > 자기관리
- Core NotificationService에서 전체 Feature 알림 통합 관리

## Git

- **브랜치**: `main` (배포) / `develop` (통합) / `feature/*` (작업) / `release/*` (TestFlight)
- **커밋**: Conventional Commits 한국어 (`feat: 뽀모도로 타이머 추가`)
- **gitignore**: `.xcodeproj`, `.DS_Store`, `DerivedData/`, `*.xcuserstate`

## PR 머지 전 체크리스트

- [ ] 빌드 성공
- [ ] 테스트 통과
- [ ] SwiftLint 클린
- [ ] 강제 언래핑(`!`) 없음
- [ ] `print()` 없음

## Claude 작업 원칙

- PRD에 명시되지 않은 기능 추가 금지. 확정되지 않은 사항 임의 결정 금지
- PRD 확정 후에는 전력 실행. 구현 중 기획 임의 변경 금지 (Disagree and Commit)
- 한 번에 하나의 작업만 수행
- 버그는 근본 원인까지 조사 (Dive Deep). 증상만 치료 금지
- 코드 작성 전 파일/API 존재 여부 확인. 추측 코딩 금지
- iOS 18 / Swift 6.0 API만 사용. 확실하지 않으면 공식 문서 먼저 확인
- CLAUDE.md, PRD, Figma, 코드 간 불일치 시 작업 중단 → 사용자 확인
- 파일 수정 전 반드시 현재 상태 읽기. 기억에 의존 금지
