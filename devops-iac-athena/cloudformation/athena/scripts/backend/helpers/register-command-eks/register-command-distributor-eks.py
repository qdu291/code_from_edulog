#!/usr/bin/env python3
from fire import Fire
from decouple import config
import requests
import json

ten_id = config('TENANT_ID')

def getResponse(resp):
  if resp.ok:
    content = json.loads(resp.content)
    if content:
      return content
  raise Exception(resp.json())


def register(appName: str, appPort: str, host: str = 'localhost', serviceHost: str = 'localhost'):
  url = f'http://{host}:9091/api/v1/tenantSetting/restHook'
  headers = {'Content-Type': 'application/json'}
  body = json.dumps({
    'tenantId': ten_id,
    'applicationName': appName,
    'version': 'v1',
    'urlToSendEvent': f'http://{serviceHost}:{appPort}/api/v1/core/tenant/settings/handleChange'
  })

  try:
    resp = requests.put(url=url, headers=headers, data=body)
    # print('register.resp', resp.json())
    content = getResponse(resp)
    # print('register.resp.content', content)
    return content

  except Exception as err:
    print('register.error', err)
    raise err


if __name__ == '__main__':
  Fire(register) 