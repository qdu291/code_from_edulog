# Copy AMI to another region

## Input

profile
dest_region

ami_name
ami_id
dest_region

## Output

dest_ami_id

## Command

python3 copy_ami.py --profile=athena copy --ami_name=ATH-BE-1.0.0-122 --ami_id=ami-0467c683be7d3538c --region=us-east-2 --dest_region=eu-west-3
