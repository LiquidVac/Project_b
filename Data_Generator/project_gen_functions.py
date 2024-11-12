import random
from faker import Faker
import numpy as np
import pandas as pd
from datetime import datetime, timedelta
import os

fake = Faker()


def random_date(start, end):
    return start + timedelta(seconds=random.randint(0, int((end - start).total_seconds())))


start_date = datetime.now() - timedelta(days=365)
end_date = datetime.now()


def probability_value(start, end, probability):
    return start if random.random() < probability else end


def create_folder_if_not_exists(folder_name):
    if not os.path.exists(folder_name):
        os.mkdir(folder_name)
    return folder_name
