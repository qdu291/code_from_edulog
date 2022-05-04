# Copy AMI to another region

## Input

profile
ami_id
region

dest_ami_id
dest_region

## Output

dest_ami_id

## Command

python3 tag_ami.py tag --profile=athena --ami_id=ami-0c033593142711192 --region=us-east-2 --dest_ami_id=ami-02d9f02c167174cd4 --dest_region=eu-west-3
