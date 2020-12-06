'''This is meant to save the scrapped data to a destination depending on the
development enviroment.
In dev the data should go to the file system.
In prod the data should go to the data lake.
'''
import os
import json
from typing import List, Dict
import logging
from datetime import datetime, timezone

import boto3
from botocore.exceptions import ClientError


stage = os.environ.get('STAGE')
bucket = os.environ.get('LAKE_BUCKET')
if stage == 'production':
    s3 = boto3.client('s3')


def get_key():
    '''
    Get the key to save the data in s3. The key will be the folder and the
    file name where the data is stored. Ex:
    'source=indeed/year=2020/month=11/day=28/hour=14/indeed-2020-11-28-14-31-42-997919.json'
    '''
    timestamp = datetime.now(timezone.utc)
    # like '2020-11-28-14-24-38-634678'
    timestamp_str = timestamp.strftime("%Y-%m-%d-%H-%M-%S-%f")
    key = (
        'source=indeed/'
        f'year={timestamp.year}/'
        f'month={timestamp.month}/'
        f'day={timestamp.day}/'
        f'hour={timestamp.hour}/'
        f'indeed-{timestamp_str}.json'
    )

    return key

def save(data: List[Dict[str, str]]):
    '''Save the data.
    '''
    if bucket:
        s3.put_object(Body=json.dumps(data), Bucket=bucket, Key=get_key())
    else:
        # Stage is development or test, lets write the data to a local file
        curr_dir = os.path.dirname(os.path.realpath(__file__))
        with open(f'{curr_dir}/../experiments/data/data.json', 'w') as f:
            json.dump(data, f)

