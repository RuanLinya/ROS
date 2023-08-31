import torch
import torchvision.transforms as T
import numpy as np


def to_tensor(vector):
    trans = T.ToTensor()
    return trans(vector).unsqueeze(0)