# Sprint 0 Revision — Foundation Refactor

## Overview

This revision restructures FocusFlow around the new product direction:

> “A calm place to organize what matters.”

The project is no longer positioned as an agile sprint planner or productivity management system.
The architecture, terminology, design system, and navigation were revised to support a calm, consumer-focused iOS experience.

---

# Product Direction Changes

## Removed Directions

The following concepts are no longer part of the app direction:

* sprint planning
* backlog management
* project workflow terminology
* chatbot-first interaction
* productivity gamification
* analytics-heavy UX

## New Product Philosophy

FocusFlow is now designed as:

* calm productivity app
* Apple-native SwiftUI experience
* offline-first architecture
* invisible AI assistance
* local-first task and goal management

Target experience references:

* Things 3
* Apple Reminders
* Calm

Not:

* Jira
* Linear
* Notion-style productivity dashboards

---

# Architecture Refactor

## New Folder Structure

```text
App/
Core/
Features/
Resources/
```

### App

Application entry and root navigation.

Files:

* `FocusFlowApp.swift`
* `RootView.swift`

### Core

Shared infrastructure.

Subfolders:

* `DesignSystem`
* `Models`
* `Persistence`

### Features

Feature-based SwiftUI modules.

Modules:

* Today
* Tasks
* Goals
* Settings
* Onboarding

### Resources

Assets and shared resources.

---

# Design System Foundation

Created a centralized `AppTheme.swift`.

Includes:

## Colors

* porcelain backgrounds
* cobalt accent system
* slate typography palette
* semantic colors
* border tokens

## Layout Tokens

* spacing scale
* radius scale

## Utilities

* hex-based `Color` initializer

The app now uses a single source of truth for visual styling.

---

# SwiftData Foundation

Implemented core SwiftData models:

## Models

* `TaskItem`
* `Goal`
* `DailyFocus`
* `UserPreferences`

## Persistence

Updated `PersistenceController.swift` to use the new models.

Removed outdated model references:

* Sprint
* FocusTask
* DailySnapshot

---

# Navigation Structure

Implemented root tab architecture:

```text
RootView
└── TabView
    ├── Today
    ├── Tasks
    ├── Goals
    └── Settings
```

Accent tint now uses:

* `AppTheme.Colors.accent`

---

# Placeholder Screens

Created initial placeholder screens for:

* Today
* Tasks
* Goals
* Settings

Purpose:

* verify architecture
* validate navigation
* validate theme integration
* establish layout foundation

Feature logic intentionally postponed to Sprint 1.

---

# Sprint 1 Preparation

The project is now ready for real feature implementation.

Next planned implementation phase:

## Today Experience

Planned work:

* FocusCard component
* top-3 focus tasks
* swipe interactions
* DailyFocus integration
* calm task presentation

---

# Current Technical Stack

* SwiftUI
* SwiftData
* MVVM
* Local-first architecture

Future optional integrations:

* Ollama
* FastAPI
* local AI enhancement

AI is not required for the app to function.

---

# Current Status

## Completed

* project restructuring
* design system foundation
* SwiftData model foundation
* persistence setup
* root navigation
* placeholder feature screens

## Not Yet Implemented

* task interactions
* quick add
* task persistence UI
* goal planning flow
* onboarding polish
* AI services
* animations
* swipe gestures

---

# Notes

This revision focuses entirely on foundation quality and long-term maintainability.

No feature-heavy implementation was added intentionally during Sprint 0.
