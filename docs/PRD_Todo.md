# PRD: Todo Feature

> 로아 캘린더의 태스크 관리 기능. Todoist/Things 3 수준의 고급 태스크 매니저.

---

## 1. 개요

사용자가 할 일을 캡처, 분류, 실행, 완료할 수 있는 태스크 매니저.
3가지 날짜 시스템, 아이젠하워 매트릭스, 캘린더/뽀모도로 연동을 지원한다.
Task는 Core 레이어의 공유 모델로, Calendar과 Todo Feature가 함께 사용한다.

---

## 2. 조직 구조

```
Calendar (분류: 업무, 개인, 건강 등)
  └─ Project (목표 단위)
       ├─ Heading (@Model 컨테이너)
       │   └─ Task
       │        └─ Subtask (1단계)
       └─ Task (Heading 없이도 가능)
            └─ Subtask (1단계)
```

### 2.1 Calendar (분류)

- 유일한 분류 체계 (Area 없음)
- Task 생성 시 기본 "개인" 캘린더 자동 배정
- 사용자가 나중에 변경 가능
- Calendar PRD의 다중 캘린더와 동일

### 2.2 Project

| 필드 | 타입 | 설명 |
|------|------|------|
| id | UUID | 고유 ID |
| title | String | 프로젝트 이름 |
| notes | String? | 설명 (Markdown) |
| calendar | RoaCalendar | 소속 캘린더 (필수) |
| status | ProjectStatus | `.active` / `.onHold` / `.completed` |
| dueDate | Date? | 프로젝트 마감일 |
| sortOrder | Int | 정렬 순서 |
| createdAt | Date | 생성일 |
| modifiedAt | Date | 수정일 |

#### Project 생명주기

- 미완료 Task가 있으면 완료 차단
- 모든 Task 완료 후 Project 완료 가능
- 완료된 Project는 Logbook에서 확인 가능

### 2.3 Heading

| 필드 | 타입 | 설명 |
|------|------|------|
| id | UUID | 고유 ID |
| title | String | 섹션 이름 |
| project | Project | 소속 프로젝트 |
| sortOrder | Int | 정렬 순서 |

- Project 내 Task를 그룹화하는 컨테이너
- Heading 삭제 시 소속 Task는 Project 루트로 이동
- 드래그로 재정렬 가능

### 2.4 Task (Core 레이어 공유 모델)

| 필드 | 타입 | 설명 |
|------|------|------|
| id | UUID | 고유 ID |
| title | String | 할 일 이름 (필수) |
| notes | String? | 메모 (Markdown) |
| status | TaskStatus | `.inbox` / `.active` / `.someday` / `.completed` / `.trashed` |
| calendar | RoaCalendar | 소속 캘린더 (필수, 기본 "개인") |
| project | Project? | 소속 프로젝트 (선택) |
| heading | Heading? | 소속 섹션 (선택) |
| taskKind | TaskKind | `.task` / `.reminder` |
| priority | Priority | `.none` / `.low` / `.medium` / `.high` |
| isUrgent | Bool | 긴급 여부 (아이젠하워 매트릭스용) |
| isFlagged | Bool | 플래그 (즐겨찾기) |
| deferDate | Date? | 이 날짜까지 숨김. 도래 시 활성화 |
| plannedDate | Date? | 작업 예정 날짜 (소프트) |
| dueDate | Date? | 하드 데드라인 |
| reminders | [Reminder] | 알림 (여러 개 가능) |
| recurrenceRule | RecurrenceRule? | 반복 규칙 (Calendar과 공유) |
| estimatedPomodoros | Int? | 예상 뽀모도로 세션 수 |
| completedPomodoros | Int | 완료된 뽀모도로 세션 수 (자동 집계) |
| estimatedDuration | Int? | 예상 소요 시간 (분) |
| tags | [String] | 태그 (크로스 프로젝트) |
| sortOrder | Int | 정렬 순서 |
| completedAt | Date? | 완료 시각 |
| trashedAt | Date? | 삭제 시각 (30일 후 영구 삭제) |
| createdAt | Date | 생성일 |
| modifiedAt | Date | 수정일 |

