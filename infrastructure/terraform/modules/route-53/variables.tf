# like "jobs-dashboard.ml"
variable "project_ssl_domain" {}

# This is a prefix to the project_ssl_domain. (ex:
# project_ssl_domain="jobs-dashboard.ml" and digdag_dns_record="digdag" would
# result in the following domain for the digdag server:
# "digdag.jobs-dashboard.ml")
variable "digdag_dns_record" {}
