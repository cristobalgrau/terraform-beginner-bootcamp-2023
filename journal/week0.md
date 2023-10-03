# Terraform Beginner Bootcamp 2023 - Week 0

- [Semantic Versioning](#semantic-versioning)
- [Installing the Terraform CLI](#installing-the-terraform-cli)
  * [Refactoring into Bash Scripts](#refactoring-into-bash-scripts)
    + [Execution Considerations](#execution-considerations)
    + [Gitpod Lifecycle](#gitpod-lifecycle)
- [Environment Variables (Env Vars)](#environment-variables-env-vars)
  * [Env Commands](#env-commands)
  * [Scope of env vars](#scope-of-env-vars)
  * [Persistent Env Vars in Gitpod](#persistent-env-vars-in-gitpod)
- [AWS CLI Installation](#aws-cli-installation)
- [Terraform Basics](#terraform-basics)
  * [Terraform Registry](#terraform-registry)
  * [Terraform Random Provider](#terraform-random-provider)
  * [Terraform Workflow](#terraform-workflow)
  * [Terraform Files](#terraform-files)
  * [Terraform Directory](#terraform-directory)
- [Creating S3 Bucket in Terraform](#creating-s3-bucket-in-terraform)
- [Terraform Cloud](#terraform-cloud)
  * [Terraform Cloud Structucture](#terraform-cloud-structucture)
    + [Project](#project)
    + [Workspaces](#workspaces)
  * [Creating the environment in Terraform Cloud Organizations](#creating-the-environment-in-terraform-cloud-organizations)
  * [Possible issues running `terraform login`](#possible-issues-running-terraform-login)
- [Refactor Automated Terraform Login](#refactor-automated-terraform-login)
- [Creating an Alias for `terraform` command](#creating-an-alias-for-terraform-command)

<small><i><a href='http://ecotrust-canada.github.io/markdown-toc/'>Table of contents generated with markdown-toc</a></i></small>

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

## Creating S3 Bucket in Terraform

We have to look in the Terraform Registry the AWS provider and look for S3 (Simple Storage). From there we will use the following code and add to `main.tf`

```terraform
resource "aws_s3_bucket" "example" {
  bucket = random_string.bucket_name.result
}
```

Then after run `terraform plan` it shows an error due to there is no AWS provider installed yet

![image](https://github.com/cristobalgrau/terraform-beginner-bootcamp-2023/assets/119089907/f1c2be32-65c0-4f03-b158-c199e224ae11)

Then we look for the code to use the AWS provider and add it to `main.tf`

```terraform
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.17.0"
    }
  }
}

provider "aws" {
  # Configuration options
}
```

If you run the command `terraform command` with two lines with 'required_providers' will shows the following error due to it is not allow to have more than one 'required_providers', all providers should have to be in the same block

![image](https://github.com/cristobalgrau/terraform-beginner-bootcamp-2023/assets/119089907/e1e7d937-ce9c-4772-837c-623ec0f420f2)

We have to modify the `main.tf` code as follows:

```terraform
terraform {
  required_providers {
    random = {
      source = "hashicorp/random"
      version = "3.5.1"
    }
    aws = {
      source = "hashicorp/aws"
      version = "5.17.0"
    }
  }
}
```

Even with this, it will still show error

![image](https://github.com/cristobalgrau/terraform-beginner-bootcamp-2023/assets/119089907/4d718ab4-4563-48a6-9a66-5b90d286c23a)

This is because any time you add a new provider you have to run again the `terraform init` to recreate a new binary file with the updated providers.

After that, the result will be like this:

![image](https://github.com/cristobalgrau/terraform-beginner-bootcamp-2023/assets/119089907/fbc1013a-4ace-4593-a8b4-d114c26ffa5f)

Running the command `terraform apply`, now we have an issue with the S3 Bucket name due to by AWS rules, it is only allow lower case for the name

![image](https://github.com/cristobalgrau/terraform-beginner-bootcamp-2023/assets/119089907/3b5485bb-c94a-41a3-b301-3bc10ea09b99)

Looking for [hashicorp/random_string documentation](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) we can exclude and allow some options in the string. 

The random_string commands will be updated like this:

```terraform
resource "random_string" "bucket_name" {
  lower = true
  upper = false 
  length = 32
  special = false
}
```

Running `terraform plan`

![image](https://github.com/cristobalgrau/terraform-beginner-bootcamp-2023/assets/119089907/769f015c-82ff-4654-94bc-38143eff6876)

Running `terraform apply`

![image](https://github.com/cristobalgrau/terraform-beginner-bootcamp-2023/assets/119089907/f1239249-ec04-43ee-9f60-0910feb18587)

![image](https://github.com/cristobalgrau/terraform-beginner-bootcamp-2023/assets/119089907/a6dbcd37-77dc-4418-ad5e-e08a859199ae)

At the end let run the command `terraform destroy` to eliminate the S3 bucket

![image](https://github.com/cristobalgrau/terraform-beginner-bootcamp-2023/assets/119089907/01eb3a3c-8f89-4d04-a9f8-992a0d6e039c)

## Terraform Cloud

Terraform is used for defining and provisioning infrastructure resources as code, which allows for the automation and management of cloud resources, on-premises infrastructure, and more. It provides a centralized hub for collaboration, version control, state management, and more, which can lead to improved infrastructure management practices and increased efficiency in deploying and managing infrastructure as code.

### Terraform Cloud Structucture

![image](https://github.com/cristobalgrau/terraform-beginner-bootcamp-2023/assets/119089907/8c61474f-5b06-4562-81e4-85f01cce4b0e)

#### Project

 It provides a way to group related workspaces and associated infrastructure code. Projects are typically used to organize infrastructure work by teams, departments, or specific projects within your organization.

#### Workspaces

Workspace is a specific environment for managing and executing Terraform configurations. Each workspace corresponds to a set of infrastructure code (Terraform configurations) and associated variables and settings.

### Creating the environment in Terraform Cloud Organizations

After you create your Project and Workspace, Terraform will show you the commands to associate the Terraform configuration files and the next instruction to run your terraform plan

Add the following codes to `main.tf`

```terraform
  cloud {
    organization = "GrauTerraformLab"

    workspaces {
      name = "terra-house-lab"
    }
  }
```

After run `terraform init` it shows the following error

![image](https://github.com/cristobalgrau/terraform-beginner-bootcamp-2023/assets/119089907/92f41345-52ab-41a6-9184-469817722e5e)

Following the instructions received from the Terraform init command, we have to run the command `terraform login`

![image](https://github.com/cristobalgrau/terraform-beginner-bootcamp-2023/assets/119089907/eb81761c-991e-49e1-a897-788df5e7de66)

![image](https://github.com/cristobalgrau/terraform-beginner-bootcamp-2023/assets/119089907/5efc13ff-9074-4c1c-a959-15d5d3a9bf4a)

![image](https://github.com/cristobalgrau/terraform-beginner-bootcamp-2023/assets/119089907/cac22846-e7b6-441c-98d0-46d66f338699)

Then you have to open the URL shown in the prompt and create the Token

![image](https://github.com/cristobalgrau/terraform-beginner-bootcamp-2023/assets/119089907/37a84682-7f9e-4b05-8440-5dc317c36ecc)

![image](https://github.com/cristobalgrau/terraform-beginner-bootcamp-2023/assets/119089907/33c7b0a9-a4f4-4938-a0f7-8ef1faa095ab)

Run `terraform init` again to migrate

![image](https://github.com/cristobalgrau/terraform-beginner-bootcamp-2023/assets/119089907/61a3a5dd-8724-4668-b164-f0b31b0de57a)

Then you can see in your Terraform Cloud workspace the following showing your buckets created and migrated to Terraform Cloud

![image](https://github.com/cristobalgrau/terraform-beginner-bootcamp-2023/assets/119089907/2aabd992-fc3c-45b3-8587-1ba309e3492f)

### Possible issues running `terraform login`

Sometimes you can have problems/erros when entering the Token in the login process, if that the case then you have to manually generate a token in Terraform Cloud

```
https://app.terraform.io/app/settings/tokens?source=terraform-login
```

Then create and open the file manually with the following commands:

```sh
touch /home/gitpod/.terraform.d/credentials.tfrc.json
open /home/gitpod/.terraform.d/credentials.tfrc.json
```

Provide the following code in the file `credentials.tfrc.json`:

```json
{
  "credentials": {
    "app.terraform.io": {
      "token": "YOUR-TERRAFORM-CLOUD-TOKEN"
    }
  }
}
```

And then you should be able to run the command `terraform login` without issues

## Refactor Automated Terraform Login

First, we need to create a bash script file to create the file `credentials.tfrc.json` where we can set the token value with an Env Vars. The token has to be created with a long expiration time according to your planned time for this lab.

Using ChatGPT to generate the bash script we have the following code and save it on the file [`generate_tfrc_credentials`](/bin/generate_tfrc_credentials):

```sh
#!/usr/bin/env bash

# Define target directory and file
TARGET_DIR="/home/gitpod/.terraform.d"
TARGET_FILE="${TARGET_DIR}/credentials.tfrc.json"

# Check if TERRAFORM_CLOUD_TOKEN is set
if [ -z "$TERRAFORM_CLOUD_TOKEN" ]; then
    echo "Error: TERRAFORM_CLOUD_TOKEN environment variable is not set."
    exit 1
fi

# Check if directory exists, if not, create it
if [ ! -d "$TARGET_DIR" ]; then
    mkdir -p "$TARGET_DIR"
fi

# Generate credentials.tfrc.json with the token
cat > "$TARGET_FILE" << EOF
{
  "credentials": {
    "app.terraform.io": {
      "token": "$TERRAFORM_CLOUD_TOKEN"
    }
  }
}
EOF

echo "${TARGET_FILE} has been generated."
```



To make the file `generate_tfrc_credentials` executable we have to chmod it

```
chmod u+x ./bin/generate_tfrc_credentials
```

You can use the following command in the Terminal to verify if the file was created and its content:

```sh
cat /home/gitpod/.terraform.d/credentials.tfrc.json
```

Then you have to call the bash script file from `gitpod.yml` by adding the following command below the install_aws_cli call:

```sh
source ./bin/generate_tfrc_credentials
```

`.gitpod.yml`:
```sh
tasks:
  - name: terraform
    before: |
      source ./bin/install_terraform_cli
      source ./bin/generate_tfrc_credentials
  - name: aws-cli
    env:
      AWS_CLI_AUTO_PROMPT: on-partial
    before: |
      source ./bin/install_aws_cli
vscode:
  extensions:
    - amazonwebservices.aws-toolkit-vscode
    - hashicorp.terraform
```

## Creating an Alias for `terraform` command

We can create an alias for shorten call the command `terraform`. We will use the alias 'tf'.

To do that we have to open the file `bash_profile` with the following command

```sh
open ~/.bash_profile
```

Then in the `bash_profile` we add the following code:

```sh
alias tf="terraform"
```

Using ChatGTP we generate the following bash script to add the alias in the `bash_profile` everytime we open the gitpod workspace, due to in the above instruction, after you restart the gitpod environment it will not be there.

The bash script will be save it in out bin folder as [`set_tf_alias`](./bin/set_tf_alias)

```sh
#!/usr/bin/env bash

# Check if the alias already exists in the .bash_profile
grep -q 'alias tf="terraform"' ~/.bash_profile

# $? is a special variable in bash that holds the exit status of the last command executed
if [ $? -ne 0 ]; then
    # If the alias does not exist, append it
    echo 'alias tf="terraform"' >> ~/.bash_profile
    echo "Alias added successfully."
else
    # Inform the user if the alias already exists
    echo "Alias already exists in .bash_profile."
fi

# Optional: source the .bash_profile to make the alias available immediately
source ~/.bash_profile
```

Making executable the file

```sh
chmod u+x ./bin/set_tf_alias
```

Later we have to add to `.gitpod.yml` file to run in both Terminal (terraform and aws-cli):

```sh
source ./bin/set_tf_alias
```
![image](https://github.com/cristobalgrau/terraform-beginner-bootcamp-2023/assets/119089907/9cc30c75-b1b0-433b-a1e5-45a8c83b93ec)

