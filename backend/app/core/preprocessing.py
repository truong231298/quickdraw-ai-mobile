from PIL import Image
import numpy as np
import torch

def preprocess_image(image: Image.Image):

    image = image.convert("L")

    image = np.array(image)

    # invert colors
    image = 255 - image

    # threshold
    image[image < 50] = 0

    # find drawing pixels
    coords = np.argwhere(image > 0)

    if len(coords) > 0:

        y0, x0 = coords.min(axis=0)
        y1, x1 = coords.max(axis=0)

        image = image[y0:y1 + 1, x0:x1 + 1]

    # create square canvas
    h, w = image.shape

    size = max(h, w)

    square = np.zeros((size, size))

    y_offset = (size - h) // 2
    x_offset = (size - w) // 2

    square[
        y_offset:y_offset+h,
        x_offset:x_offset+w
    ] = image

    image = Image.fromarray(
        square.astype(np.uint8)
    )

    image = image.resize((28, 28))

    image = np.array(image).astype(np.float32)

    image = image / 255.0

    image = torch.tensor(image)

    image = image.unsqueeze(0).unsqueeze(0)

    return image