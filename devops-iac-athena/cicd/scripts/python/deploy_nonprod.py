#!/usr/bin/env python3
import boto3
import sys
import os

if __name__ == "__main__":
    try:
        project = 'athena'
        tenant = sys.argv[1]
        release_version = sys.argv[2]
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
                        f'==> Update new AMI into CFN Stack for tenant: {tenant} with AMI: {image_id}')
                res = os.system(f'/usr/local/bin/update_stack_release {tenant} {image_id}')
                print('deploy-nonprod.res', res)
                if res != 0:
                    exit(1)
            else:
              print('deploy-nonprod.ami_not_found')
              exit(1)
        else:
          print('deploy-nonprod.ami_not_found')
          exit(1)
    except Exception as e:
        print("deploy-nonprod.failed: ", e)
        exit(1)