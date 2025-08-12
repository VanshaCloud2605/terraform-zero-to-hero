Say the Team has created a S3 bucket with Versioning off using Terraform. Some team member has mistakenly updated that bucket versioning status to ON. If we will run terraform plan, we can review that manual change via AWS UI has been made, but say all the team members forgot to execute terraform plan.

This scenario is called "Drift Detection"
Note : in main_scenario2.tf, I have not given provider as we cannot use two provider blocks for two different main.tf files.

Now S3 Bucket has been created.
Now I have manually changed the Bucket versioning to "enabled"
Fisrt use : Terraform plan
aws_s3_bucket_versioning.versioning_example: Refreshing state... [id=my-bucket-11082025]

Planning failed. Terraform encountered an error while generating this plan.

╷
│ Error: versioning_configuration.status cannot be updated from 'Enabled' to 'Disabled'
│ 
│   with aws_s3_bucket_versioning.versioning_example,
│   on main_scenario2.tf line 5, in resource "aws_s3_bucket_versioning" "versioning_example":
│    5: resource "aws_s3_bucket_versioning" "versioning_example" {

Use : terraform refresh on the terminal
In the terraform.tfstate,we can find that the versioning status is disabled.
Hence the state file is not aware of the exact changes happened on S3 bucket manually but it can detect that on running terraform plan that we are changing versioning state from enabled to disabled.

*********************************************************************************************
Read the below statements to understand what Refresh does exactly:
**********************************************************************************************
🔄 What terraform refresh Does
terraform refresh updates the Terraform state file to reflect the real-world infrastructure. It checks the actual resources in your cloud provider (like AWS) and updates the local state to match.

It does not change infrastructure, but it syncs the state with what's currently deployed.

⚠️ Why You're Seeing This Error
You're getting this error:

Error: versioning_configuration.status cannot be updated from 'Enabled' to 'Disabled'
Because Terraform is trying to refresh the state of an S3 bucket versioning configuration, and it sees a mismatch:

The actual AWS S3 bucket has versioning enabled.
Your Terraform configuration (main_scenario2.tf) says versioning should be disabled.
Terraform is trying to reconcile this during the refresh, but S3 bucket versioning is immutable in certain ways — you cannot disable versioning once it's enabled. AWS only allows you to suspend it, not fully disable it.

✅ How to Fix It
You have a few options:

Option 1: Suspend Instead of Disable
Update your config to use Suspended instead of Disabled:


Option 2: Match the Real State
If you want to keep versioning enabled, update your config to:


Option 3: Recreate the Bucket (if needed)
If you must disable versioning, you'll need to:

Delete the bucket manually or via Terraform.
Recreate it with versioning disabled.


****************************************************************************************
Setting up a cron job in your Linux Machine to run terraform refresh periodically.
Update and install CRON on your Linux System.
1. sudo apt update && sudo apt install cron -y

Start the cron service
2. sudo service cron start


3. Open your crontab editor
crontab -e

4. Run the Cron job every 10 min (example)
*/10 * * * * cd /workspaces/terraform-zero-to-hero/Terraform-Scenario-Project2 && /usr/local/bin/terraform init -input=false && /usr/local/bin/terraform refresh -input=false >> /workspaces/terraform-zero-to-hero/Terraform-Scenario-Project2/cron_debug.log 2>&1

To see the error logs:

cat /workspaces/terraform-zero-to-hero/Terraform-Scenario-Project2/cron_debug.log


*******************************************************************************



********************************************************************************
