#!/usr/bin/env python3
from fire import Fire
import boto3
from botocore.config import Config

class Image:
  def __init__(self, ami_id: str, profile: str = 'default', region: str = 'us-east-2'):
    self.PROFILE = profile # Default Account of Destination
    self.REGION = region # Default region of Destination
    self.AMI_ID = ami_id


  def connect_ec2(self, profile: str, region: str):
    session = boto3.Session(profile_name=profile)
    aws_config = Config(region_name=region)

    return session.client('ec2', config=aws_config) 


  def connect_image(self, profile: str, region: str, dest_ami_id: str):
    session = boto3.Session(profile_name=profile)
    aws_config = Config(region_name=region)
    ec2_res = session.resource('ec2', config=aws_config)
    
    return ec2_res.Image(dest_ami_id)


  def get_ami_tags(self):
    ec2 = self.connect_ec2(profile=self.PROFILE, region=self.REGION)
    tags = []
    resp = ec2.describe_images(ImageIds=[self.AMI_ID])
    if resp:
      images = resp.get('Images')
      if images:
        img = images[0]
        if img:
          tags = img.get('Tags')

    return tags 


  def tag(self, dest_ami_id: str, dest_region: str = 'eu-west-3'):
    # Get Source ami Tags
    ami_tags = self.get_ami_tags()
    # Tag Dest ami
    image = self.connect_image(profile=self.PROFILE, region=dest_region, dest_ami_id=dest_ami_id)
    image.create_tags(Tags=ami_tags)

if __name__ == '__main__':
  Fire(Image)    
