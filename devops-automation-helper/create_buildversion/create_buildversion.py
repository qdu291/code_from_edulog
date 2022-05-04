#!/usr/bin/env python3
import boto3
import sys

if __name__ == "__main__":
    try:
        instance_id = sys.argv[1]
        service_name = sys.argv[2]
        build_version = sys.argv[3]
        service_versions = sys.argv[4]

        environment = 'stage'
        project = 'athena'
        author = 'devops'
        image_prefix = 'ATH'
        versions = service_versions.split(',')
        image_name = f"{image_prefix}-{build_version}"

        ec2 = boto3.client('ec2')
        response = ec2.create_image(Name=image_name, InstanceId=instance_id)
        image_id = response.get('ImageId')
        if image_id:
            # Wait for image available
            waiter = ec2.get_waiter('image_available')
            waiter.wait(ImageIds=[image_id])
            ec2_res = boto3.resource('ec2')
            image = ec2_res.Image(image_id)

            # Auto Tag image
            image_tags = [
                {'Key': 'environment', 'Value': environment},
                {'Key': 'author', 'Value': author},
                {'Key': 'project', 'Value': project},
                {'Key': 'image_type', 'Value': 'release'},
                {'Key': 'gateway_version', 'Value': versions[0]},
                {'Key': 'geocodeservice_version', 'Value': versions[1]},
                {'Key': 'edta_version', 'Value': versions[2]},
                {'Key': 'ivin_version', 'Value': versions[3]},
                {'Key': 'aggregateservice_version', 'Value': versions[4]},
                {'Key': 'athena_version', 'Value': versions[5]},
                {'Key': 'build_version', 'Value': build_version}
            ]
            image.create_tags(Tags=image_tags)
            print(image_id)
        else:
            # Exit with error
            print("==> Image created failed.")
            exit(1)
    except Exception as e:
        print("create_ami.failed: ", e)
        exit(1)