#### Task 상태 전환

```
생성 → .inbox (기본)
       ↓ 정리
    .active (분류 완료, 실행 가능)
       ↓ 보류
    .someday (나중에)
       ↓ 활성화
    .active
       ↓ 완료
    .completed
       ↓ 삭제
    .trashed (30일 보관 후 영구 삭제)
```

#### 날짜 시스템 (3종)

| 날짜 | 역할 | 동작 |
|------|------|------|
| deferDate | 지연일 | 이 날짜 전까지 Anytime/Today 뷰에서 숨김 |
| plannedDate | 예정일 | 작업 예정. 캘린더에 블록으로 표시 가능 |
| dueDate | 마감일 | 하드 데드라인. 접근 시 시각적 경고 (노란→빨강) |

#### 마감일 경고 표시

| 상태 | 시각적 표현 |
|------|-----------|
| 7일 이상 남음 | 기본 |
| 3~7일 남음 | 노란색 |
| 1~3일 남음 | 주황색 |
| 오늘 마감 | 빨간색 |
| 기한 초과 | 빨간색 + 오버듀 뱃지 |

#### 우선순위 + 긴급 (아이젠하워 매트릭스)

| 중요도 (Priority) | 긴급 (isUrgent) | 아이젠하워 분류 |
|-------------------|-----------------|----------------|
| High | true | 즉시 실행 (Do First) |
| High | false | 일정 잡기 (Schedule) |
| Low~None | true | 위임 (Delegate) |
| Low~None | false | 제거 (Eliminate) |

#### Task vs Reminder 동작 차이

| 항목 | Task (.task) | Reminder (.reminder) |
|------|-------------|---------------------|
| Subtask | 지원 | 미지원 |
| Project/Heading | 소속 가능 | 소속 불가 (독립) |
| 뽀모도로 연동 | 지원 | 미지원 |
| 캘린더 표시 | 블록/바 | 점(dot)으로만 표시 |
| 완료 시 | Logbook에 보관 | 즉시 숨김 |

#### 반복 Task

- Calendar PRD의 RecurrenceRule 공유
- 완료 기반 / 고정 일정 선택 가능
- 완료 시 다음 occurrence 자동 생성
- 미완료 Task 자동 롤오버 (Calendar PRD §4.10과 동일)

### 2.5 Subtask

| 필드 | 타입 | 설명 |
|------|------|------|
| id | UUID | 고유 ID |
| title | String | 서브태스크 이름 |
| isCompleted | Bool | 완료 여부 |
| sortOrder | Int | 정렬 순서 |
| parentTask | Task | 상위 Task |

- 1단계만 허용 (재귀 중첩 금지)
- 자체 날짜/우선순위 없음 → 상위 Task에서 상속
- Calendar, Project 직접 참조 없음 → 상위 Task에서 상속
- 드래그로 재정렬 가능

---

## 3. 스마트 뷰 (Smart Views)

### 3.1 시스템 뷰

| 뷰 | 조건 | 설명 |
|----|------|------|
| Inbox | status == .inbox | 미분류 Task |
| Today | (plannedDate == 오늘) OR (dueDate <= 오늘 AND 미완료) OR (deferDate 오늘 도래, 다른 날짜 없음) | 오늘 할 일 + 오버듀 포함 |
| Upcoming | 향후 7일 dueDate/plannedDate + 캘린더 이벤트 | 주간 미리보기 |
| Anytime | status == .active AND (deferDate == nil OR deferDate <= 오늘) | 실행 가능한 모든 Task |
| Someday | status == .someday | 나중에 할 일 |
| Flagged | isFlagged == true | 플래그 Task |
| Overdue | dueDate < 오늘 AND status != .completed | 기한 초과 |
| Logbook | status == .completed | 완료 기록 |
| Trash | status == .trashed | 30일 보관 |

