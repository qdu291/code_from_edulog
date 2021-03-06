#!/usr/bin/env python3
import boto3
import sys
import json
from botocore.config import Config

if __name__ == "__main__":
    try:
        stack_name = sys.argv[1]
        new_params = sys.argv[2]
        # new_params = '{"CQPrivateIP":"10.11.12.78"}'
        current_params = []
        params = []

        config = Config(region_name='us-east-2')
        aws_cfn = boto3.client('cloudformation', config=config)
        # Use for test
        # session = boto3.Session(profile_name='tankhuu-athena')
        # aws_cfn = session.client('cloudformation')

        if new_params:
            new_params = json.loads(new_params)

        get_stack_resp = aws_cfn.describe_stacks(StackName=stack_name)
        if get_stack_resp and get_stack_resp.get('Stacks'):
            stack = get_stack_resp.get('Stacks')[0]
            current_params = stack.get('Parameters')

        if current_params and new_params:
            # print('update_stack.current_params', current_params)
            # print('update_stack.new_params', new_params)
            current_params_keys = [p['ParameterKey'] for p in current_params]
            params = [{'ParameterKey': p, 'UsePreviousValue': True}
                      for p in current_params_keys if p not in list(new_params.keys())]
            for p in list(new_params.keys()):
                params.append(
                    {'ParameterKey': p, 'ParameterValue': new_params[p]})
            # print('params', params)

            update_resp = aws_cfn.update_stack(
                StackName=stack_name, UsePreviousTemplate=True, Parameters=params)
            # print('update_resp', update_resp)

    except Exception as err:
        print("update_stack.failure", err)
        exit(1)
