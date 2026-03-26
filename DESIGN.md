# Design System — 로아 캘린더

## Product Context
- **What this is:** 쿠팡급 품질의 자기관리 iOS 앱 (캘린더 + 뽀모도로 + Todo + 자기관리)
- **Who it's for:** 한국 사용자, 생산성과 자기관리를 중시하는 직장인/학생
- **Space/industry:** Productivity (Google Calendar, Todoist, Things 3, Forest, Structured)
- **Project type:** iOS Native App (SwiftUI, iPhone 전용, Portrait)

## Aesthetic Direction
- **Direction:** Refined Warmth — Things 3의 절제 + Todoist의 따뜻함 + 쿠팡의 정보 밀도
- **Decoration level:** Intentional — 타이포그래피와 색상이 주인공, 미세한 그림자와 깊이감
- **Mood:** 차갑지 않고, 화려하지 않고, 정돈된 따뜻함. 오래 써도 피로하지 않은 인터페이스.
- **Reference sites:** Toss, Coupang, Things 3, Todoist

## Typography
- **Display/Hero:** Pretendard Variable 800 (34pt) — 한국 디지털 프리미엄 표준
- **Body:** Pretendard Variable 400 (17pt, line-height 160%) — 한글 최적 가독성
- **UI/Labels:** Pretendard Variable 600 (13~15pt) — 라벨, 버튼, 탭
- **Data/Tables:** SF Pro tabular-nums (17pt) — 시간, 숫자, 통계
- **Code:** SF Mono
- **Loading:** Pretendard CDN (jsdelivr), SF Pro (시스템 내장)
- **Scale:**
  - Display: 34pt / 800 weight / -1px tracking
  - Title 1: 28pt / 700 weight / -0.5px tracking
  - Title 2: 22pt / 700 weight
  - Headline: 17pt / 600 weight
  - Body: 17pt / 400 weight / 160% line-height
  - Caption: 12pt / 500 weight
  - Tabular: 17pt / SF Pro tabular-nums

## Color
- **Approach:** Balanced — Primary Blue + Accent Orange 이중 구조
- **Primary:** `#2563EB` (Confident Blue) — 신뢰, 집중. 캘린더/Todo 기본 색상
- **Primary Hover:** `#1D4ED8`
- **Accent:** `#F97316` (Warm Orange) — 행동, 에너지. 뽀모도로/CTA 강조
- **Accent Hover:** `#EA580C`
- **Background Light:** `#FAFAF8` (Warm Off-White) — 순백이 아닌 따뜻한 종이색
- **Background Dark:** `#191F28` (Deep Charcoal) — 순흑이 아닌 따뜻한 어둠
- **Surface:** `#FFFFFF` (Light) / `#242B35` (Dark) — 카드, 시트
- **Neutrals:**
  - 50: `#FAFAF8` (Background)
  - 100: `#F5F5F3`
  - 200: `#E5E5E0` (Border)
  - 300: `#D4D4CF`
  - 400: `#A3A3A0` (Muted text)
  - 500: `#737370`
  - 600: `#525250` (Secondary text)
  - 700: `#404040`
  - 800: `#262626`
  - 900: `#1C1C1A` (Primary text)
- **Semantic:** Success `#22C55E`, Warning `#EAB308`, Error `#EF4444`, Info `#3B82F6`
- **Dark mode:** Deep Charcoal 배경, Surface 톤 분리, 색상 채도 유지, 모든 토큰 독립 검증

## Spacing
- **Base unit:** 4pt
- **Density:** Comfortable (Things 3보다 촘촘, 쿠팡보다 여유)
- **Scale:** 2xs(2) xs(4) sm(8) md(16) lg(24) xl(32) 2xl(48) 3xl(64)
- **Margins:** 수평 16pt, 아이템 내부 12pt, 섹션 간 24pt

## Layout
- **Approach:** Grid-disciplined — 한국 사용자 기대 정보 밀도 충족
- **Grid:** Single column (iPhone Portrait 전용)
- **Max content width:** 화면 전체 (좌우 16pt 마진)
- **Border radius:**
  - sm: 6pt (칩, 작은 요소)
  - md: 12pt (카드, 입력 필드)
  - lg: 16pt (모달, 시트)
  - full: 9999pt (버튼, 뱃지 — 캡슐형)
- **Continuous corner radius:** iOS superellipse 적용

## Motion
- **Approach:** Intentional — 모든 애니메이션에 기능적 이유
- **Easing:** enter(ease-out) exit(ease-in) move(ease-in-out)
- **Duration:** micro(50-100ms) short(150-250ms) medium(250-400ms) long(400-700ms)
- **Spring physics:** iOS 네이티브 spring 애니메이션 기본
- **Signature animation:** 뽀모도로 세션 완료 시 타이머 링 펄스 + 체크 모션
- **Haptic:** 모든 터치 인터랙션에 햅틱 피드백

## Icon
- **Primary:** SF Symbols — iOS 네이티브, 접근성 자동 지원
- **Style:** Outlined (기본), Filled (active/selected 상태)
- **Custom:** 사용자 승인 후에만 커스텀 아이콘 추가

## Component Tokens
- **Button Primary:** bg `#2563EB`, text white, radius full, padding 10x20
- **Button Accent:** bg `#F97316`, text white, radius full
- **Button Secondary:** bg `#F5F5F3`, text `#1C1C1A`, radius full
- **Button Ghost:** bg transparent, border 1.5px `#2563EB`, text `#2563EB`
- **Card:** bg Surface, border 1px `#E5E5E0`, radius 16pt, shadow sm, padding 20
- **Input:** border 1.5px `#E5E5E0`, radius 12pt, padding 12x16, focus border `#2563EB`
- **Alert:** left-border 3px, radius 12pt, padding 14x16
- **Chip:** radius full, padding 4x12, font 12pt/600

## Decisions Log
| Date | Decision | Rationale |
|------|----------|-----------|
| 2026-03-26 | Initial design system created | /design-consultation 기반, 경쟁 앱 10개 조사 후 결정 |
| 2026-03-26 | Pretendard + SF Pro 선택 | 한국 디지털 프리미엄 표준 + iOS 네이티브 조합 |
| 2026-03-26 | Blue Primary + Orange Accent | Blue=신뢰/집중(캘린더/Todo), Orange=행동/에너지(뽀모도로/CTA) |
| 2026-03-26 | Warm Off-White 배경 (#FAFAF8) | 순백 대비 장시간 사용 피로 감소, 디지털 종이 감성 |
| 2026-03-26 | Comfortable 밀도 | 한국 사용자 정보 밀도 기대 vs 미니멀 디자인 균형 |
