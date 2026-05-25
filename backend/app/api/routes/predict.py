from fastapi import APIRouter
from fastapi import UploadFile
from fastapi import File

from PIL import Image
import io

from app.core.predictor import predict

router = APIRouter()

@router.post("/predict")
async def predict_image(
    file: UploadFile = File(...)
):

    contents = await file.read()

    image = Image.open(
        io.BytesIO(contents)
    )

    result = predict(image)

    return result