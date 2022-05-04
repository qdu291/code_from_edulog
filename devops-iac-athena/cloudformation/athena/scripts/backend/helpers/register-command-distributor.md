# Guide on Register Command Distributor

## Prerequisites

- [Python3](https://www.python.org/downloads/)
- [Python Fire](https://github.com/google/python-fire)

## Register Txnhub

Register from Localhost (Inside every BE Instance)

```
. /opt/athena/env/athena.env && /opt/athena/helpers/register-command-distributor --appName=txnhub --appPort=8090 --tenantId=$TENANT_ID

```

Register From Remote (Through VPN)

```
cd cloudformation/athena/scripts/backend/helpers
python3 register-command-distributor --host=txnhubservice --appName=routing --appPort=8090 --tenantId=<VALID_TENANT_ID>
```
