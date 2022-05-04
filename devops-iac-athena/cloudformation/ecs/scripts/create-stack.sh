

env="nonprod"
project="athena"
region="us-east-2"
author="ktvn-devops"
iac_dir="/Users/tankhuu/GitHub/Karros/devops-iac-athena"
template_body="file://${iac_dir}/cloudformation/ecs/templates/cluster.yml"

stack_name="${project}-ecs-cluster-${env}"
cluster_name="${project}-ecs-${env}"

aws --region $region cloudformation create-stack \
  --stack-name ${stack_name} \
  --capabilities CAPABILITY_IAM CAPABILITY_AUTO_EXPAND \
  --template-body ${template_body} \
  --tags \
    Key=environment,Value=${env} \
    Key=project,Value=${project} \
    Key=author,Value=${author} \
  --parameters \
    ParameterKey=Env,ParameterValue=${env} \
    ParameterKey=ClusterName,ParameterValue=${cluster_name}