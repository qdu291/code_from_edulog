#!/usr/bin/env python3
from fire import Fire
import boto3
from botocore.config import Config


class Image:
    def __init__(self,
                 image_id: str,
                 src_profile: str = '',
                 src_region: str = ''):
        self.DEFAULT_PROFILE = 'default'
        self.DEFAULT_REGION = 'us-east-2'
        self.SRC_IMAGE_ID = image_id
        self.SRC_IMAGE = None
        if not src_profile:
            self.SRC_PROFILE = self.DEFAULT_PROFILE
        else:
            self.SRC_PROFILE = src_profile
        if not src_region:
            self.SRC_REGION = self.DEFAULT_REGION
        else:
            self.SRC_REGION = src_region

        self.SRC_IMAGE = self.get()

    def connect_ec2(self, profile: str, region: str, aws_service: str):
        session = boto3.Session(profile_name=profile)
        aws_config = Config(region_name=region)

        return session.client(aws_service, config=aws_config)

    def get(self):
        ec2 = self.connect_ec2(profile=self.SRC_PROFILE,
                               region=self.SRC_REGION,
                               aws_service='ec2')
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

    def tag(self, region: str, profile: str = ''):
        pass

    def share(self, account_id: str, region: str, profile: str = ''):
        pass

    def copy(self, region: str):
        pass


if __name__ == "__main__":
    Fire(Image)

# python3 image_helper.py copy --image_id=ami-0f686b6e57fe824a1 --region=eu-west-3
# python3 image_helper.py share --image_id=ami-0f686b6e57fe824a1 --region=us-east-2 --account_id=690893158275 --profile=default