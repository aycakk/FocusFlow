# FocusFlow AI Backend

Local AI for FocusFlow: FastAPI + Ollama, run together with Docker Compose.
This is a **development / demo** setup — it runs on your Mac, so the iPhone
can only reach it on the same Wi-Fi while the Mac is on. Not for production.

## Endpoints

| Method | Path                  | Maps to (Swift `AIService`)        |
|--------|-----------------------|------------------------------------|
| GET    | `/health`             | service + model check              |
| POST   | `/planning-questions` | `planningQuestions(for:)`          |
| POST   | `/generate-plan`      | `generatePlan(goalTitle:...)`      |
| POST   | `/insight-note`       | Today screen daily insight         |

## Run

From the `backend/` folder:

```bash
# 1. Start both containers (Ollama + API)
docker compose up -d --build

# 2. Pull the model into the Ollama container (first time only, ~2GB)
docker compose exec ollama ollama pull llama3.2:3b

# 3. Check it's alive
curl http://localhost:8000/health
```

The API listens on `0.0.0.0:8000`, so devices on your LAN can reach it at
`http://<your-mac-ip>:8000` (e.g. `http://192.168.1.106:8000`).

## Try it

```bash
curl -X POST http://localhost:8000/planning-questions \
  -H "Content-Type: application/json" \
  -d '{"goalTitle": "Learn SwiftUI"}'

curl -X POST http://localhost:8000/generate-plan \
  -H "Content-Type: application/json" \
  -d '{"goalTitle": "Learn SwiftUI", "answers": {"motivation": "get a better job"}, "dailyMinutes": 60}'
```

## Stop

```bash
docker compose down          # keep the downloaded model
docker compose down -v       # also delete the model volume
```

## Notes

- Ollama in Docker on macOS is **CPU-only** (no Metal GPU passthrough), so
  responses take a few seconds. Fine for a demo.
- The model is asked to return strict JSON; the API validates it with
  Pydantic before replying, so the iOS app always gets clean data.
- Any AI failure returns HTTP 502; the app should fall back gracefully.
