from fire import Fire
import boto3
from botocore.config import Config
from datetime import datetime
import getBeVersion as BeVersion
import getFeVersion as FeVersion
from elasticsearch import Elasticsearch, RequestsHttpConnection
from requests_aws4auth import AWS4Auth

def connect(profile: str, region: str, service: str = 'ec2'):
  try:
    config = Config(region_name=region)
    session = boto3.Session(profile_name=profile)

    return session.client(service, config=config)
  except Exception as err:
    print('connect.error', err)
    raise err


def connectES(profile: str = 'default', region: str = 'us-east-2'):
  try:
    session = boto3.Session(profile_name=profile)
    service = 'es'
    host = 'search-homer-gsa6iqcvu35uzenxh7x6ogwl7e.us-east-2.es.amazonaws.com'

    credentials = session.get_credentials()
    awsauth = AWS4Auth(credentials.access_key, credentials.secret_key, region, service, session_token=credentials.token)

    return Elasticsearch(
        hosts = [host],
        http_auth = awsauth,
        use_ssl = True,
        verify_certs = True,
        port = 443,
        connection_class = RequestsHttpConnection
    )
  except Exception as err:
    print('connect.error', err)
    raise err

def indexES(index: str, documents: dict):
  try:
    es = connectES()
    for docId, doc in documents.items():
      es.index(index=index, id=docId, body=doc)

  except Exception as err:
    print('handler.error', err)
    raise err


def handler(profile: str = 'default', region: str = 'us-east-2'):
  """ Collect Site Information
  """

  sitesData = {}
  envType = 'prod'
  service = 'cloudformation'
  cf = connect(profile, region, service)
  # read sites list from file siteLists.txt
  with open('./siteLists.txt') as sitesList:
    for site in sitesList:
      site = site.strip()
      print(site)
      key = '{}-{}'.format(envType, site)
      # Describe Site Info from CFN Stack
      # Information can get: envType, site, stackName, createTime, updateTime, creator, feUrl, wqUrl, beUrl, rdsEndpoint, nosHost
      stack = cf.describe_stacks(StackName='athena-{}'.format(site))['Stacks'][0]
      creator = list(filter(lambda p: p['Key'] == 'creator', stack.get('Tags')))
      if len(creator) > 0:
        creator = creator[0].get('Value')
      else:
        creator = ''
      sitesData[key] = {
        'site': site,
        'envType': envType,
        'cfnStack': stack.get('StackName'), 
        'tenantId': list(filter(lambda p: p['ParameterKey'] == 'TenantId', stack.get('Parameters')))[0].get('ParameterValue'), 
        'feVersion': FeVersion.get(site, envType, region), 
        # 'wqVersion': '', 
        'beVersion': BeVersion.get(site, envType, region), 
        # 'infrasVersion': list(filter(lambda p: p['Key'] == 'infras', stack.get('Tags')))[0].get('Value'),
        'feUrl': list(filter(lambda p: p['OutputKey'] == 'FrontendURL', stack.get('Outputs')))[0].get('OutputValue'), 
        # 'wqUrl': list(filter(lambda p: p['OutputKey'] == 'WebQueryURL', stack.get('Outputs')))[0].get('OutputValue'), 
        'beUrl': list(filter(lambda p: p['OutputKey'] == 'BackendURL', stack.get('Outputs')))[0].get('OutputValue'), 
        'rdsEndpoint': list(filter(lambda p: p['OutputKey'] == 'RDSEndpoint', stack.get('Outputs')))[0].get('OutputValue'), 
        # 'nosHost': list(filter(lambda p: p['OutputKey'] == 'WOSNOSHost', stack.get('Outputs')))[0].get('OutputValue'),
        'creator': creator,
        'createTime': stack['CreationTime'].strftime('%Y-%m-%dT%H:%M:%S.%fZ'), 
        'status': 'active'
      }
      print('------------------------------')
  # print(sitesData)
  indexES('site', sitesData)

if __name__ == '__main__':
  Fire(handler)