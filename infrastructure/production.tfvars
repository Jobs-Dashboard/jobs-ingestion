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
ssh_key_name         = "jobs-ingestion-production.pem"
rds_instance_type    = "db.t2.micro"
project_ssl_domain   = "jobs-dashboard.ml"
# has the project_ssl_domain as a suffix
digdag_ssl_domain = "digdag.jobs-dashboard.ml"
postgres_user        = "digdag"
email_address = "jobs.dashboard.data@gmail.com"
github_repo_url = "github.com/Jobs-Dashboard/jobs-ingestion.git"
github_user = "buedaswag"
# we need to specify the orginization because the repository
# belongs to an organizartion and not a user
# This name is just for labeling purposes
iam_ses_smtp_username = "digdag"
papertrail_url = "logs6.papertrailapp.com:30178"
# still dont know if i need to include this here
certificate_arn = ""