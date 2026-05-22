# System Architecture

## Overview

QuickDraw AI Mobile is a full-stack AI application that allows users to draw sketches on a Flutter mobile application and classify them using a deep learning model served through a FastAPI backend.

## Architecture

Flutter App
    ↓
Canvas Drawing
    ↓
Image Export
    ↓
REST API Request
    ↓
FastAPI Backend
    ↓
ONNX Runtime Inference
    ↓
Prediction Response

## Components

### Mobile Client

Responsible for:
- Drawing canvas
- User interaction
- API communication
- Result visualization

### Backend API

Responsible for:
- Image preprocessing
- Model inference
- Prediction formatting

### AI Model

Responsible for:
- Sketch classification
- Confidence scoring

## Model Workflow

Input Image
    ↓
Resize (28x28)
    ↓
Normalize
    ↓
Tensor Conversion
    ↓
ONNX Inference
    ↓
Softmax Prediction