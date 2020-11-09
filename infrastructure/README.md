# infrastructure

## How to deploy this infrastructure:

The deployment is done using the `deploy.sh` script located at the infrastructure folder.
There is a set manual steps that you need to do before you run the script, and also a set of manual steps to do after running the script.

1. install terraform or check that it is installed
    * <https://learn.hashicorp.com/tutorials/terraform/install-cli#install-terraform>
1. install aws cli or check that it is installed
    * <https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html>
    * configure aws cli
        * <https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html>
1. manually create the s3 bucket that will contain the terraform state os the infrastructure in this project (the project is called jobs-dashboard, and inside the bucket there will be a folder for each repo's infrastructure)
1. TODO alocate a domain name for the project by going to [https://my.freenom.com/](https://my.freenom.com/)
1. TODO setul an email service to receive alerts for the digdag server (TODO explain how)
1. TODO create the github token so that the server can authenticate and pull code from the repo. You can see the details
[here](https://docs.github.com/en/free-pro-team@latest/github/authenticating-to-github/creating-a-personal-access-token).
1. Create a SSH key pair in AWS console. You can see the details
[here](https://docs.aws.amazon.com/cli/latest/userguide/cli-services-ec2-keypairs.html#creating-a-key-pair). Please take note of the key pair name.

```bash
cd ~/.ssh/
aws ec2 create-key-pair --key-name jobs-ingestion-production --query 'KeyMaterial' --output text > jobs-ingestion-production.pem
chmod 660 jobs-ingestion-production.pem
```

Now run `deploy.sh`

Manual steps to do after the script:

1. update the name servers for the domain
    * take note of the aws_route53_zone.<resource-name>.name_servers
    * go to [https://my.freenom.com/](https://my.freenom.com/) in Services -> My Domains -> Management Tools -> Nameservers
    * input the list of name servers into the custom nameservers
    * check that it's working with `nslookup <domain name>`