### 3.2 일일 부하 표시 (Today 뷰 상단)

- "오늘: 7개 Task, 예상 ~4.5시간 | 캘린더 빈 시간: 5시간"
- estimatedDuration 합산 기반
- 예상 시간 > 빈 시간이면 과부하 경고 (빨간색)
- estimatedDuration 미설정 Task는 "미예측" 개수로 별도 표시

### 3.3 아이젠하워 매트릭스 뷰

- 2x2 그리드: 긴급/중요 축
- Task를 쿼드런트 간 드래그 이동 가능
- 각 쿼드런트 라벨: 즉시 실행 / 일정 잡기 / 위임 / 제거

### 3.4 커스텀 필터

- 조건 조합: Calendar, Project, Tag, Priority, 날짜 범위, 플래그, 긴급 여부
- AND / OR 조합 가능
- 저장하여 재사용 가능

---

## 4. Quick Add (빠른 캡처)

### 4.1 동작

- 플로팅 "+" 버튼 → 제목만 입력하면 즉시 생성
- 최소 필수 필드: 제목만 (나머지 기본값 적용)
- 기본값: status=.inbox, calendar=개인, priority=.none

### 4.2 자연어 파싱 (기본)

| 입력 | 파싱 결과 |
|------|----------|
| "내일 3시 보고서 작성" | plannedDate=내일 15:00, title="보고서 작성" |
| "매주 월요일 운동" | recurrence=매주 월, title="운동" |
| "#업무 기획안 작성" | tag=업무, title="기획안 작성" |

### 4.3 기타 캡처 방식

- Share Extension (다른 앱에서 URL/텍스트 공유)
- Siri ("로아 캘린더에 할 일 추가")
- 위젯 Quick Add 버튼
- Spotlight 검색 연동

---

## 5. Feature 연동

### 5.1 캘린더 연동

| 기능 | 설명 |
|------|------|
| 시간 뷰 | Task(plannedDate/dueDate)가 캘린더 뷰에 표시 |
| 타임 블록 | Task를 캘린더에 드래그 → 시간 블록 생성 |
| Upcoming 통합 | 캘린더 이벤트 + Task를 하나의 타임라인에 표시 |
| 오버듀 롤오버 | 마감 초과 미완료 Task를 오늘 날짜에 표시 |

### 5.2 뽀모도로 연동

| 기능 | 설명 |
|------|------|
| 세션 시작 | Task 상세 → "집중 시작" 버튼 → 뽀모도로 시작 |
| 자동 연결 | 세션 완료 시 completedPomodoros 자동 증가 |
| 예상 세션 | Task별 estimatedPomodoros 설정 |
| 진행률 | estimatedPomodoros 대비 completedPomodoros 표시 |
| 프리폼 | Task 없이 뽀모도로 세션 시작 가능 (linkedTodoID = nil) |
| Task 삭제 시 | Pomodoro 기록은 유지 (독립 보존) |

### 5.3 자기관리 연동

| 기능 | 설명 |
|------|------|
| 완료율 | 일간/주간 Task 완료율 제공 |
| 생산성 데이터 | 뽀모도로 세션 + Task 완료 데이터를 자기관리 Feature에 제공 |

---

## 6. 알림/리마인더

### 6.1 시간 기반 알림

- Task별 여러 개 알림 설정 가능
- 상대 알림: "마감 1시간 전", "마감 1일 전", "예정일 아침 9시"
- 절대 알림: 특정 날짜/시간
- iOS 64개 알림 제한 → Core NotificationService에서 캘린더/뽀모도로 알림과 합산 관리

### 6.2 마감일 자동 알림

| 시점 | 알림 |
|------|------|
| 마감 1일 전 | "내일 마감: [Task 이름]" |
| 마감 당일 아침 | "오늘 마감: [Task 이름]" |
| 기한 초과 | "마감 초과: [Task 이름]" |

