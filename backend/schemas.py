"""Request/response shapes shared with the iOS app.

These intentionally mirror the Swift types in Core/AI/AIService.swift
(PlanningQuestion, PlanTask) so the app can decode them directly.
"""

from pydantic import BaseModel


# --- Planning questions ---

class PlanningQuestionsRequest(BaseModel):
    goalTitle: str


class PlanningQuestion(BaseModel):
    key: str
    prompt: str
    placeholder: str


class PlanningQuestionsResponse(BaseModel):
    questions: list[PlanningQuestion]


# --- Plan generation ---

class GeneratePlanRequest(BaseModel):
    goalTitle: str
    answers: dict[str, str] = {}
    dailyMinutes: int = 60


class PlanTask(BaseModel):
    title: str
    theme: str
    estimatedMinutes: int
    priority: int


class GeneratePlanResponse(BaseModel):
    tasks: list[PlanTask]


# --- Insight note ---

class InsightRequest(BaseModel):
    completedToday: int
    totalToday: int


class InsightResponse(BaseModel):
    note: str
