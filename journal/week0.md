# Terraform Beginner Bootcamp 2023 - Week 0

## Semantic Versioning

It will be used the semantic versioning for tagging following the standards from [semver.org](https://semver.org/)

The general format:

 **MAJOR.MINOR.PATCH**, eg. `1.0.1`

- **MAJOR** version when you make incompatible API changes
- **MINOR** version when you add functionality in a backward compatible manner
- **PATCH** version when you make backward compatible bug fixes

## Installing the Terraform CLI

To install the Terraform CLI we had the following code in the `.gitpod.yml`

```sh
tasks:
  - name: terraform
    init: |
      sudo apt-get update && sudo apt-get install -y gnupg software-properties-common curl
      curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
      sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
      sudo apt-get update && sudo apt-get install terraform

```

But after initialize the envrionment on GitPod we found that the Terminal stuck during the installation and was waiting for a user interaction to continue. This is a bug that it need to be fixed.

ADD SCREENSHOT HERE

To do that we have to debug the code, runing the code line by line to check where is the issue.