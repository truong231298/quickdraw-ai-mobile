import torch
import torch.nn as nn

class QuickDrawCNN(nn.Module):

    def __init__(self, num_classes):
        super().__init__()
        self.features = nn.Sequential(
            nn.Conv2d(1, 32, kernel_size=3, padding=1),
            nn.ReLU(),
            nn.MaxPool2d(2),

            nn.Conv2d(32, 64, kernel_size=3, padding=1),
            nn.ReLU(),
            nn.MaxPool2d(2),
        )

        self.classifier = nn.Sequential(
            nn.Flatten(),
            nn.Linear(64 * 7 * 7, 128),
            nn.ReLU(),

            nn.Dropout(),
            nn.Linear(128, num_classes),
        )

    def forward(self, x):
        x = self.features(x)
        x = self.classifier(x)
        return x

import json

MODEL_PATH = "./models/best_model.pth"
CLASS_PATH = "./models/class_names.json"

with open(CLASS_PATH, "r") as f:
    class_names = json.load(f)

model = QuickDrawCNN(len(class_names))
model.load_state_dict(
    torch.load(MODEL_PATH, map_location=torch.device("cpu"))
)

model.eval()