# API Design

## Base URL

/api/v1

## Endpoints

### POST /predict

Request:

{
    "image": "base64_encoded_png"
}

Response:

{
    "prediction": "tree",
    "confidence": 0.94
}

## Error Responses

400 - Invalid image
500 - Inference failure