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


