"""Thin async client for Ollama's chat API.

Asks the model to return JSON (format="json") and parses it. Raising on
failure is fine — the FastAPI layer turns it into a 502 and the iOS app
falls back to its offline behavior.
"""

import os
import json
import httpx

OLLAMA_HOST = os.getenv("OLLAMA_HOST", "http://localhost:11434")
MODEL = os.getenv("MODEL", "llama3.2:3b")


async def chat_json(system: str, user: str, temperature: float = 0.7) -> dict:
    """Send a system+user prompt to Ollama and parse the JSON reply."""
    payload = {
        "model": MODEL,
        "messages": [
            {"role": "system", "content": system},
            {"role": "user", "content": user},
        ],
        "format": "json",
        "stream": False,
        "options": {"temperature": temperature},
    }

    async with httpx.AsyncClient(timeout=120.0) as client:
        resp = await client.post(f"{OLLAMA_HOST}/api/chat", json=payload)
        resp.raise_for_status()
        data = resp.json()

    content = data["message"]["content"]
    return json.loads(content)
