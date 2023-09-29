# Terraform Beginner Bootcamp 2023 - Week 1

## Root Module Structure

Our root module structure is as follows:

```
PROJECT_ROOT
│
├── main.tf                 # everything else.
├── variables.tf            # stores the structure of input variables
├── terraform.tfvars        # the data of variables we want to load into our terraform project
├── providers.tf            # defined required providers and their configuration
├── outputs.tf              # stores our outputs
└── README.md               # required for root modules
```

[Standard Module Structure](https://developer.hashicorp.com/terraform/language/modules/develop/structure)

## Terraform and Input Variables

### Terraform Cloud Variables

If you've set environment variables only in your local terminal, Terraform Cloud will not have direct access to those environment variables. When Terraform runs in Terraform Cloud, it operates in a separate environment that doesn't inherit the environment variables from your local terminal.

To make your Terraform configurations work in Terraform Cloud, you should configure your Terraform Cloud workspace to use the necessary variables.

In terraform we can set two kinds of variables:

- `Environment Variables` - those you would set in your bash terminal eg. AWS credentials
- `Terraform Variables` - those that you would normally set in your tfvars file

We can set Terraform Cloud variables to be sensitive so they are not shown visibly in the Terraform UI.

### Input Variables

In Terraform, input variables are a way to parameterize your infrastructure code. They allow you to define values that can be passed into your Terraform configurations when you run `terraform apply`. Input variables are a fundamental concept in Terraform, and they provide a flexible way to customize your infrastructure deployments without modifying the underlying code.

You can find more documentation in [Terraform Input Variables](https://developer.hashicorp.com/terraform/language/values/variables)

### Command-line Flags

In Terraform, you can use command-line flags to pass variable values when running Terraform commands. These flags allow you to provide values for variables without modifying the Terraform configuration files directly. Here are some common command-line flags related to variables in Terraform:

- `-var` flag: This flag allows you to specify a single variable and its value in the format `-var "variable_name=value"`. You can use this flag multiple times to set values for multiple variables

  ```sh
  terraform apply -var "region=us-west-2" -var "instance_type=t2.micro"
  ```

- `-var-file` flag: Use this flag to specify a variable file that contains values for multiple variables. You can create a variable file in JSON or HCL format and pass it using the `-var-file` flag. 
  ```sh
  terraform apply -var-file="variables.tfvars"
  ```

- `var-json` flag: This flag allows you to specify variable values in JSON format. You provide a JSON object with variable names and their values
  ```sh
  terraform apply -var-json='{"region":"us-west-2", "instance_type":"t2.micro"}'
  ```


### terraform.tfvars

`terraform.tfvars` is a default filename recognized by Terraform for storing variable values in HashiCorp Configuration Language (HCL) format. When you run Terraform commands like `terraform apply` or `terraform plan`, Terraform automatically loads variable values from this file if it exists in the same directory as your Terraform configuration files.

If you have defined variable values in both `terraform.tfvars` and in the Terraform configuration files (e.g., in `variables.tf` or in the configuration block), the values from `terraform.tfvars` will override the values in the configuration files.

### auto.tfvars

`auto.tfvar` is another filename recognized by Terraform for storing variable values in HashiCorp Configuration Language (HCL) format, similar to `terraform.tfvars`. However, there is one key difference: `auto.tfvars` is automatically loaded by Terraform without the need for specifying it on the command line.

The difference between `terraform.tfvars` and `auto.tfvars` is that with `terraform.tfvars` you have explicit control over when to load the values by specifying the filename as a command-line argument, this can be useful when you want to switch between different sets of variable values. With `auto.tfvars` the values are automatically loaded, which can be convenient, but it may lead to unexpected behavior if you have multiple Terraform configurations or shared modules.

### Order of Terraform Variables

In Terraform, variable precedence determines which value a variable will take when it's defined in multiple places. Understanding variable precedence is crucial for managing Terraform configurations effectively. Here's a general order of precedence for variables:

1. **Environment Variables**: set in your shell environment take the highest precedence. Terraform allows you to define variables by prefixing their names with TF_VAR_. For example, if you set an environment variable like TF_VAR_instance_type, it will override any other value for the instance_type variable.
2. **CLI Flags**: Values specified using command-line flags like -var or -var-file when running Terraform commands take precedence over environment variables.
3. **Variable Files**: Values specified in variable files (e.g., `terraform.tfvars`, `auto.tfvars`, or custom `.tfvars files`) take precedence over environment variables and command-line flags.
4. **Default values in Configuration**: Variables may have default values defined within the Terraform configuration itself. If no other value is provided, the default value will be used.
5. **Module Input Variables**: When using Terraform modules, the input variables you pass to a module during module instantiation take precedence over any other values.
6. **Terraform Cloud or Remote State BAckends**: When using Terraform Cloud or remote state backends, variable values can be set or managed remotely, which can take precedence over local values.

## Configuration Drift - What to do

Losing your Terraform state file can be problematic because it contains critical information about the infrastructure resources managed by Terraform. Losing the state file can make it difficult to update or destroy resources and can lead to inconsistencies between your infrastructure and Terraform's understanding of it.

If for any reason you close your workspace environment before run `terraform destroy` you will lose your statefile. Then you will have to delete all your cloud infrastructure manually.

Another way is to use the command `terraform import` but it could not work for all cloud resources, you have to verify the documentation of every Terraform provider you use to see if they support the import command.

### `terraform import`

First, you need to identify the existing resource you want to import into Terraform. You'll need to know the resource's type and its unique identifier (usually an ID or ARN). Then you can run the following command:

```sh
terraform import aws_s3_bucket.bucket bucket-name
```

Before running `terraform import` you need to run `terraform init` to have all the terraform plugins needed (see picture below)

![image](https://github.com/cristobalgrau/terraform-beginner-bootcamp-2023/assets/119089907/6c144703-4e1d-4570-a1d6-60ad64f7ab35)

![image](https://github.com/cristobalgrau/terraform-beginner-bootcamp-2023/assets/119089907/b43dc80b-8c98-40c7-a112-a0b296484c63)

This will bring our statefile back, but it didn't import all, and in our case didn't bring the random provider. But if we bring back "random provider" then it will create a new bucket name instead of using our last one that keeps open after we close the workspace without destroy. So, the best way to keep our consistency is to stop using Random providers and fix a bucket_name in our variables.

We had to perform the following tasks:

- Remove random from `providers.tf`.

  ![image](https://github.com/cristobalgrau/terraform-beginner-bootcamp-2023/assets/119089907/3de0d2ea-024f-4877-9c6f-305139b6f4e2)

- Remove random from `main.tf`

  ![image](https://github.com/cristobalgrau/terraform-beginner-bootcamp-2023/assets/119089907/e9145d1f-ed6a-4071-882c-9ba38f6adc37)
  
- Define the variable `bucket_name` in `variable.tf`

  ![image](https://github.com/cristobalgrau/terraform-beginner-bootcamp-2023/assets/119089907/d0106268-ef8d-44e8-bdf0-aae612477ac7)

- create the variable (bucket_name) in `terraform.tfvars`

  ![image](https://github.com/cristobalgrau/terraform-beginner-bootcamp-2023/assets/119089907/2f12ea6d-b500-41c4-a6db-eb754cc0abb0)

- Modify `outputs.tf` to remove the call to random

  ![image](https://github.com/cristobalgrau/terraform-beginner-bootcamp-2023/assets/119089907/3e43b957-fcd0-4e58-9f24-ca951f807572)

To verify your procedure is going well, you can be running `terraform plan` and see what it will do if you apply.

**Here is the documentation used:**

- [Terraform Import](https://developer.hashicorp.com/terraform/cli/import)
- [AWS S3 Bucket Import](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket#import)

### Terraform refresh

Is a command used to update the Terraform state file (`terraform.tfstate`) with the real-world state of the infrastructure resources managed by Terraform. This command does not make any changes to the infrastructure itself; instead, it queries the current state of the resources and updates the state file with the latest information.

This is useful when changes are made to the infrastructure outside of Terraform (e.g., manually through the cloud provider's console or CLI), and you want to ensure that your Terraform state is up to date with those changes.

The command `terraform refresh` is deprecated, instead is better use:

```terraform
terraform apply -refresh-only

```

This alternative command will present an interactive prompt with the opportunity to review the changes detected before committing them to the state.

## Terraform Modules

Terraform modules are a fundamental concept in Terraform that allows you to encapsulate and organize your infrastructure code into reusable and shareable components. Modules enable you to create custom abstractions and define infrastructure resources and their configurations in a modular and consistent way.

It is recommended to place modules in a `modules` directory when locally developing modules 

### Passing Input Variables to a Module

We can pass input variables to our module every time we call it.

```tf
module "terrahouse_aws" {
  source = "./modules/terrahouse_aws"
  user_uuid = var.user_uuid
  bucket_name = var.bucket_name
}
```

The module has to declare the terraform variables in its own `variables.tf`

```terraform
variable "user_uuid" {
  type    = string
  default = "default_value1"
}

variable "bucket_name" {
  type    = string
  default = "default_value2"
}
```

### Modules source

In Terraform, the **module block** allows you to use a module in your configuration. The **source** argument within the **module** block specifies where the module is located. The **source** argument can point to various sources, depending on where the module is defined or hosted.

Here are the common ways to specify the source for a module:

1. **Local Path**

You can specify a local path to a directory containing the module's configuration files. This is useful during development or when the module is part of the same codebase.

```terraform
module "example" {
  source = "./path/to/module"
}

```

1. **GitHub Repository**
you can use the short syntax by specifying the GitHub username, repository name, and the module path within the repository. Terraform will use the latest release of the module.

```terraform
module "example" {
  source = "github.com/your-username/your-module-repo/module-path"
}
```

1. Terraform Registry
You can use the registry as the source. Specify the full namespace and module name.

```terraform
module "example" {
  source = "namespace/module-name/registry"
}
```

[Modules Sources](https://developer.hashicorp.com/terraform/language/modules/sources)


### Refactoring the code into modules

To refactor our actual terraform structure into a module, we had to move all the infrastructure code to the `.tf` files created inside the module folder and just leave the needed one in our root just to be able to call the module and receive output.

![image](https://github.com/cristobalgrau/terraform-beginner-bootcamp-2023/assets/119089907/2bdf1299-39c2-4d79-b3f6-c002d0faf5dc)

![image](https://github.com/cristobalgrau/terraform-beginner-bootcamp-2023/assets/119089907/94db6f58-e1e3-4dda-ae9f-4bcbdc8f67ec)

![image](https://github.com/cristobalgrau/terraform-beginner-bootcamp-2023/assets/119089907/f045fc64-385e-4ecd-a395-44172a3cb20a)





