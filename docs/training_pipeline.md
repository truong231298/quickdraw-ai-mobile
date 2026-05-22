# Training Pipeline

## Dataset

Dataset source:
Google QuickDraw Dataset

Categories:
- apple
- cloud
- tree
- star
- scissors
...

## Preprocessing

- Convert to grayscale
- Resize to 28x28
- Normalize pixel values
- Train-test split (80/20)

## Model Architecture

MobileNetV3 Small

## Training Configuration

- Optimizer: Adam
- Learning Rate: 1e-3
- Batch Size: 64
- Epochs: 20

## Evaluation Metrics

- Accuracy
- Precision
- Recall
- F1-score

## Export

After training:
PyTorch → ONNX