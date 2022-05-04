#!/bin/bash

# (optional) You might need to set your PATH variable at the top here
# depending on how you run this script
#PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# Hosted Zone ID e.g. BJBK35SKMM9OE
ZONEID=$1

# The CNAME you want to update e.g. hello.example.com
RECORDSET=$2

# IP address of EC2 Instance
IP=$3

# AWS CLI PROFILE
AWS_PROFILE=$4

# Change this if you want
COMMENT="Auto updating @ `date`"
# Change to AAAA if using an IPv6 address
TYPE="A"

# Get current dir
# (from http://stackoverflow.com/a/246128/920350)
#DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
LOGFILE="/var/lib/jenkins/artemis/route53-record-logs/update-route53.log"
#LOGFILE="/Users/khuu/Desktop/devops-jenkins/scripts/bash/update-route53.log"
#IPFILE="$DIR/update-route53.ip"


#echo "IP has changed to $IP" >> "$LOGFILE"
# Fill a temp file with valid JSON

TMPFILE=$(touch ./route53-record.json)
cat > ./route53-record.json << EOF
{
  "Comment":"$COMMENT",
  "Changes":[
    {
      "Action":"UPSERT",
      "ResourceRecordSet":{
        "ResourceRecords":[
          {
            "Value":"$IP"
          }
        ],
        "Name":"$RECORDSET",
        "Type":"$TYPE",
        "TTL":300
      }
    }
  ]
}
EOF

# Update the Hosted Zone record
aws route53 change-resource-record-sets \
    --profile $AWS_PROFILE \
    --hosted-zone-id $ZONEID \
    --change-batch file://./route53-record.json >> "$LOGFILE"

echo "" >> "$LOGFILE"

# Clean up
rm ./route53-record.json
