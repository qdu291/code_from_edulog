import json
from fire import Fire
import boto3
from botocore.config import Config
from datetime import datetime
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

def deleteIndex(tenantid: str, sitename: str, env_type: str):
  delete_body = {
     "query": {
        "match_phrase": {
            "envType": env_type
        },
        "match_phrase": {
            "tenantid": tenantid
        },
        "match_phrase": {
            "site": sitename
        }
     }
  }
  update_body = json.dumps(delete_body)

  try:
    es = connectES()
    print(es.delete_by_query(body=delete_body, index="site"))
  except Exception as err:
    print('handler.error', err)
    raise err


def handler(site_name: str, tenant_id: str, envType: str):
  deleteIndex(tenant_id, site_name, envType)

if __name__ == '__main__':
  Fire(handler)