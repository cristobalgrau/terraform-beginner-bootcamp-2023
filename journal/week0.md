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

![image](https://github.com/cristobalgrau/terraform-beginner-bootcamp-2023/assets/119089907/59d32ea2-797d-4046-a54b-b42632388623)


To do that we have to debug the code, running the code line by line to check where is the issue.

When we run the 2nd and the 3rd line, the Terminal shows: `apt-key is deprecated`

![image](https://github.com/cristobalgrau/terraform-beginner-bootcamp-2023/assets/119089907/060ea9bc-9b44-43f4-8cfd-df084e2d70d8)

Then we need to verify the latest [CLI install instruction](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli) from Terraform documentation and update the script. To verify which Linux distribution we are using, in order to determine the commands to install Terraform CLI we can run the following command:

```sh
cat /etc/os-release
```

![image](https://github.com/cristobalgrau/terraform-beginner-bootcamp-2023/assets/119089907/e464ec06-24b3-47c2-bcb4-3b4eaa0d210a)

According to the Linux distribution above we have the following code to install the Terraform CLI:

```sh
sudo apt-get update && sudo apt-get install -y gnupg software-properties-common curl

wget -O- https://apt.releases.hashicorp.com/gpg | \
gpg --dearmor | \
sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg

gpg --no-default-keyring \
--keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg \
--fingerprint

echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
sudo tee /etc/apt/sources.list.d/hashicorp.list

sudo apt update

sudo apt-get install terraform -y
```

### Refactoring into Bash Scripts

Due to this is a considerable amount of code to be added to the `gitpod.yml` and we want to keep our Gitpod task file easy to read and debug, we will create a Bash script to install the Terraform CLI that we can execute from our Gitpod task file, this will help to keep this kind of executions portable for other projects.

The bash script is located in [./bin/install_terraform_cli](./bin/install_terraform_cli)

#### Execution Considerations

For better portability for different OS distributions, we will use a [Shebang format](https://en.wikipedia.org/wiki/Shebang_(Unix)) at the beginning to tell the loader what is the interpreter to run the code.

In this case, we will add at the beginning the following:

```sh
#!/usr/bin/env bash
```

To use the script in `.gitpod.yml` we need to point it with the following command: 
```sh
source ./bin/install_terraform_cli
```

In order to make our bash scripts executable we need to change Linux permission for the fix to be executable in the user mode. Using the following references from [chmod Wikipedia](https://en.wikipedia.org/wiki/Chmod)

![image](https://github.com/cristobalgrau/terraform-beginner-bootcamp-2023/assets/119089907/9055f613-2a47-4035-8e6d-6d238f1c1749)
![image](https://github.com/cristobalgrau/terraform-beginner-bootcamp-2023/assets/119089907/d2dfea9d-ed73-4c84-b0e1-13e2507844e6)
![image](https://github.com/cristobalgrau/terraform-beginner-bootcamp-2023/assets/119089907/7cc918bd-ace4-4433-a98c-93904ec7bd42)

Run the following command:
```sh
chmod u+x ./bin/install_terraform_cli
```

After the chmod change the permissions for the file are the following:
![image](https://github.com/cristobalgrau/terraform-beginner-bootcamp-2023/assets/119089907/728a39ff-17f8-40f9-8df3-b51756386abf)

#### Gitpod Lifecycle

We have to adjust the initial code run on every workspace initialization according to the [Gitpod Lifecycle](https://www.gitpod.io/docs/configure/workspaces/tasks).

**Execution order**

With Gitpod, you have the following three types of tasks:

- **before**: Use this for tasks that need to run before init and before command. For example, customize the terminal or install global project dependencies.
- **init**: Use this for heavy-lifting tasks such as downloading dependencies or compiling source code.
- **command**: Use this to start your database or development server.

![image](https://github.com/cristobalgrau/terraform-beginner-bootcamp-2023/assets/119089907/4cee2199-d671-4e2a-a4c1-b19f776f1e67)

When you restart a workspace, Gitpod already executed the init task either as part of a Prebuild or when you start the workspace for the first time. As part of a workspace restart, Gitpod executes the before and command tasks. Then to avoid that the code couldn't be run after a restart we can change the `init` section to a `before` section.

At the end, it will change from this:
```sh
tasks:
  - name: terraform
    init: |
      sudo apt-get update && sudo apt-get install -y gnupg software-properties-common curl
      curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
      sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
      sudo apt-get update && sudo apt-get install terraform
```

To this new code:
```sh
tasks:
  - name: terraform
    before: |
      source ./bin/install_terraform_cli
```

## Environment Variables (Env Vars)

Environment variables allow us to pass information between commands and subprocesses.

### Env Commands

- `env` used to list out all the Env Vars
- `env | grep EXAMPLE` It will filter the env vars and show all that have EXAMPLE on their name
- `export HELLO='world'` it will make this variable available for all child terminals until restart the workspace
- `unset HELLO` will erase the value of the variable
- `echo $HELLO` will print the env var value 

We can set env vars temporarily when running a command

```sh
HELLO='world' ./bin/print_message
```

Within a bash script, we can set env without writing export eg.

```sh
#!/usr/bin/env bash

HELLO='world'

echo $HELLO
```

### Scope of env vars

Every bash terminal window open will have its own env vars. If you want the env vars to persist to all future bash terminals you need to set env vars in your bash profile `.bash_profile`

### Persistent Env Vars in Gitpod

We can persist env vars into Gitpod by storing them in Gitpod Secrets Storage.

```
gp env HELLO='world'
```

All future workspaces launched will set the env vars for all bash terminals opened in those workspaces.

You can also set en vars in the `.gitpod.yml` but this can only contain non-sensitive env vars.

## AWS CLI Installation

To install the AWS CLI we created a bash script [`./bin/install_aws_cli`](./bin/install_aws_cli)

Following the indication from [CLI Install - AWS Documentation](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html#getting-started-install-instructions), for Linux we have to use the following instruction:

```sh
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
```

To set the Env Vars we follow the indications from [Env Vars to configure the AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html)

```sh
export AWS_ACCESS_KEY_ID=AKIAIOSFODNN7EXAMPLE
export AWS_SECRET_ACCESS_KEY=wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
export AWS_DEFAULT_REGION=us-west-2
```

To set the Env Vars on Gitpod Secrets do the following:
```sh
gp env AWS_ACCESS_KEY_ID=AKIAIOSFODNN7EXAMPLE
gp env AWS_SECRET_ACCESS_KEY=wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
gp env AWS_DEFAULT_REGION=us-west-2
```

We can verify if the credentials were set correctly by running the following AWS command:
```sh
aws sts get-caller-identity
```

If it is successful you should see a JSON payload return that looks like this:

```json
{
    "UserId": "AIEAVUO15ZPVHJ5WIJ5KR",
    "Account": "123456789012",
    "Arn": "arn:aws:iam::123456789012:user/terraform-beginner-bootcamp"
}
```

## Terraform Basics

### Terraform Registry

The Terraform Registry is an interactive resource for discovering a wide selection of integrations (providers), and configuration packages (modules). [registry.terraform.io](https://registry.terraform.io/)

- **Providers** is an interface to APIs that will allow to create resources in terraform.
- **Modules** are a way to make large amount of terraform code modular, portable and sharable.

### Terraform Random Provider

The "random" provider allows the use of randomness within Terraform configurations. The "random" provider provides an idea of managed randomness: it provides resources that generate random values during their creation and then hold those values steady until the inputs are changed.

[hashicorp/random](https://registry.terraform.io/providers/hashicorp/random/3.5.1)

To install this provider, copy and paste this code into your Terraform configuration. Then, run terraform init.

```terraform
terraform {
  required_providers {
    random = {
      source = "hashicorp/random"
      version = "3.5.1"
    }
  }
}

provider "random" {
  # Configuration options
}
```

This provider has the following resources:

- `random_id` generates random numbers that are intended to be used as unique identifiers for other resources.
- `random_integer` generates random values from a given range, described by the min and max attributes of a given resource.
- `random_password` Identical to random_string with the exception that the result is treated as sensitive and, thus, not displayed in the console output.
- `random_pet` generates random pet names that are intended to be used as unique identifiers for other resources.
- `random_shuffle` generates a random permutation of a list of strings given as an argument.
- `random_string` generates a random permutation of alphanumeric characters and optionally special characters.
- `random_uuid` generates random uuid string that is intended to be used as unique identifiers for other resources.


### Terraform Workflow

![image](https://github.com/cristobalgrau/terraform-beginner-bootcamp-2023/assets/119089907/2d02b62c-245f-4c80-8874-97ee354b836f)


- `terraform init`
Used to initialize a working directory containing terraform config files. It will download the binaries for the terraform providers we will use in this project

- `terraform validate`
Validate the terraform configuration files in that respective directory to ensure they are Syntactically valid and internally consistent.

- `terraform plan`
creates an execution plan, which lets you preview the changes that Terraform plans to make to your infrastructure.

  We can output this changeset ie. "plan" to be passed to an apply, but often you can just ignore outputting.

- `terraform apply`
This will run the plan and pass the changes to be executed by Terraform

  This command will prompt a stop waiting for the user to confirm yes or no to execute the plan. You can auto-approve the command with `terraform apply --auto-approve`

- `terraform destroy`
Used to destroy the Terraform-managed infrastructure. It will ask you for confirmation before destroyed. You can auto-approve with the command `terraform destroy --auto-aprove`

### Terraform Files

`.terraform.tfstate` is a JSON formatted mapping file that contains information about the current state of your infrastructure.

This file **should not be committed** to your Versioning Control System.

This file can contain sensitive data.

If you lose this file, you lose knowing the state of your infrastructure.

`.terraform.tfstate.backup` is the previous state file state.

`.terraform.lock.hcl` contains the locked versioning for the providers or modules that should be used with this project.

The Terraform Lock File **should be committed** to your Version Control System (VSC) eg. Github

### Terraform Directory

`.terraform` directory contains binaries of terraform providers. This directory should not be committed either.

