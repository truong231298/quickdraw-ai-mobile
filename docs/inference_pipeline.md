# Inference Pipeline

## Inference Flow

User Drawing
    ↓
PNG Export
    ↓
HTTP Request
    ↓
Image Preprocessing
    ↓
ONNX Runtime
    ↓
Prediction
    ↓
Return JSON Response

## Preprocessing Steps

1. Convert image to grayscale
2. Resize to 28x28
3. Normalize pixels
4. Convert to tensor
5. Run inference

## Output Example

{
    "prediction": "tree",
    "confidence": 0.94
}