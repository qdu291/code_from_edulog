#!/usr/bin/env python3
from fire import Fire
import boto3
from datetime import datetime
from elasticsearch import Elasticsearch, RequestsHttpConnection
from requests_aws4auth import AWS4Auth

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

def handler():
  try:
    es = connectES()
    # print(es.search(index="site",request_timeout=5))
    doc = {
      'author': 'kimchy',
      'text': 'Elasticsearch: cool. bonsai cool.',
      'timestamp': datetime.now(),
    }
    res = es.index(index="test-index", id=1, body=doc)
    print(res['result'])

  except Exception as err:
    print('handler.error', err)
    raise err

# Main
if __name__ == '__main__':
  Fire(handler)