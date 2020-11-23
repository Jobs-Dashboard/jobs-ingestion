'''This is meant to save the scrapped data to a destination depending on the
development enviroment.
In dev the data should go to the file system.
In prod the data should go to the data lake.
'''
import os
import json
from typing import List, Dict


def save(data: List[Dict[str, str]]):
    '''Save the data.
    '''
    stage = os.environ['STAGE']
    curr_dir = os.path.dirname(os.path.realpath(__file__))
    if stage == 'DEV':
        with open(f'{curr_dir}/../experiments/data/data.json', 'w') as f:
            json.dump(data, f)
    else:
        raise ValueError(f'The given STAGE {stage} is not implemented')
