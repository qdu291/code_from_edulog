#!/usr/bin/env python3
import boto3
import sys
from botocore.config import Config

if __name__ == "__main__":
    try:
        DEFAULT_REGION = 'eu-west-3'
        # Should refactor this using argparse module
        stack_name = sys.argv[1]
        output_key = sys.argv[2]
        aws_region = DEFAULT_REGION
        if len(sys.argv) > 3:
            aws_region = sys.argv[3]
        if len(sys.argv) > 4:
            aws_profile = sys.argv[4]
            session = boto3.Session(profile_name=aws_profile)
        else:
            session = boto3.Session()
        value = ''

        aws_config = Config(region_name=aws_region)
        aws_cfn = session.client('cloudformation', config=aws_config)

        cfn_resp = aws_cfn.describe_stacks(StackName=stack_name)
        if cfn_resp:
            stack_output = cfn_resp['Stacks'][0]['Outputs']
            if stack_output:
                output = list(filter(lambda o: o['OutputKey']
                                     == output_key, stack_output))
                if output[0]['OutputValue']:
                    value = output[0]['OutputValue']

        if value:
            print(value)
        else:
            print("get_output_from_stack.notfound")
            exit(1)
    except Exception as err:
        print("get_output_from_stack.error", err)
        exit(1)
