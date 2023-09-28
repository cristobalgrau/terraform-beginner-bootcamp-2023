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

## Terraform and Imput Variables

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






