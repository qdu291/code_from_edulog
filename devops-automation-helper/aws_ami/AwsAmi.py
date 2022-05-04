#!/usr/bin/env python3
from fire import Fire
import boto3
from botocore.config import Config
import json


class Image:
    def __init__(self,
                 image_id: str = '',
                 src_profile: str = '',
                 src_region: str = ''):
        self.DEFAULT_PROFILE = 'karros-athena'
        self.DEFAULT_REGION = 'us-east-2'
        self.SRC_IMAGE_ID = None
        self.SRC_IMAGE = None
        if not src_profile:
            self.SRC_PROFILE = self.DEFAULT_PROFILE
        else:
            self.SRC_PROFILE = src_profile
        if not src_region:
            self.SRC_REGION = self.DEFAULT_REGION
        else:
            self.SRC_REGION = src_region

        if image_id:
          self.SRC_IMAGE_ID = image_id
          self.SRC_IMAGE = self.get(profile=self.SRC_PROFILE, region=self.SRC_REGION)

    def connect_ec2(self, profile: str, region: str, aws_service: str):
        session = boto3.Session(profile_name=profile)
        aws_config = Config(region_name=region)

        return session.client(aws_service, config=aws_config)

    def connect_image(self, profile: str, region: str, aws_service: str, dst_image_id: str = ''):
        session = boto3.Session(profile_name=profile)
        aws_config = Config(region_name=region)

        ec2_res = session.resource(aws_service, config=aws_config)

        if dst_image_id:
          ec2_res.Image(self.SRC_IMAGE_ID)
        
        return ec2_res.Image(self.SRC_IMAGE_ID)

    def get(self, profile: str, region: str):
        ec2 = self.connect_ec2(profile=profile, region=region, aws_service='ec2')
        image = {}
        resp = ec2.describe_images(ImageIds=[self.SRC_IMAGE_ID])
        if resp:
            images = resp.get('Images')
            if images:
                img = images[0]
                if img:
                    image['name'] = img.get('Name')
                    image['tags'] = img.get('Tags')

        return image
    
    def get_id_from_tag(self, profile: str, region: str, tags: list):
      ec2 = self.connect_ec2(profile=profile, region=region, aws_service='ec2')
      image_id = ''
      resp = ec2.describe_images(Filters=tags)
      if resp:
        images = resp.get('Images')
        if not images:
            print("Image_NotFound")
            exit(1)
        if images:
          img = images[0]
          image_id = img.get('ImageId')
      return image_id

    def tag(self, region: str, profile: str = '', dst_image_id: str = ''):
        if not profile:
          profile = self.DEFAULT_PROFILE
        image = self.connect_image(profile=profile, region=region, aws_service='ec2', dst_image_id=dst_image_id)
        image_tags = self.SRC_IMAGE.get('tags')
        image.create_tags(Tags=image_tags)


    def share(self, account_id: str):
      """ Share AMI from src account to account_id

      Args:
          account_id (str): Destination Account to share AMI with
      """
      ec2 = self.connect_ec2(profile=self.DEFAULT_PROFILE, region=self.DEFAULT_REGION, aws_service='ec2')
      resp = ec2.modify_image_attribute(ImageId=self.SRC_IMAGE_ID, OperationType='add', Attribute='launchPermission', UserIds=[str(account_id)])
      print('share_ami.resp', resp)

    def copy(self, dst_region: str):
      """ Copy AMI from src to dest region

      Args:
          region (str): Destination Region
      """
      ec2 = self.connect_ec2(profile=self.DEFAULT_PROFILE, region=dst_region, aws_service='ec2')
      resp = ec2.copy_image(SourceImageId=self.SRC_IMAGE_ID, SourceRegion=self.DEFAULT_REGION, Name=self.SRC_IMAGE.get('name'))
      print('copy_ami.resp', resp)
      if resp:
        new_image_id = resp.get('ImageId')
        print(new_image_id)


if __name__ == "__main__":
    Fire(Image)

# python3 image_helper.py copy --image_id=ami-0f686b6e57fe824a1 --region=eu-west-3
# python3 image_helper.py share --image_id=ami-0f686b6e57fe824a1 --region=us-east-2 --account_id=690893158275 --profile=default