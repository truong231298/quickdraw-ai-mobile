from PIL import Image
import numpy as np
import torch

def preprocess_image(image: Image.Image):

    image = image.convert("L")

    image = np.array(image)

    image = 255 - image

    image[image < 20] = 0

    coords = np.argwhere(image > 0)

    if len(coords) > 0:

        y0, x0 = coords.min(axis=0)
        y1, x1 = coords.max(axis=0)

        image = image[y0:y1, x0:x1]

    pil_image = Image.fromarray(image)

    pil_image = pil_image.resize((28, 28))

    image = np.array(pil_image).astype(np.float32)

    image = image / 255.0

    image = torch.tensor(image)

    image = image.unsqueeze(0).unsqueeze(0)

    return image