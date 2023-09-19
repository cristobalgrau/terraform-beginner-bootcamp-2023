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



