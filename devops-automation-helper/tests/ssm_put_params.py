import boto3
from botocore.config import Config

profile = 'tankhuu-athena'
region = 'us-east-2'
aws_service = 'ssm'
session = boto3.Session(profile_name=profile)
aws_config = Config(region_name=region)

ssm = session.client(aws_service, config=aws_config)

response = ssm.put_parameter(
    Name='/karros/credential/demo/client_id',
    Description='Karros Credential Demo ClientId',
    Value='9d6c3f85669a40cd1b1fa4635b049b92bb04c881',
    Type='SecureString'
)

print('resp', response)