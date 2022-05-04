# Note on using MissionControl Helper

## Install prerequisites

> Python 3.8.5

### Google Fire

`pip3 install fire`
or
`conda install fire -c conda-forge`

### Requests

`pip3 install requests`
or
`conda install requests`

## Create New Tenant

```
tenant_name=tan-test7
timezone=US/Arizona
tenant_id=`python3 MissionControl.py create_tenant --tenant_name=$tenant_name --timezone=$timezone`

python3 MissionControl.py create_settings --tenant_id=$tenant_id --settings='' --timezone=US/Arizona

python3 MissionControl.py get_tenant_settings --tenant_id=$tenant_id
```

## Create New User

`python3 MissionControl.py create_user --email=tan.test7@karrostech.com --first_name=tan --last_name=test7 --tenant_id=$tenant_id`
