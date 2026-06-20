<div align="center">

# FocusFlow

**A calm place to organize what matters.**

A native iOS focus & planning app — built with SwiftUI + SwiftData, with a quiet, local AI working in the background.
Not a productivity system. A calm companion for doing meaningful work, one day at a time.

`SwiftUI` · `SwiftData` · `MVVM` · `Offline-first` · `Local AI (Ollama + FastAPI)`

</div>

---

## Why FocusFlow

Most planning apps shout. Streaks, badges, dashboards, agile jargon. FocusFlow does the opposite.

- **Calm over productivity hype** — no streaks, no dopamine loops, no scoreboards.
- **Focus over backlog overload** — a short, intentional day is enough.
- **Guidance over project management** — human language: *today*, *focus*, *goal*. Never *sprint*, *backlog*, *epic*.
- **Native Apple feel** — inset cards, soft transitions, system gestures, haptics.
- **Invisible AI** — no chat UI, no “AI generated” badges. It quietly helps you plan and prioritize.

---

## Features

### 🎯 Today
- Your focus for the day as spacious, calm cards
- Swipe to complete or defer, tap to check off
- A quiet, AI-written insight note at the bottom
- A gentle “Today’s focus is complete” state — no confetti

### ✅ Tasks
- **Inbox · Scheduled · Someday** buckets, plus a separate **From Goals** section
- One-tap quick-add bar
- Drag to reorder, native swipe-to-complete / defer / delete
- Collapsible **Completed** section — finished work is honored, restorable, not deleted

### 🧭 Goals
- Turn one goal into a calm plan in ~90 seconds
- The AI asks 2–3 gentle questions, then drafts 8–12 tasks grouped by theme
- Review, trim, and confirm — it’s a suggestion, not a prescription
- Goal detail with a calm progress bar and themed steps

### 🤖 AI (local & optional)
- Planning questions, plan generation, and daily insight notes
- Runs **locally** via Ollama + FastAPI — private, no cloud
- Protocol-based (`AIService`): falls back gracefully to a mock when the backend is unreachable, so the app always works offline

### ✨ Polish
- **Dark / Light / System** themes
- **English & Türkçe** (follows the system language, switchable in Settings)
- Subtle haptics and completion animations

---

## Architecture

FocusFlow is a SwiftUI + SwiftData app following a light MVVM pattern.

```
SwiftUI Views  ──  @Query / @Environment(modelContext)
      │
      ▼
ViewModels (business logic only — no data fetching, no held context)
      │
      ▼
SwiftData Models  ·  AIService (protocol)
                          │
            ┌─────────────┴─────────────┐
        MockAIService              OllamaService ──HTTP──▶ FastAPI ──▶ Ollama (llama3.2)
        (offline fallback)                                 (local backend, Docker)
```

**Key idea — the AI seam:** every screen depends on the `AIService` *protocol*, never a concrete type.
`MockAIService` powered the whole app during development; `OllamaService` was added later by implementing the
same protocol and swapping a single line. A future cloud or on-device model would slot in the same way.

### Project structure

```
app/FocusFlow/FocusFlow/
├── App/                 FocusFlowApp, RootView (TabView, theme & locale)
├── Core/
│   ├── DesignSystem/    AppTheme (adaptive colors, type, spacing), Haptics
│   ├── Models/          TaskItem, Goal, DailyFocus, UserPreferences
│   ├── AI/              AIService, MockAIService, OllamaService, APIConfig
│   ├── Persistence/     PersistenceController (SwiftData)
│   └── PreviewData/     sample data for Xcode previews
├── Features/
│   ├── Today/           TodayView, FocusCardView, TodayViewModel
│   ├── Tasks/           TasksView, TaskRowView, QuickAddBar, TaskDetailSheet
│   ├── Goals/           GoalsView, GoalDetailView, GoalCreationView, GoalPlanningView
│   ├── OnBoarding/      OnboardingView
│   └── Settings/        SettingsView (appearance + language)
└── Localizable.xcstrings

backend/                 FastAPI + Ollama (Docker Compose)
docs/sprints/            per-sprint design notes
```

---

## Getting started

### Requirements
- Xcode 26+, iOS 26+ device or simulator
- (For real AI) Docker Desktop

### Run the app
1. Open `app/FocusFlow/FocusFlow.xcodeproj` in Xcode.
2. Select a simulator or your device, then **Run** (`⌘R`).

The app is fully functional offline — without the backend, the AI features use a built-in mock.

### Run the local AI backend (optional)

```bash
cd backend
docker compose up -d --build
docker compose exec ollama ollama pull llama3.2:3b   # first time, ~2GB
curl http://localhost:8000/health
```

- **Simulator** reaches the backend at `localhost` automatically.
- **Real device** must be on the same Wi-Fi as the Mac; set the Mac’s LAN IP in `Core/AI/APIConfig.swift`
  (find it with `ipconfig getifaddr en0`).

> ⚠️ The local AI setup is a **development/demo** architecture — it runs on your Mac, so a real device only
> reaches it on the same network. Shipping would swap `OllamaService` for a cloud API or an on-device model.

---

## Roadmap

Built sprint by sprint (notes in [`docs/sprints/`](docs/sprints)):

| Sprint | Focus | Status |
|-------|-------|:------:|
| S0 | Foundation — models, design system, navigation | ✅ |
| S1 | Today experience — focus cards, gestures | ✅ |
| S2 | Tasks — buckets, quick-add, swipe, detail sheet | ✅ |
| S3 | Goals + mock AI planning flow | ✅ |
| S4 | Real AI — Ollama + FastAPI, graceful fallback | ✅ |
| S5 | Polish — dark mode, localization, haptics, animations | ✅ |

**Ideas for later:** Today widget · focus timer · recurring tasks · AI daily top-3 suggestion · “Adjust plan” recalibration · iCloud sync.

---

## Tech stack

- **SwiftUI** + **SwiftData** (MVVM, offline-first)
- **String Catalog** localization (English · Türkçe)
- **FastAPI** + **Ollama** (`llama3.2:3b`), containerized with **Docker Compose**

---

<div align="center">
Made with care, one calm day at a time.
</div>
