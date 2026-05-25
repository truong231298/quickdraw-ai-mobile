from fastapi import FastAPI

from app.api.routes.predict import router as predict_router

app = FastAPI(
    title="QuickDraw AI API"
)

app.include_router(predict_router)