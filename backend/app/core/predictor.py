import torch

from app.core.model_loader import (
    model,
    class_names
)

from app.core.preprocessing import (
    preprocess_image
)

def predict(image):

    tensor = preprocess_image(image)

    with torch.no_grad():

        outputs = model(tensor)

        probabilities = torch.softmax(
            outputs,
            dim=1
        )

        confidence, predicted = torch.max(
            probabilities,
            1
        )

    prediction = class_names[
        predicted.item()
    ]

    return {
        "prediction": prediction,
        "confidence": round(
            confidence.item(),
            4
        )
    }