#!/bin/bash

envType=$1

site_name=$2

be_host=$3

ssh_key=$4

if [ $envType = 'prod' ]; then
    awscmd="aws --profile prod";
    s3uri="s3://athena-prod-technical-check-results/results/"
else
    awscmd="aws";
    s3uri="s3://athena-nonprod-technical-check-results/results/"
fi

teid=$($awscmd cloudformation describe-stacks --stack-name athena-$site_name --output yaml --query "Stacks[0].Parameters[?ParameterKey=='TenantId'].ParameterValue" --output text)

nos=$($awscmd cloudformation describe-stacks --stack-name athena-$site_name --output yaml --query "Stacks[0].Outputs[?OutputKey=='WOSNOSHost'].OutputValue" --output text)

if [ "$nos" = "" ]; then
    nos=$($awscmd cloudformation describe-stacks --stack-name athena-$site_name-WOSNOSStack --output yaml --query "Stacks[0].Outputs[?OutputKey=='PrivateIp'].OutputValue" --output text)
fi

#clear last checking_result.txt
result_filepath="/usr/local/bin/technical_check/results/$envType/$site_name.txt"
if [ -f "$result_filepath" ]; then
echo "Clear last result file"
cat /dev/null > $result_filepath 
fi

#copy remote-box-command to remote host
scp -i $ssh_key -o "StrictHostKeyChecking no" /usr/local/bin/technical_check/remote-box-commands.sh ubuntu@$be_host:/tmp/remote-box-commands.sh
scp -i $ssh_key -o "StrictHostKeyChecking no" /usr/local/bin/technical_check/stdfile_$envType.txt ubuntu@$be_host:/tmp/stdfile.txt
#excute commands to get information
echo "chmod +x /tmp/remote-box-commands.sh && /bin/bash /tmp/remote-box-commands.sh -i $teid -n $nos && exit" | ssh -i $ssh_key -o "StrictHostKeyChecking no" ubuntu@$be_host > /usr/local/bin/technical_check/result_temp.txt

currentFeVersion=$(python3 scripts/python/getFeVersion.py --envType=$envType --siteName=$site_name)
currentBeVersion=$(python3 scripts/python/getBeVersion.py --envType=$envType --siteName=$site_name)
currentDbVersion=$(python3 scripts/python/getDbVersion.py --envType=$envType --siteName=$site_name)

#sleep 5
##Writing checking result



echo "******************** $site_name ***********************" >> $result_filepath
echo "Frontend Version: $currentFeVersion" >> $result_filepath
echo "Backend Version: $currentBeVersion" >> $result_filepath
echo "Database Version: $currentDbVersion" >> $result_filepath
echo " " >> $result_filepath
tail -n +28 /usr/local/bin/technical_check/result_temp.txt >> $result_filepath
echo " " >> $result_filepath

##upload to S3 bucket

echo $($awscmd s3 cp $result_filepath $s3uri )

echo "Please check result saved on $s3uri"

#done < $filename
