from PIL import Image
import numpy as np
import torch

def preprocess_image(image: Image.Image):
    image = image.convert('L')
    image = image.resize((28, 28))
    image = np.array(image).astype(np.float32)
    image = image / 255.0
    image = torch.tensor(image)
    image = image.unsqueeze(0).unsqueeze(0)
    return image