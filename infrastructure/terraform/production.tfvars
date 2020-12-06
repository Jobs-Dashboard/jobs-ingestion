#--------------------------------------------------------------
# Production variables.
#
# There are two `.tfvars` files that complement each other:
#   production.secrets.auto.tfvars - a file that will NOT EVER contain secrets
#     and that should get checked in to the git repo.
#
#  production.secrets.auto.tfvars - a file that will contain all the secrets
#    and that should NOT EVER get checked in to the git repo.
#
# Here we should have all the variables (that were not already set in the
# `deploy.sh` script) that will be used to deploy this system into production
# for the first time.
#--------------------------------------------------------------

digdag_instance_type = "t2.micro"
ssh_key_name         = "jobs-ingestion-production"
rds_instance_type    = "db.t2.micro"
# Domain name of the hosted zone where a record should be added
zone_domain_name="jobs-dashboard.ml"
# Name of the record we wish to add to the zone_domain_name
# The record_name and zone_domain_name are combined in the
# route-53 module.
record_name="digdag"
# has the zone_domain_name as a suffix
full_record_name = "digdag.jobs-dashboard.ml"
postgres_user        = "digdag"
# This email address is used to send and receive email,
# and used as a contact email.
email_address = "jobs.dashboard.data@gmail.com"
github_repo_url = "github.com/Jobs-Dashboard/jobs-ingestion.git"
github_user = "buedaswag"
papertrail_url = "logs6.papertrailapp.com:30178"
# Name for the database instance, must be alphanumerical,
# to be used for labeling purposes
database_name = "DigdagDB"
