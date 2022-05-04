# Note on using AWS AMI Helper

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

## Share AMI cross account

`python3 AwsAmi.py share --image_id=ami-0d2e782d4ae250284 --account_id=690893158275`

## Copy AMI cross region

``

## Tag AMI with tags from source AMI

Tag

`python3 AwsAmi.py tag --image_id=ami-0d2e782d4ae250284 --region=us-east-2 --profile='default'`

## Get AMI ID from tags

`python3 AwsAmi.py get_id_from_tag --region=us-east-2 --profile='default' --tags='[{"Name":"tag:project","Values":["athena"]},{"Name":"tag:author","Values":["devops"]},{"Name":"tag:image_type","Values":["release"]},{"Name":"tag:build_version","Values":["BE-1.0.0-126"]}]'`
