#!/usr/bin/env python3
import boto3
import sys
import json
from botocore.config import Config

if __name__ == "__main__":
    try:
        tenant = sys.argv[1]
        ami_id = sys.argv[2]
        current_params = []
        params = []
        stack_name = f"athena-{tenant}"
        new_params = json.dumps({'BackendAMIId': ami_id})

        config = Config(region_name='us-east-2')
        if sys.argv[3] and sys.argv[3] == 'prod':
          profile = sys.argv[3]
          session = boto3.Session(profile_name=profile)
          aws_cfn = session.client('cloudformation', config=config)
        else:
          aws_cfn = boto3.client('cloudformation', config=config)

        if new_params:
            new_params = json.loads(new_params)

        get_stack_resp = aws_cfn.describe_stacks(StackName=stack_name)
        if get_stack_resp and get_stack_resp.get('Stacks'):
            stack = get_stack_resp.get('Stacks')[0]
            current_params = stack.get('Parameters')

        if current_params and new_params:
            current_params_keys = [p['ParameterKey'] for p in current_params]
            params = [{'ParameterKey': p, 'UsePreviousValue': True}
                      for p in current_params_keys if p not in list(new_params.keys())]
            for p in list(new_params.keys()):
                params.append(
                    {'ParameterKey': p, 'ParameterValue': new_params[p]})
            print('params', params)

            update_resp = aws_cfn.update_stack(
                StackName=stack_name, UsePreviousTemplate=True, Parameters=params, Capabilities=['CAPABILITY_NAMED_IAM','CAPABILITY_AUTO_EXPAND'])
            print(update_resp)

            # Wait for stack update completed
            waiter = aws_cfn.get_waiter('stack_update_complete')
            waiter.wait(StackName=stack_name)

    except Exception as err:
        print("update_stack.failure", err)
        exit(1)