#!/usr/bin/env python3
import boto3
import sys
from botocore.config import Config

if __name__ == "__main__":
    try:
        DEFAULT_REGION = 'us-east-2'
        aws_region = DEFAULT_REGION
        # Should refactor this using argparse module
        asg_name = sys.argv[1]
        if len(sys.argv) > 2:
            aws_region = sys.argv[2]
        if len(sys.argv) > 3:
            aws_profile = sys.argv[3]
            session = boto3.Session(profile_name=aws_profile)
        else:
            session = boto3.Session()
        private_ip = ''

        aws_config = Config(region_name=aws_region)
        ec2 = session.client('ec2', config=aws_config)
        aws_asg = session.client('autoscaling', config=aws_config)
        aws_ec2 = session.client('ec2', config=aws_config)

        response = aws_asg.describe_auto_scaling_groups(
            AutoScalingGroupNames=[asg_name])

        if response and len(response['AutoScalingGroups']) > 0:
            asg = response['AutoScalingGroups'][0]
            if asg:
                instances = asg['Instances']
                if instances[0]:
                    inst_id = instances[0]['InstanceId']
                    if inst_id:
                        inst = aws_ec2.describe_instances(
                            InstanceIds=[inst_id])
                        if inst:
                            instance = inst['Reservations'][0]['Instances'][0]
                            if instance:
                                private_ip = instance['PrivateIpAddress']

        if private_ip:
            print(private_ip)
        else:
            print('get_ip_from_asg.notfound')
            exit(1)
    except Exception as e:
        print("get_ip_from_asg.error", e)
        exit(1)
