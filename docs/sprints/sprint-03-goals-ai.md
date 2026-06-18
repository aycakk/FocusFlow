# Sprint 3 — Goals + Mock AI Planning

## Why this sprint

Sprint 3 introduces the "meaningful work" layer of FocusFlow: goals and the
guided planning flow. The aim is to let a user turn a single natural-language
goal into a calm, themed plan in about 90 seconds — without ever feeling like
they are filling out a project-management form.

The AI is introduced here, but only behind a protocol and backed by a mock.
No real model runs yet. This keeps the entire Goals experience fully testable
offline and lets Sprint 4 swap in real AI without touching any UI code.

---

## Main architectural decisions

### 1. Protocol-based AI layer

A new `Core/AI/` module defines the contract every AI backend must fulfil:

- `AIService` — protocol with two `async` methods:
  - `planningQuestions(for:)` → 2–3 calm follow-up questions
  - `generatePlan(goalTitle:answers:dailyMinutes:)` → 8–12 draft tasks
- `PlanningQuestion` / `PlanTask` — plain value types the AI speaks in
- `MockAIService` — adopts `AIService`, returns canned questions and a themed
  sample plan, with a simulated delay so loading states are exercised

Sprint 4 will add `OllamaService: AIService`. Because views depend on the
protocol, not the concrete type, no view code will change.

### 2. Plan is drafted, then materialized

`PlanTask` is a throwaway draft — nothing is persisted while the user reviews
the plan. On confirmation, each kept `PlanTask` is converted into a real
`TaskItem` (`source: .aiGenerated`, linked to the goal via `task.goal`).
This honors the doc's "suggestion, not a prescription" principle.

### 3. Phase-based planning flow

`GoalPlanningView` uses a `Phase` state machine
(`loadingQuestions → answering → generating → reviewing`) instead of tangled
`if/else` state, keeping the multi-step flow readable in a single view.

### 4. Themed task grouping

`TaskItem` gained an optional `theme: String?` field so AI-planned tasks carry
a human grouping label ("Foundations", "Getting started") rather than week
numbers. `GoalDetailView` groups by theme via `Dictionary(grouping:)`.

### 5. MVVM consistency preserved

Same pattern as earlier sprints: `@Query` stays in views, `GoalsViewModel`
holds business logic only, and `ModelContext` is passed in from the view.

---

## Sprint 3 Deliverables

New:

- `Core/AI/AIService.swift` (protocol + `PlanningQuestion` + `PlanTask`)
- `Core/AI/MockAIService.swift`
- `Features/GoalCreation/GoalPlanningView.swift`
- `Features/Goals/GoalDetailView.swift`

Updated:

- `Features/Goals/GoalsView.swift` — goal cards (serif title, calm progress
  bar) + empty state + `+` to create
- `Features/Goals/GoalsViewModel.swift` — create goal, materialize plan,
  progress, delete, toggle completion, duration→date helper
- `Features/GoalCreation/GoalCreationView.swift` — wired to planning flow via
  `onFinished` closure
- `Core/Models/TaskItem.swift` — added `theme` field
- `Features/OnBoarding/OnboardingView.swift` — `onFinished:` placeholder

Excluded from Sprint 3:

- real AI (Ollama / FastAPI) — Sprint 4
- "Adjust plan" / AI recalibration — deferred
- onboarding wiring + copy cleanup — Sprint 5

---

## Calm UX principles enforced

- goal title shown large, serif — feels intentional
- progress shown as a bar only, never a percentage number
- tasks grouped by theme, never by "week 1 / week 2"
- completed tasks collapse into a quiet "Completed" section, not deleted
- planning reads as a calm form, not a chatbot conversation
- no "sprint / backlog / milestone" language in the Goals UI

---

## Technical Notes

- `async/await` throughout the AI layer; views call it via `.task { }`
  (on appear) and `Task { }` (on button tap)
- `MockAIService` adds a ~1.2s delay so loading UI is real during development
- plan tasks start as `.someday` so they don't flood Inbox/Today until the
  user pulls them into focus
- `Goal.tasks` cascade-deletes its `TaskItem`s, so `deleteGoal` is one call

---

## Result

Demo 2 is complete: every screen is navigable and the full mock planning flow
works end to end — create a goal, answer calm questions, review the generated
plan, confirm, and see it persist with themed grouping and live progress.

The AI seam is in place, so Sprint 4 can introduce a real local model without
rewriting any feature code.
