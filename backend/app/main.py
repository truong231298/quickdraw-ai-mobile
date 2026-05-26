from fastapi import FastAPI
from fastapi.middleware.cors import (
    CORSMiddleware
)

from app.api.routes.predict import (
    router as predict_router
)

app = FastAPI(
    title="QuickDraw AI API"
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(
    predict_router
)

@app.get("/")
def health_check():

    return {
        "status": "ok"
    }