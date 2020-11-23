# Get SSL/TLS certificates for the chosen domains

AWS Certificate Manager removes the time-consuming manual process of purchasing, uploading, and renewing SSL/TLS certificates. <https://aws.amazon.com/certificate-manager/>

Steps:

1. Request Certificate or Provision certificates
1. Request a Public Certificate
1. Add your domain name (this is the `digdag_ssl_domain`), and press "Next"
1. Choose DNS validation
1. Press "Review" and then "Confirm and Request"
1. Go to your domain name provider (for this project it's <https://my.freenom.com/>) and follow the instructions to create a CNAME In your DNS configuration, so that the certificate can be issued (this step can take some time, from 15 min to 48h, it took me around 10 minutes)

TODO: still dont know if the bellow is needed

1. When the process is concluded, take note of the ARN of your certificate (under "Details")
1. Enter the certificate ARN in the `stage`.tfvars file

arn is here https://eu-west-1.console.aws.amazon.com/acm/home?region=eu-west-1#/?id=27c92a8e-8d9a-4b6f-bba2-26329acf0751