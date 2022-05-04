#!/usr/bin/env python3
import boto3
import sys

if __name__ == "__main__":
    try:
        image_id = sys.argv[1]
        release_version = sys.argv[2]

        # Get image_id
        if image_id:
          ec2_res = boto3.resource('ec2')
          image = ec2_res.Image(image_id)
          image_tags = [
              {'Key': 'release_version', 'Value': release_version}
          ]
          image.create_tags(Tags=image_tags)
    except Exception as e:
        print("tag_be_release_version.failed: ", e)
        exit(1)
