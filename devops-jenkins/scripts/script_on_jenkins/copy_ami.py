#!/usr/bin/env python3
from fire import Fire
import boto3
from botocore.config import Config

class Image:
  def __init__(self, profile: str = 'default', dest_region: str = 'eu-west-3'):
    self.PROFILE = profile # Default Account of Destination
    self.REGION = dest_region # Default region of Destination

  def connect(self):
    config = Config(region_name=self.REGION)
    session = boto3.Session(profile_name=self.PROFILE)

    return session.client('ec2', config=config)

  def copy(self, ami_name: str, ami_id: str, region: str):
    ec2 = self.connect()
    resp = ec2.copy_image(Name=ami_name, SourceImageId=ami_id, SourceRegion=region)
    # waiter = ec2.get_waiter('image_available')
    ami_id = self.get_ami_id(resp)
    # waiter.wait(ImageIds=[ami_id])
    if ami_id:
      return ami_id
    return ''

  def get_ami_id(self, data: dict):
    ami_id = data.get('ImageId')
    resp = data.get('ResponseMetadata')
    if ami_id and resp:
      status_code = resp.get('HTTPStatusCode')
      if status_code == 200:
        return ami_id
    return ''

if __name__ == '__main__':
  Fire(Image)    
