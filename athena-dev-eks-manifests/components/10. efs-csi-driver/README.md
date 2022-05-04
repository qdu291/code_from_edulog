1. Create an IAM policy that allows the CSI driver's service account to make calls to AWS APIs on your behalf.
```
curl -o iam-policy-example.json https://raw.githubusercontent.com/kubernetes-sigs/aws-efs-csi-driver/v1.3.2/docs/iam-policy-example.json
```

2. Create the policy. You can change AmazonEKS_EFS_CSI_Driver_Policy to a different name, but if you do, make sure to change it in later steps too.
```
aws iam create-policy \
    --policy-name AmazonEKS_EFS_CSI_Driver_Policy \
    --policy-document file://iam-policy-example.json
```
==> arn:aws:iam::696952606624:policy/AmazonEKS_EFS_CSI_Driver_Policy

3. Create an IAM role and attach the IAM policy to it. Annotate the Kubernetes service account with the IAM role ARN and the IAM role with the Kubernetes service account name. You can create the role using eksctl or the AWS CLI.
```
eksctl create iamserviceaccount \
    --name efs-csi-controller-sa \
    --namespace kube-system \
    --cluster athena-eks-dev \
    --attach-policy-arn arn:aws:iam::696952606624:policy/AmazonEKS_EFS_CSI_Driver_Policy \
    --approve \
    --override-existing-serviceaccounts \
    --region us-east-2
```

4. Install the Amazon EFS driver
```
sudo helm repo add aws-efs-csi-driver https://kubernetes-sigs.github.io/aws-efs-csi-driver/
sudo helm repo update

helm upgrade -i aws-efs-csi-driver aws-efs-csi-driver/aws-efs-csi-driver \
    --namespace kube-system \
    --set image.repository=602401143452.dkr.ecr.us-east-2.amazonaws.com/eks/aws-efs-csi-driver \
    --set controller.serviceAccount.create=false \
    --set controller.serviceAccount.name=efs-csi-controller-sa
```

5. Create an Amazon EFS file system
a. Retrieve the VPC ID that your cluster is in and store it in a variable for use in a later step. Replace my-cluster with your cluster name.
```
vpc_id=$(aws eks describe-cluster \
    --name athena-eks-dev \
    --query "cluster.resourcesVpcConfig.vpcId" \
    --output text)

cidr_range=$(aws ec2 describe-vpcs \
    --vpc-ids $vpc_id \
    --query "Vpcs[].CidrBlock" \
    --output text)

security_group_id=$(aws ec2 create-security-group \
    --group-name MyEfsSecurityGroup \
    --description "My EFS security group" \
    --vpc-id $vpc_id \
    --output text)

security_group_id=$(aws ec2 create-security-group \
    --group-name athena-eks-dev-EfsSecurityGroup \
    --description "athena-eks-dev EFS security group" \
    --vpc-id $vpc_id \
    --output text)

aws ec2 authorize-security-group-ingress \
    --group-id $security_group_id \
    --protocol tcp \
    --port 2049 \
    --cidr $cidr_range

==> sg-0bd195e4793cb7834
```

6. Create an Amazon EFS file system for your Amazon EKS cluster.
a. Create a file system. Replace region-code with the Region that your cluster is in.
```
file_system_id=$(aws efs create-file-system \
    --region us-east-2 \
    --performance-mode generalPurpose \
    --query 'FileSystemId' \
    --output text)
```

7. (*) Create mount targets.
aws efs create-mount-target \
    --file-system-id $file_system_id \
    --subnet-id subnet-022df13b164298e4a \
    --security-groups $security_group_id



aws efs create-access-point --file-system-id fs-08da9fd022e8d61bd
    "ClientToken": "7d6af87d-fe1f-423b-a8af-2364f884f0c2",
    "Tags": [],
    "AccessPointId": "fsap-0f157b6e2df3dd37f",
    "AccessPointArn": "arn:aws:elasticfilesystem:us-east-2:696952606624:access-point/fsap-0f157b6e2df3dd37f",
    "FileSystemId": "fs-08da9fd022e8d61bd",
    "RootDirectory": {
        "Path": "/"
    },
    "OwnerId": "696952606624",
    "LifeCycleState": "creating"