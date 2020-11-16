#--------------------------------------------------------------
# Production variables.
#
# This is coupled with a production.secrets.auto.tfvars
# file that will contain all the secret variables.
# This file should get checked in to the repo.
#
# Here we should have all the variables (that were not already set in the
# `deploy.sh` script) that will be used to deploy this system into production.
#--------------------------------------------------------------
stage                = "production"
digdag_instance_type = "t2.micro"
ssh_key_name         = "tracking-production"
rds_instance_type    = "db.t2.micro"
project_ssl_domain   = "jobs-dashboard.ml"
digdag_dns_record   = "digdag"
postgres_user        = "digdag"
email_address = "jobs.dashboard.data@gmail.com"
gitlab_user          = "digdag-server"
github_user = "buedaswag"
# we need to specify the orginization because the repository
# belongs to an organizartion and not a user
github_organization = "Jobs-Dashboard"
github_repo = "jobs-ingestion"
# This name is just for labeling purposes
iam_ses_smtp_username = "digdag"
