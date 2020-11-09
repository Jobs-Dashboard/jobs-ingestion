#--------------------------------------------------------------
# Production variables. This is coupled with a production.secrets.auto.tfvars
# file that will contain all the secret variables.
# This file should get checked in to the repo.
#--------------------------------------------------------------
stage                = "production"
digdag_instance_type = "t2.micro"
ssh_key_name         = "tracking-production"
rds_instance_type    = "db.t2.micro"
project_ssl_domain   = "jobs-dashboard.ml"
postgres_user        = "digdag"
mail_host            = "email-smtp.eu-west-1.amazonaws.com"
mail_username        = "a string like SEFXFJNEE"
gitlab_user          = "digdag-server"
github_user = "buedaswag"
# we need to specify the orginization because the repository
# belongs to an organizartion and not a user
github_organization = "Jobs-Dashboard"
github_repo = "jobs-ingestion"