# Terraform Beginner Bootcamp 2023 - Week 2

## Working with Ruby

### Bundler

Bundler is a package manager for Ruby. Bundler is used to manage gem dependencies for Ruby projects, ensuring that the correct gems (Ruby libraries) are installed and loaded when running a Ruby application.

It is the primary way to install ruby packages (known as gems) for Ruby.

Here's an overview of what Bundler does and why it's important in the Ruby ecosystem:

- **Dependency Management**: Bundler helps Ruby developers manage the dependencies (gems) required by their projects. Each Ruby project can have its own set of gem dependencies, and Bundler ensures that the correct gem versions are installed and used for that project.

- **Gemfile**: Bundler uses a file called a `gemfile` to specify the project's gem dependencies and their versions. Developers list the gems and their desired versions in the `gemfile`, and Bundler takes care of installing and loading them.

- **Isolation**: Bundler creates a separate gem environment for each project. This means that gems required by one project do not interfere with gems required by another project, preventing version conflicts and ensuring project-specific gem versions are used.

- **Lockfile**: When you run bundle install in a Ruby project directory, Bundler generates a `gemfile.lock` file. This file records the exact versions of each gem and its dependencies that were installed. It ensures that the same gem versions are used when the project is deployed to different environments or by different developers.

- **Automatic Loading**: Bundler integrates with Ruby's require mechanism, so you don't need to manually require gems in your code. Bundler takes care of loading the appropriate gems based on your `gemfile` and `gemfile.lock`.

#### Install Gems

You need to create a `gemfile` and define your gems in that file.

```rb
source "https://rubygems.org"

gem 'sinatra'
gem 'rake'
gem 'pry'
gem 'puma'
gem 'activerecord'
```

Then you need to run the `bundle install` command

This will install the gems on the system globally (unlike nodejs which install packages in place in a folder called node_modules)

A `gemfile.lock` will be created to lock down the gem versions used in this project.

#### Executing ruby scripts in the context of bundler

We have to use `bundle exec` to tell future ruby scripts to use the gems we installed. This is the way we set the context.

### Sinatra

Sinatra is a lightweight and open-source web application framework written in the Ruby programming language. It is often referred to as a micro-framework because it provides the basic tools and features needed to build web applications but doesn't include the extensive set of features and abstractions found in larger web frameworks like Ruby on Rails.

It's great for mock or development servers or for very simple projects.

You can create a web-server in a single file.

https://sinatrarb.com/

## Terratowns Mock Server

It was clone the mock server from [Andrew Brown's](https://github.com/omenking) GitHub. The reference git repository is the following:

https://github.com/omenking/terraform-beginner-bootcamp-2023/tree/02fa4eb7652027cea071b18d55610e587bb883fb/terratowns_mock_server

### Running the web server

We can run the web server by executing the following commands:

```rb
bundle install
bundle exec ruby server.rb
```

All of the code for our server is stored in the `server.rb` file.

### Create the API endpoints in the Web-server

We created the API endpoint needed for our mock web-server (CRUD). 

CRUD is an acronym that stands for Create, Read, Update, and Delete. It represents the four basic operations that can be performed on data in most database systems and forms the foundation of many web applications and software systems. 

CRUD operations are fundamental to many software systems, especially those that involve data storage and user interaction. In web development, for instance, they correspond to the standard HTTP methods:

- Create: HTTP POST
- Read: HTTP GET
- Update: HTTP PUT or PATCH
- Delete: HTTP DELETE

CRUD operations are not limited to databases alone and can be applied to various data storage and manipulation scenarios, including file systems, APIs, and more. They provide a standardized way to interact with and manage data in software applications, making them a fundamental concept in programming and software development.

![image](https://github.com/cristobalgrau/terraform-beginner-bootcamp-2023/assets/119089907/a7d5b9a7-0c2d-4824-bd69-23156f0ecf44)

## Implementing a Custom Provider

### 1. Creating the app coding
It was created the code for all the API endpoints that our app needs. In this case was made in `golang` language. See the original code from [Andrew Brown's](https://github.com/omenking/terraform-beginner-bootcamp-2023/blob/02fa4eb7652027cea071b18d55610e587bb883fb/terraform-provider-terratowns/main.go#L4) GitHub.

### 2. Configure Terraform for Local Custom Providers
You need to specify how Terraform will install the custom local provider. For this it was created the file `terraformrc` who will configure Terraform to look at and store local providers' complements and exclude the direct installation of local providers, which means that Terraform only will use a filesystem mirror to manage the complements

```bs
provider_installation {
  filesystem_mirror {
    path = "/home/gitpod/.terraform.d/plugins"
    include = ["local.providers/*/*"]
  } 
  direct {
   exclude = ["local.providers/*/*"] 
  }
}
```

### 3. Compile the local Custom Provider
Created a Bash script used to build and distribute a local Terraform plugin to two different locations, one for the x86_64 architecture and another for the Linux platform with amd64 architecture. And also to perform some cleanup operations before compiling and copying files.

The file was named `build_provider` and was chmod as an executable file:

```bs
#! /usr/bin/bash

PLUGIN_DIR="/home/gitpod/.terraform.d/plugins/local.providers/local/terratowns/1.0.0/"
PLUGIN_NAME="terraform-provider-terratowns_v1.0.0"

# https://servian.dev/terraform-local-providers-and-registry-mirror-configuration-b963117dfffa
cd $PROJECT_ROOT/terraform-provider-terratowns
cp $PROJECT_ROOT/terraformrc /home/gitpod/.terraformrc
rm -rf /home/gitpod/.terraform.d/plugins
rm -rf $PROJECT_ROOT/.terraform
rm -rf $PROJECT_ROOT/.terraform.lock.hcl
go build -o $PLUGIN_NAME
mkdir -p $PLUGIN_DIR/x86_64/
mkdir -p $PLUGIN_DIR/linux_amd64/
cp $PLUGIN_NAME $PLUGIN_DIR/x86_64
cp $PLUGIN_NAME $PLUGIN_DIR/linux_amd64
```




