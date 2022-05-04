#!/usr/bin/env python3
import boto3
import sys

if __name__ == "__main__":
    try:
        project = 'athena'
        author = 'devops'
        build_version = sys.argv[1]
        filters = [
            {'Name': 'tag:project', 'Values': [project]},
            {'Name': 'tag:author', 'Values': [author]},
            {'Name': 'tag:image_type', 'Values': ['release']},
            {'Name': 'tag:build_version', 'Values': [build_version]}
        ]
        image_id = ''

        # Get image_id
        ec2 = boto3.client('ec2')
        response = ec2.describe_images(Filters=filters)
        images = response.get('Images')
        if not images:
            print("get_ami_from_build_version.notfound")
            exit(1)

        image = images[0]
        if image:
            image_id = image.get('ImageId')
            print(image_id)
    except Exception as e:
        print("get_ami_from_build_version.failed: ", e)
        exit(1)
