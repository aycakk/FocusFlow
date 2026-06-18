# Sprint 4 — Real AI (Ollama + FastAPI)

> Status: PLAN (not yet implemented)

## Why this sprint

Sprint 3 built the entire Goals + planning experience behind the `AIService`
protocol, backed by `MockAIService`. Sprint 4 replaces the mock with a real
local language model so planning, daily focus suggestions, and insight notes
are genuinely AI-generated.

Because the protocol seam already exists, the app's feature code does not
change — we add `OllamaService: AIService` and swap one line.

## Honest scope note

This is a **development / demo architecture, not a shippable one.**

The model runs via Ollama + FastAPI **on the Mac**. The iPhone reaches it only
when the Mac is on, the server is running, and both are on the same Wi-Fi.
Away from the Mac, AI is unavailable — which is exactly why graceful fallback
is mandatory. A future sprint can swap in a cloud API or (on a newer
Apple-Intelligence device) Apple's on-device models, again by changing only
the service layer.

Decisions for this sprint:
- Model: `llama3.2:3b` (~2GB, fast on Mac; changeable)
- Test target: real iPhone (iPhone 15, A16 — no Apple Intelligence)
- Backend: FastAPI in a new top-level `backend/` folder

---

## Architecture

```text
iOS App (SwiftUI)
   │  HTTP (JSON) over LAN  →  http://<mac-lan-ip>:8000
   ▼
FastAPI (Python, on Mac)
   │  local call
   ▼
Ollama  →  llama3.2:3b

If the backend/AI is unreachable → graceful fallback (MockAIService or
AI-free behavior). The app must stay fully functional offline.
```

---

## Phases

### Phase 1 — Environment

- Install Ollama (`brew install ollama` or installer)
- Start the Ollama service, `ollama pull llama3.2:3b`
- Verify with a manual `ollama run` prompt
- Confirm Python 3.9.6 is usable (FastAPI + uvicorn install)

Deliverable: a model answers a prompt locally.

### Phase 2 — Backend (FastAPI)

New `backend/` folder:

- `main.py` — FastAPI app, CORS, health endpoint
- endpoints mirroring the `AIService` contract:
  - `POST /planning-questions` → 2–3 calm questions
  - `POST /generate-plan` → 8–12 themed tasks
  - `POST /daily-suggestion` → top-3 task suggestion
  - `POST /insight-note` → one short calm note
- `prompts.py` — prompt templates (calm tone, no agile language, strict
  JSON output)
- talks to Ollama via its local HTTP API (`/api/generate` or `/api/chat`)
- `requirements.txt`, short `README.md` to run it (`uvicorn main:app --host 0.0.0.0`)

Deliverable: `curl` against each endpoint returns well-formed JSON.

Key technique: instruct the model to return **strict JSON**; parse and
validate on the server so the iOS app always receives clean data.

### Phase 3 — iOS networking layer

- `Core/AI/OllamaService.swift` adopting `AIService`
- `URLSession` async calls, `Codable` request/response models
- a small `APIConfig` holding the base URL (the Mac's LAN IP)
- map server JSON → existing `PlanningQuestion` / `PlanTask` types
- timeouts + error throwing

Deliverable: `OllamaService` satisfies the protocol and returns real data.

### Phase 4 — Wire features

- swap `MockAIService()` → `OllamaService()` (one line in `GoalPlanningView`)
- `TodayViewModel`: replace the static `aiInsightNote` with a real
  AI-generated note, persisted in `DailyFocus.aiInsight`
- add daily top-3 focus suggestion (sets `DailyFocus.wasAISuggested`)

Deliverable: live planning + real insight note on the device.

### Phase 5 — Graceful fallback

- detect unreachable backend / timeout
- fall back to `MockAIService` (or AI-free) without crashing or blocking
- a quiet, non-alarming UI state when AI is off

Deliverable: airplane-mode / Mac-off → app still works fully.

---

## Real-device networking (critical)

Testing on a physical iPhone, not the Simulator, changes the setup:

1. **Base URL is the Mac's LAN IP**, not `localhost`. Find it with
   `ipconfig getifaddr en0` → e.g. `http://192.168.1.23:8000`.
2. **Run FastAPI on all interfaces:** `uvicorn main:app --host 0.0.0.0 --port 8000`.
3. **iOS App Transport Security** blocks plain HTTP by default. Add an ATS
   exception in Info.plist for local development (allow arbitrary loads, or a
   scoped exception for the LAN IP). Remove before any real release.
4. iPhone and Mac must be on the **same Wi-Fi**; the Mac firewall must allow
   incoming connections to the server.

(The Simulator would avoid all of this via `localhost`, but we chose real
device testing intentionally.)

---

## Deliverables summary

New:
- `backend/` (FastAPI app, prompts, requirements, README)
- `Core/AI/OllamaService.swift`
- `Core/AI/APIConfig.swift` (base URL)

Updated:
- `GoalPlanningView.swift` — use real service
- `TodayViewModel.swift` — real insight note + daily suggestion
- `Info.plist` — ATS exception for local dev

Excluded:
- App Store / production hosting
- authentication, multi-user
- "Adjust plan" recalibration (still deferred)

---

## Risks & notes

- 3B model output quality is modest; prompt engineering matters most
- enforce JSON output server-side; never trust raw model text in the app
- keep the AI call off the main thread (already async via the protocol)
- fallback path must be tested as a first-class feature, not an afterthought
- this whole setup dies when the Mac/Wi-Fi is gone — by design for now

---

## Result (target)

Demo 3: live AI planning and a real daily insight note on the iPhone, with a
fully functional offline fallback when the local server is unreachable.
