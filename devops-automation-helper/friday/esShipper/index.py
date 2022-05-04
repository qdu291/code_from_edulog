#!/usr/bin/env python3
from fire import Fire
import boto3
from botocore.config import Config
import json
import os

def connect(service: str = 'ec2', profile: str = 'default', region: str = 'us-east-2'):
  try:
    config = Config(region_name=region)
    session = boto3.Session(profile_name=profile)

    return session.client(service, config=config)
  except Exception as err:
    print('connect.error', err)
    raise err

def handler(filePath: str):
  try:
    if not filePath:
      raise 'filePath can not be empty!'

    # read file
    fileName = os.path.basename(filePath).split('.')[0]
    if fileName:
      with open(filePath, 'r') as f:
        doc = json.load(f)
        decodedFileName = fileName.split('-')
        index = decodedFileName.pop(0)
        docId = '-'.join(decodedFileName)
        event = {'index': index, 'docId': docId, 'document': json.dumps(doc)}
        # print('event', event)

        client = connect(service='lambda')
        FUNCTION_NAME = 'friday-createDocES'
        resp = client.invoke(
          FunctionName=FUNCTION_NAME,
          Payload=json.dumps(event)
        )
        print(resp)
    else:
      raise 'fileName can not be decoded!'
  except Exception as err:
    print('handler.error', err)
    raise err

# Test
if __name__ == '__main__':
  Fire(handler)