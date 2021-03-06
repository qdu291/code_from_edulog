#!/usr/bin/env python3
import boto3
import sys
import os

if __name__ == "__main__":
    try:
        project = 'athena'
        release_version = sys.argv[1]
        filters = [
            {'Name': 'tag:project', 'Values': [project]},
            {'Name': 'tag:image_type', 'Values': ['release']},
            {'Name': 'tag:release_version', 'Values': [release_version]}
        ]

        # Get image_id
        ec2 = boto3.client('ec2')
        response = ec2.describe_images(Filters=filters)
        images = response.get('Images')
        if images:
            image = images[0]
            if image:
                image_id = image.get('ImageId')
                print(
                    f'==> Update new AMI into CFN Stack with AMI: {image_id}')
                os.system(f'/usr/local/bin/update-cfn-stack demo {image_id}')
    except Exception as e:
        print("deploy-demo.failed: ", e)
        exit(1)
