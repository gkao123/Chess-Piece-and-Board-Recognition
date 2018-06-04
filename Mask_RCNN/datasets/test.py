import os
import sys
import itertools
import math
import logging
import json
import re
import random
from collections import OrderedDict
import numpy as np

# Root directory of the project
ROOT_DIR = os.path.abspath("../")
print("curr dir" + os.getcwd())
print("root dir" + ROOT_DIR)

import balloon

# Import Mask RCNN
sys.path.append(ROOT_DIR)  # To find local version of the library
from mrcnn import utils
import mrcnn.model as modellib
from mrcnn.model import log

config = balloon.BalloonConfig()
BALLOON_DIR = os.path.join(ROOT_DIR, "datasets")
dataset = balloon.BalloonDataset()
dataset.load_balloon(BALLOON_DIR, "train")
# Must call before using the dataset
dataset.prepare()

print("Image Count: {}".format(len(dataset.image_ids)))
print("Class Count: {}".format(dataset.num_classes))
for i, info in enumerate(dataset.class_info):
    print("{:3}. {:50}".format(i, info['name']))
