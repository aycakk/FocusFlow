# Sprint 1 Revision — Today Experience

## Why this revision was made

Sprint 1 was revised to align the implementation with the new FocusFlow product direction:

- calm productivity experience
- Apple-native interaction patterns
- invisible AI philosophy
- Today-first emotional design
- lightweight task interaction model

The original direction was too task-manager / dashboard oriented.
This revision reframes Sprint 1 around the “Today” experience as the emotional center of the app.

---

## Main architectural decisions

### 1. Today screen becomes the core experience

The Today tab is now the primary surface of the app.

Focus:
- maximum 3 focus tasks
- spacious card-based layout
- calm interaction patterns
- minimal cognitive load

---

### 2. SwiftData + MVVM architecture clarified

Architecture pattern:

- `@Query` remains inside SwiftUI Views
- ViewModels handle business logic only
- `ModelContext` is passed from the View
- no persistence logic inside Views

This keeps the architecture beginner-friendly while remaining scalable.

---

### 3. FocusCardView introduced

A dedicated reusable card component was introduced for:

- swipe-to-complete
- swipe-to-defer
- checkbox interaction
- subtle animations
- Apple-like gesture handling

This component becomes the foundation of the Today experience.

---

### 4. Calm UX principles enforced

The sprint now explicitly avoids:

- productivity-gamification patterns
- aggressive dashboard UI
- sprint/backlog/workflow terminology
- celebratory animations
- visible AI branding

The experience should feel calm, spacious, and intentional.

---

## Sprint 1 Deliverables

Sprint 1 now includes:

- TodayView
- TodayViewModel
- FocusCardView
- PreviewData support
- SwiftData persistence
- swipe gestures
- completion state
- static AI insight note

Excluded from Sprint 1:

- task creation flow
- goals integration
- real AI
- onboarding updates

---

## Technical Notes

Key implementation strategy:

- filter data in Swift instead of early `#Predicate`
- use preview mock data heavily
- build UI statically before gestures
- add persistence after interaction layer stabilizes

This sprint prioritizes:
1. interaction quality
2. visual calmness
3. architectural correctness

before expanding feature scope.

---

## Result

Sprint 1 is now focused on delivering a polished “Today” experience
instead of prematurely expanding into full productivity-system complexity.
