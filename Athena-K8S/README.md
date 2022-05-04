## EKS CLUSTER

#### Prequisites
You will need to make sure you have the following components installed and set up before you start with Amazon EKS:


- AWS CLI – For further instructions, [click here](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html) <br /> 

- Kubectl – used for communicating with the cluster API server. For further instructions on installing kubectl, [click here](https://docs.aws.amazon.com/eks/latest/userguide/install-kubectl.html)


#### Account Setting
```
dongnguyen@Dongs-MacBook-Pro k8s-config % aws configure --profile athena
AWS Access Key ID [****************4AYA]: AKIA******************WHW
AWS Secret Access Key [****************pgrz]: mCfxa*************************cO15M
Default region name [us-east-2]: 
Default output format [json]: 
```

Be noted to swith the default config to athena:
```
export AWS_DEFAULT_PROFILE=athena
```

#### Usage

Execute these step to bring up a AWS VPC as your needs:
```bash
terraform init
terraform plan
terraform apply
```

Run the following command:
```
aws eks --region us-east-2 update-kubeconfig --name ethena-eks-nonprod --profile athena
```
When you run into the following error:
```
$ kubectl get node
error: You must be logged in to the server (Unauthorized)
```