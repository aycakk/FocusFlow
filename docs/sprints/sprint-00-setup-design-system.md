
# Sprint 00 — Setup + Design System

## Sprint Goal

Create the production-ready foundation of the FocusFlow iOS application.

The goal of this sprint is not feature completeness or polished UI.
Instead, the objective is to establish a clean architecture, navigation structure,
SwiftData foundation, and reusable design system for future development.

---

# Completed Work

## Project Setup

- Created new SwiftUI iOS project
- Configured Git repository
- Added `.gitignore`
- Setup initial project structure

---

# Folder Structure

Created MVVM-oriented folder hierarchy:

```txt
FocusFlow/
├── App/
├── Core/
│   ├── Models/
│   ├── Persistence/
│   └── Services/
├── Features/
│   ├── Root/
│   ├── DailyFocus/
│   ├── GoalCreation/
│   ├── Coach/
│   ├── SprintPlan/
│   ├── Onboarding/
│   └── Settings/
├── UI/
│   ├── Components/
│   └── Modifiers/
└── Resources/