사용자가 설정에서 자동 알림 ON/OFF 가능.

---

## 7. 배치 작업

- 멀티 선택 모드 (롱 프레스 진입)
- 선택한 Task에 일괄 적용: 완료, 삭제, 프로젝트 이동, 캘린더 변경, 우선순위 설정, 태그 추가, 날짜 설정, 플래그
- 실행 취소(Undo) 지원 — 배치 및 단일 작업 모두
- 단일 Task 완료/삭제/이동 시 하단 토스트로 "실행 취소" 버튼 표시 (3초)

---

## 8. 검색

- 전체 텍스트 검색 (제목, 메모, 태그)
- 필터 칩: Calendar, Project, Tag, Priority, 날짜 범위, 플래그, 긴급
- 현재 뷰 내 검색 토글
- 최근 검색 기록

---

## 9. 화면 흐름

```
탭바 [Todo]
  └─ Todo 메인 (기본: Today 뷰)
      ├─ 뷰 전환 (Inbox/Today/Upcoming/Anytime/Someday/Flagged/Overdue)
      ├─ 아이젠하워 매트릭스 뷰
      ├─ 커스텀 필터
      ├─ 검색
      ├─ Project 목록
      │   └─ Project 상세
      │       ├─ Heading 관리
      │       └─ Task 목록
      ├─ Task 탭 → Task 상세
      │   ├─ 편집
      │   ├─ Subtask 관리
      │   ├─ "집중 시작" (뽀모도로 연동)
      │   ├─ 삭제
      │   └─ 상태 변경 (Active/Someday/완료)
      └─ "+" Quick Add → Task 생성
```

---

## 10. 위젯

| 위젯 | 크기 | 내용 |
|------|------|------|
| Today | Small | 다음 Task 1개 |
| Today | Medium | 오늘 Task 리스트 (체크 가능, iOS 17+) |
| Today | Large | 오늘 Task + 캘린더 이벤트 통합 |
| Quick Add | Small | 탭하면 Quick Add 열기 |
| Overdue | Small | 기한 초과 Task 수 |

---

## 11. 설정 항목

| 설정 | 기본값 | 설명 |
|------|--------|------|
| 기본 캘린더 | 개인 | 새 Task 생성 시 기본 배정 |
| 마감일 자동 알림 | ON | 마감 1일 전, 당일 아침 알림 |
| 오버듀 롤오버 | ON | 마감 초과 Task를 오늘에 표시 |
| 완료 시 사운드 | ON | Task 완료 시 효과음 |
| 기본 뷰 | Today | Todo 탭 진입 시 기본 화면 |

---

## 12. 제외 사항 (v1)

| 항목 | 사유 |
|------|------|
| 위치 기반 알림 | 구현 복잡도 높음, v2 검토 |
| 자연어 고급 파싱 | 기본 파싱만 v1, 고급은 v2 |
| GTD Review 모드 | v2 검토 |
| Sequential/Parallel Project | 복잡도 높음, v2 검토 |
| 협업/공유 | 로컬 전용 앱 |
| Task 내보내기 (CSV) | v2 검토 |

---

## 13. 비기능 요구사항

- CLAUDE.md의 UX 품질 기준 준수 (햅틱, 애니메이션, 3상태 처리, 다크모드, 접근성)
- Task CRUD 응답 시간: 100ms 이내
- 검색 응답: 500ms 이내 (1,000개 Task 기준)
- 알림 스케줄링: iOS 64개 제한, Core NotificationService에서 통합 관리
- Core 레이어 공유 모델: Feature 간 직접 참조 금지, Core 서비스 인터페이스를 통해 접근
- SwiftData: sortOrder 필드로 드래그 재정렬 지원
- Subtask: 1단계만 허용, 재귀 중첩 방지를 모델 레이어에서 강제
- Trashed: trashedAt 기준 30일 후 자동 영구 삭제 (Background Task로 정리)
