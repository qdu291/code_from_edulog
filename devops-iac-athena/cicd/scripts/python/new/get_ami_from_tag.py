#!/usr/bin/env python3
import boto3
from botocore.config import Config
import sys

if __name__ == "__main__":
    try:
        DEFAULT_REGION = 'us-east-2'
        project = 'athena'
        author = 'devops'
        aws_region = DEFAULT_REGION
        # Should refactor this using argparse module
        release_version = sys.argv[1]
        if len(sys.argv) > 2:
            aws_region = sys.argv[2]
        if len(sys.argv) > 3:
            aws_profile = sys.argv[3]
            session = boto3.Session(profile_name=aws_profile)
        else:
            session = boto3.Session()

        aws_config = Config(region_name=aws_region)
        ec2 = session.client('ec2', config=aws_config)

        filters = [
            {'Name': 'tag:project', 'Values': [project]},
            {'Name': 'tag:author', 'Values': [author]},
            {'Name': 'tag:image_type', 'Values': ['release']},
            {'Name': 'tag:release_version', 'Values': [release_version]},
        ]

        response = ec2.describe_images(Filters=filters)
        images = response.get('Images')
        if not images:
            print("get_ami_from_tag.notfound")
            exit(1)

        image = images[0]
        if image:
            image_id = image.get('ImageId')
            print(image_id)
    except Exception as e:
        print("get_ami_from_tag.error", e)
        exit(1)