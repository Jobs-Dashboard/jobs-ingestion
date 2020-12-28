# infrastructure

## How to deploy this infrastructure:

The deployment is done using the `deploy.sh` script located at the infrastructure folder.
There is a set manual steps that you need to do before you run the script, and also a set of manual steps to do after running the script.

1. alocate a domain name for the project by going to <https://my.freenom.com/>
1. [set up sending email](EMAIL.md) to receive alerts from the digdag server
1. install terraform or check that it is installed
    * <https://learn.hashicorp.com/tutorials/terraform/install-cli#install-terraform>
1. install aws cli or check that it is installed
    * <https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html>
    * configure aws cli
        * <https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html>
1. manually create the s3 bucket that will contain the terraform state os the infrastructure in this project (the project is called jobs-dashboard, and inside the bucket there will be a folder for each repo's infrastructure)
1. create the github token so that the server can authenticate and pull code from the repo. You can see the details [here](https://docs.github.com/en/free-pro-team@latest/github/authenticating-to-github/creating-a-personal-access-token).
1. Create a SSH key pair in AWS console. You can see the details [here](https://docs.aws.amazon.com/cli/latest/userguide/cli-services-ec2-keypairs.html#creating-a-key-pair). Please take note of the key pair name.

    ```bash
    cd ~/.ssh/
    aws ec2 create-key-pair --key-name jobs-ingestion-production --query 'KeyMaterial' --output text > jobs-ingestion-production.pem
    chmod 660 jobs-ingestion-production.pem
    ```

1. Create a papertrail account and get the logging url (like logs6.papertrailapp.com:30178)

Now run `deploy_<stage>.sh`

Manual steps to do after the script:

1. Create a record on freenom with the name we chose in the `<stage>.tfvars` file and wait 30 min for it to take effect
1. after the record has taken effect, you must ssh into the ec2 machine with a root shell and run certbot by going to the nginx configuratin file and running the last line titled `# Run certbot`

## Credentials and secrets

* credentials and secrets are managed on <vault.bitwarden.com>
