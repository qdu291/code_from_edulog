#!/usr/bin/env python3
import boto3
import os

if __name__ == "__main__":
    try:
        project = 'athena'
        author = 'devops'
        build_version = os.environ['build_version']
        release_version = os.environ['release_version']
        filters = [
            {'Name': 'tag:project', 'Values': [project]},
            {'Name': 'tag:author', 'Values': [author]},
            {'Name': 'tag:image_type', 'Values': ['release']},
            {'Name': 'tag:build_version', 'Values': [build_version]}
        ]

        # Get image_id
        ec2 = boto3.client('ec2')
        response = ec2.describe_images(Filters=filters)
        images = response.get('Images')
        if images:
            image = images[0]
            if image:
                image_id = image.get('ImageId')
                if image_id:
                    ec2_res = boto3.resource('ec2')
                    image = ec2_res.Image(image_id)
                    image_tags = [
                        {'Key': 'release_version', 'Value': release_version}
                    ]
                    image.create_tags(Tags=image_tags)
    except Exception as e:
        print("tag_image.failed: ", e)
        exit(1)
