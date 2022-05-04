# AWS ECS Debezium Cluster with ALB listener on HTTPS

- Service -> Task
- ALB (HTTPS Listener, TargetGroup)
- Route53

## Create Stack in Prod

```
profile=prod
region=us-east-2
template=debezium-workers.yml
name=athena-prod-dbz-workers
env=prod
project=athena
author=devops
creator=tankhuu
service=debezium-workers
aws --profile $profile --region $region cloudformation deploy --template-file $template \
  --stack-name ${name} \
  --capabilities CAPABILITY_IAM CAPABILITY_AUTO_EXPAND \
  --tags \
    environment=${env} \
    project=${project} \
    author=${author} \
    service=${service} \
    creator=${creator} \
  --parameter-overrides \
    VPCStackName=edulogvn-prod-vpc \
    Domain=karrostech.net \
    HostedZoneId=Z33NWCVN5UFMNZ \
    SSLCertificateId=arn:aws:acm:us-east-2:690893158275:certificate/9978ae1d-16b0-4162-9add-3fb57083d06d \
    BootstrapServers=b-2.athenamsk.isix5e.c3.kafka.us-east-2.amazonaws.com:9092,b-1.athenamsk.isix5e.c3.kafka.us-east-2.amazonaws.com:9092 \
    ConfigsTopic=dbz-prod-configs  \
    StatusesTopic=dbz-prod-statuses  \
    OffsetsTopic=dbz-prod-offsets \
    GroupId=dbz-prod-worker-group
```

## DB Schema

ALTER TABLE rp_plan.trip_master REPLICA IDENTITY FULL
ALTER TABLE rp_plan.route REPLICA IDENTITY FULL
ALTER TABLE rp_plan.run REPLICA IDENTITY FULL
ALTER TABLE rp_plan.school REPLICA IDENTITY FULL
ALTER TABLE rp_plan.student REPLICA IDENTITY FULL
ALTER TABLE rp_plan.transport_request REPLICA IDENTITY FULL
