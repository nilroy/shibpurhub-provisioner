# 2k6-provisioner
This repo contains tools and chef cookbooks to install and maintain 2k6 systems.

## Provisioning
A user need sudo permission to provision

* Clone this repo
* Run provioner script

`#./provisioner.sh --env <environment> --role <role> --name <servername>`

> Note: Roles can be mongodb,elasticsearch or mongo_es (includes both mongodb and elasticsearch). Environment can be staging/prod.
You can find all roles in [roles](https://github.com/nilroy/2k6-provisioner/tree/master/dna)


## Contibuting

* Fork the project
* Contribute your code
* Commit your changes.
* Rebase your branch with the upstream so that you have the latest changes (https://github.com/edx/edx-platform/wiki/How-to-Rebase-a-Pull-Request)
* Create a pull request
