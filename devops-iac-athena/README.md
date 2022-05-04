# Edulog Athena IAC

Edulog Athena Infrastructure as Code

> **Remember to chose the appropriate parameters for your [Cloudformation - CFN](https://aws.amazon.com/cloudformation/) Stacks.**

## Stack Naming Convention:

athena-<tenant_name>: Root stack

athena-<tenant_name>-SecurityGroupStack: Security Group Stack

athena-<tenant_name>-FEStack: CloudFormation Stack for FrontEnd

athena-<tenant_name>-BEASGStack: CloudFormation Stack for BackEnd

athena-<tenant_name>-RDSStack: CloudFormation Stack for RDS

athena-<tenant_name>-CQASGStack: CloudFormation Stack for Cache and Queue - MongoDB, RabbitMQ

athena-<tenant_name>-WosNosStack: CloudFormation Stack for for WOS, NOS stack

athena-<tenant_name>-GeoServerStack: CloudFormation Stack for GeoServer service


## Network

### VPC

VPC is always the Need when working with AWS. For creating a VPC all from scratch if you didn't have it.

Create the VPC Stack from template:

> Template Location: `./cloudformation/network/vpc/templates/vpc.yml`

### Security Groups

Some of the common security groups is necessary for your infrastructure, such as: VPN, Private Maven Repo, Controller, ...

Create the Common SecurityGroups Stack from template:

> Template Location: `./cloudformation/network/vpc/templates/securitygroups.yml`

## Resources

### S3 Buckets

Athena project use S3 Buckets to store: CFN Templates, Artifacts, Backup Data, ...

Create the Common SecurityGroups Stack from template:

> Template Location: `./cloudformation/network/resource/templates/s3.yml`

## Athena Project

**AWS Services used**: Autoscaling, LoadBalancerV2, S3 Static Webhosting, CloudFront, RDS, Security Groups, VPC

All of the templates to create AWS Resources for Athena Project is located in:

> Templates Location: `./cloudformation/athena`

Steps for creating the whole infrastructure of Athena:

1. Use script in `./cloudformation/athena/scripts/cfn/`

- For creating Prod Environments we should use: `stack-create.sh`
- For creating NonProd Environments we should use: `stack-create-nonprod.sh`

2. Edit the parameters in script with the appropriate values, for many cases the default values in script are good to go:

- `region`: which region will we deploy the environment. default is `us-east-2`
- `env`: environment which we want to deploy. Values is `prod` or `nonprod`
- `tenant`: which tenant will we deploy. Value of this parameter is important for deployment, we should choose it very carefully and don't let it be duplicated with the current environments which was created.

- `vpc_stack_name`: should keep the default value in script. `edulogvn-prod-vpc` for prod and `edulogvn-nonprod-vpc` for nonprod
- `db_master_password`: should keep the default value in script. Password for `postgres` user of PostgreSQL RDS.
- `fe_domain`: should keep the default value in script.`etstack.io` for prod and `karrostech.io` for nonprod.
- `fe_hostedzone_id`: should keep the default value in script.`Z12KP7UYAVP23S` for prod and `ZPNED8AYA0B4K` for nonprod.
- `fe_sslcertificate_id`: should keep the default value in script.

- `be_ami_id`: the AWS AMI Id of the Backend `release_version` which we want to deploy. We should choose the latest version which was tagged by QC Team.
- `db_snapshot_id`: the base RDS snapshot that we use to create RDS. We should choose the snapshot from RDS Base template, which has DB Identifier: `athena-rds-base` in AWS RDS.

3. Execute script:

- For prod environments:

```
cd ./cloudformation/athena/scripts/cfn
sh stack-create.sh
```

- For nonprod environments:

```
cd ./cloudformation/athena/scripts/cfn
sh stack-create-nonprod.sh
```

4. Wait for the stacks created with the complete status in AWS CloudFormation Console.

5. Go to EC2 Instances Console and get the Private IP Address of the Cache-Queue Instance. which will have the Prefix Name is: `athena-{tenant}-CQASGStack-xxxxxx`. Get the Private IP Address of it.

6. Go to AWS CloudFormation Console

- Choose the master stack of new environment, which will have stack_name: `athena-{tenant}`
- Click `Update` Button
- Choose `Use current template`
- Click `Next`
- Rolldown at the parameter `Cache-Queue Instance Private IP Address`: replace the value with the Private IP Address we got in step 5.
- Keep all of other values as they are.
- Click `Next`
- Click `Next`
- In Capabilities section: tick the 2 checkboxes for create IAM Resources and CAPABILITY_AUTO_EXPAND.
- Click `Update Stack`
- Wait for update completed.

7. Continue with the steps for configuring the Jenkins Job Deployment for Frontend and Backend in Jenkins.
   Guide for it can be found here: https://karrostech.atlassian.net/wiki/spaces/KTVNDEVOPS/pages/790397913/CI+CD

8. Deploy frontend with the latest `release_version` which tagged by QC Team here: https://karrostech.atlassian.net/wiki/spaces/AT/pages/574259624/Athena+Releases

- FE version is for Frontend
- BE version is for Backend.

## More Information on the templates of athena master and nested stacks.

> Template Location: `./cloudformation/athena/templates/athena.yml`

All of the AWS Resources will be created for you automatically. The main tiers resources include:

- **Frontend Tier**: `https://athena-{tenant/env}.{fe_domain}`

  - The `{tenant}` is for Production Environment that you want to create for which Tenant, such as: hallettsville, missoula, ...
  - The `{env}` is for Non-Production Environments that you want to create for dev, stage, demo.
  - AWS Services used:
    - S3 Bucket for hosting Angular SPA.
    - CloudFront for CDN of Athena Website.

  _Note: You can choose any domain as you want (not just karrostech.io), the only requirement is: that domain must have SSL Certificate that support AWS CloudFront (handled by AWS Certificate Manager in region Virginia)_

- **Backend Tier**: `https://ath-be-{tenant/env}.{be_domain}`

  - Athena Services:
    - Gateway
    - TransactionHUBV2
    - RoutingServer
    - GeoCodeService
    - IVIN
    - EDTA
    - PlannedRollover
  - AWS Services used:
    - Autoscaling: for Auto scale out the backend services of Athena base on policies (resources usage, CCU - concurrent users, on-demand requests)
    - Rolling update policy: new version of Athena services controlled by the CI/CD process which will update the AWS AMI of new version in Backend CFN Stack, updating version will be applied by rolling update model. --> No downtime to website, just has the moment that users will have chance to access older version of website in updating time.

- **Cache-Queue Tier**:

  - Cache: MongoDB
  - Queue: RabbitMQ with web STOMP plugin for supporting WebSocket.

- **Database Tier**: AWS RDS (PostgreSQL 12)

**After the Master CFN Stack completed:**

- Frontend: We will need to deploy the Frontend package to S3 Static Webhosting Bucket. Sample Jenkins Job for deploying Frontend to S3 is [here!](http://cicd.athena-nonprod.com/job/athena/job/dev/job/ath-fe-cicd-dev/)
- Backend: We will need
  - Update Master Stack with the `CQPrivateIP Address` and `CQInstanceId` of Cache-Queue instance in Cache-Queue Nested Stack -> This step will help backend sevices to connect with Cache & Queue in Cache-Queue Tier probably.
  - Deploy Athena Services by applying latest Image (AWS AMI) for Backend Stack. Sample Jenkins Job for deploying Backend Services to Backend Stack is [here!](http://cicd.athena-nonprod.com/job/athena/job/dev/)

## Setup Infrastructure for Athena Environments in new Region.

- Create VPC: `./cloudformation/network/vpc/templates/vpc.yml`

- Create VPC Peering from Management VPC (Athena Account - NonProd VPC) to new VPC

  - Requester:
  - Accepter:

- Create AWS IAM Role for creating Resources in other AWS Account.

- Create Jenkins Job for deploying Athena Environment Infrastructure to that Region
  - This job will need to execute aws cli command with a specific Role if it creates env on other AWS Account.

## References

- [Athena Infrastructure](https://karrostech.atlassian.net/wiki/spaces/KTVNDEVOPS/pages/791642406/Architecture)
- [Athena CI/CD](https://karrostech.atlassian.net/wiki/spaces/KTVNDEVOPS/pages/790397913/CI+CD)
- [VPN Access](https://karrostech.atlassian.net/wiki/spaces/AT/pages/701104830/How+to+Request+VPN+Profile)
- [VPN Bot Helpers](https://karrostech.atlassian.net/wiki/spaces/KTVNDEVOPS/pages/790331940/Bots)
