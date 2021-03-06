#!/usr/bin/env python3
import boto3
import sys
from botocore.config import Config
from fire import Fire

class ASG:
  def __init__(self, profile: str = 'default', region: str = 'us-east-2'):
    self.PROFILE = profile
    self.REGION = region
  
  def connect(self, service: str):
    config = Config(region_name=self.REGION)
    session = boto3.Session(profile_name=self.PROFILE)

    return session.client(service, config=config)

  def get_private_ip(self, name: str):
    private_ips = []
    aws_asg = self.connect(service='autoscaling')
    aws_ec2 = self.connect(service='ec2')
    resp = aws_asg.describe_auto_scaling_groups(AutoScalingGroupNames=[name])
    if resp and len(resp['AutoScalingGroups']) > 0:
      asg = resp['AutoScalingGroups'][0]
      if asg:
        instances = asg['Instances']
        if len(instances) > 0:
          for inst in instances:
            inst_id = inst['InstanceId']
            if inst_id:
              inst = aws_ec2.describe_instances(InstanceIds=[inst_id])
              if inst:
                instance = inst['Reservations'][0]['Instances'][0]
                if instance:
                  private_ip = instance['PrivateIpAddress']
                  if private_ip:
                    private_ips.append(private_ip)

    print(private_ips)

if __name__ == "__main__":
  Fire(ASG)