"""FocusFlow AI backend.

Mirrors the Swift `AIService` protocol over HTTP so the iOS app can swap
MockAIService for a real local model with no UI changes.
"""

from fastapi import FastAPI, HTTPException

import prompts
import ollama_client
from schemas import (
    PlanningQuestionsRequest,
    PlanningQuestionsResponse,
    GeneratePlanRequest,
    GeneratePlanResponse,
    InsightRequest,
    InsightResponse,
)

app = FastAPI(title="FocusFlow AI", version="1.0")


@app.get("/health")
async def health():
    return {"status": "ok", "model": ollama_client.MODEL}


@app.post("/planning-questions", response_model=PlanningQuestionsResponse)
async def planning_questions(req: PlanningQuestionsRequest):
    try:
        data = await ollama_client.chat_json(
            prompts.QUESTIONS_SYSTEM,
            prompts.questions_user(req.goalTitle),
        )
        return PlanningQuestionsResponse(**data)
    except Exception as e:
        raise HTTPException(status_code=502, detail=f"AI error: {e}")


@app.post("/generate-plan", response_model=GeneratePlanResponse)
async def generate_plan(req: GeneratePlanRequest):
    try:
        data = await ollama_client.chat_json(
            prompts.PLAN_SYSTEM,
            prompts.plan_user(req.goalTitle, req.answers, req.dailyMinutes),
        )
        return GeneratePlanResponse(**data)
    except Exception as e:
        raise HTTPException(status_code=502, detail=f"AI error: {e}")


@app.post("/insight-note", response_model=InsightResponse)
async def insight_note(req: InsightRequest):
    try:
        data = await ollama_client.chat_json(
            prompts.INSIGHT_SYSTEM,
            prompts.insight_user(req.completedToday, req.totalToday),
            temperature=0.5,
        )
        return InsightResponse(**data)
    except Exception as e:
        raise HTTPException(status_code=502, detail=f"AI error: {e}")
