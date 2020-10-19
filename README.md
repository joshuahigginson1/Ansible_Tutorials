# Configuration Management
My configuration management repository used for testing configuration management tools.

## Contents

- [Ansible](#ansible)
  - [Uses For Ansible](#uses-for-ansible)
  - [Ansible Quirks](#ansible-quirks)
  - [Ansible Concepts](#ansible-concepts)
  - [Installing Ansible On Linux](#installing-ansible-on-linux)
  - [Configuring Ansible on a Windows Server](#configuring-a-windows-server-for-ansible-connectivity)
  - [Inventory](#inventory)
  - [Host Patterns](#host-patterns)
  - [Modules](#modules)
  - [Handlers, Facts, Variables, and Templates](#handlers-facts-variables-and-templates)
  - [Roles](#roles)
  - [Errors](#errors)
- [Chef](#chef)
  - [Chef Architecture](#high-level-architecture)
  - [Chef Development Kit](#the-chef-development-kit)
  - [Anatomy Of A Cookbook](#the-anatomy-of-a-cookbook)




## Ansible

Ansible is a configuration management software, allowing you to specify tasks that you want to run on multiple servers, and uses the YAML syntax.

Ansible uses an **idempotent** management method, in which resources converge to the specified code upon an ansible run. This is considered **in place** configuration management, as it executes on existing systems and instances.

### Uses For Ansible

#### Infrastructure Management

Ansible can automate setting up and tearing down of environments. Ansible all you to specify the desired structure of an environment within code, the engine will automatically create it.

#### OS Configuration

If you need to configure the operating system of a virtual machine, Ansible allows you to specify the particular state that services and settings should be in.

#### Application Deployment

In a playbook, you can specify the individual tasks required to deploy an application. 

Ansible will execute them, and will let you know the status of each task. 

#### Compliance Checks

You can use ansible to create tasks which check for the desired state of a system service, or firewall rule. 

Because Ansible is idempotent, you can run these tasks at any time, and report on the changes.

### Ansible Quirks

Ansible is stateless, meaning that it doesn't require an agent to be installed on a host. However it does require:
- SSH Access.
- Python installed on Linux hosts.
- PowerShell 3 on Windows hosts.

Ansible playbooks are written in YAML syntax, whereas Chef and Puppet use a Ruby DSL.

## Ansible Concepts

There are two ways to run tasks in Ansible.

### Ad-Hoc Commands

Ansible commands use the **ansible executable** in order to run code on host machines.

The idea behind ad hoc commands is that you can run 'one-off commands'.

The **-m** flag tells ansible which module to run.

The **-a** flag specifies a list of key value arguments.

_Ping a server_

`ansible <servergroup> -m ping`

_Shut down a server_

`ansible <servergroup> -m command -a "/sbin/shutdown"`

_Restart the apache2 systemctl service_

`ansible <servergroup> -m service -a "name=apache2 state=restarted"`

### Playbooks

**Playbooks** give you the ability to run multiple tasks, in a YAML file containing zero or more **plays**.

Playbooks allow you to create complex configurations, and execute them on multiple servers at the same time.

#### Playbook Common Mistakes

If you are using a string for the value of a key, it must be wrapped in double quotations, if that string has a colon in it.

key: "Duplicate: A Clone's Tale"

If a variable for a value is the start of the value in a key-value pair, you must wrap it in quotes, as YAML will otherwise treat this as the start of a dictionary.

key: "{{ variable }}"


#### Modules
**Modules** are "wrappers" around code, designed for particular purpose.

For example, the ping module allows you to ping a server. The git module allows you to interact with a git repository.

There are hundreds of different modules within Ansible.

https://docs.ansible.com/ansible/2.8/modules/list_of_all_modules.html

#### Tasks

When you call modules inside of Ansible, you call them inside of a task. 

Tasks consist of a module, along with metadata, which tells Ansible exactly how you want that module to be run.

#### Plays

A **play** is a list of ansible **tasks** to be run, the **hosts** in which the task should be run on, as well as any additional variables and settings.

**Playbooks** a set of **multiple plays**, and they are the most common way to interact with Ansible.

## Installing Ansible on Linux

https://docs.ansible.com/ansible/2.8/installation_guide/intro_installation.html

A **command and control machine** is the central host on which you are running Ansible.

## Configuring a Windows Server for Ansible Connectivity

First, we must install a python module with with pip called "pywinrm".

    pip3 install pywinrm

We need to have a number of different ansible variables configured for each host.

https://docs.ansible.com/ansible/latest/user_guide/windows_winrm.html

    ansible_user=Administrator
    ansible_password=<password>
    ansible_port=5986
    ansible_connection=winrm
    ansible_winrm_transport=basic
    ansible_winrm_server_cert_validation=ignore

WinRM requires port 5986 to be open on our windows firewall.

The final step is to connect to our windows server, and run the following powershell script.

https://github.com/ansible/ansible/blob/devel/examples/scripts/ConfigureRemotingForAnsible.ps1

Start a powershell terminal as an admin and drag the ps1 file into it.

You can ignore the winrm certificate signing process entirely using the following variable:

    ansible_winrm_server_cert_validation=ignore

Details for debugging your connection to windows can be found here.

https://docs.ansible.com/ansible/latest/user_guide/windows_setup.html

## Inventory

https://docs.ansible.com/ansible/latest/user_guide/intro_inventory.html

Because it is agentless, Ansible needs to explicitly know the location and identity of servers in which to manage.

Ansible keeps this information in an **inventory file**.

Inventories are most commonly laid out in **INI** or **YAML** format.

YAML files take longer to write, but are better suited for larger inventories with multiple subgroups.

Within this inventory file, you have the ability to designate your node machines into groups.

A group allows you to have a set of servers for a specific role.

There are two default groups. **All** and **ungrouped**. Every host will **always** belong to at least two groups.

    # Inventory INI File
    mail.example.com

    [webservers]  <-- Group
    foo.example.com
    bar.example.com`

    [dbservers]  <-- Group
    one.example.com
    two.example.com
    three.example.com

More on nested groups:  https://www.programmersought.com/article/5068620909/

You can easily assign variables to a single host in line, for use later in a playbook.

    [atlanta]
    host1 http_port=80 maxRequestsPerChild=808
    host2 http_port=303 maxRequestsPerChild=909

### Variable Files

It is possible to store group variables in this inventory file, set with the :vars suffix. 

However, it is better practice to store the host and group specific variables in their own files.

Host and group variable files must use YAML syntax. 

Ansible loads these host and group variable files by searching paths **relative** to your inventory file.
If your inventory file at /ansible/hosts contains a host named ‘foosball’ that belongs to two groups, ‘raleigh’ and ‘webservers’, that host will use variables in YAML files at the following locations:

    /ansible/group_vars/raleigh
    /ansible/group_vars/webservers
    /ansible/host_vars/foosball

The name of the variable file should always match the host or group name.

### Connecting to Remote Hosts

Ansible has a number of preferred ways in order to connect to a server.

The default connection method for Linux is SSH.

The default connection method for Windows is WinRM.

Ansible allows per host and per group connection settings.

If all hosts share the same connection settings, you can use the main ansible.cfg file in order to speed up this process.

Within the ansible.cfg file, find the "private_key_file" setting, and alter the path to  a .pem file.

### Dynamic Inventory

Dynamic Inventory allows you to use an executable to automatically get your inventory from another location. 

This could be an API for a cloud platform, an external database, or anywhere else.

There are a number of dynamic inventory scripts that have been created for different cloud providers on the Ansible website. 

_AWS_
https://aws.amazon.com/blogs/apn/getting-started-with-ansible-and-dynamic-amazon-ec2-inventory-management/

_Azure_
https://docs.microsoft.com/en-us/azure/developer/ansible/dynamic-inventory-configure?tabs=ansible

_GCP_
https://medium.com/@Temikus/ansible-gcp-dynamic-inventory-2-0-7f3531b28434

The alternative method for accessing dynamic inventory is through the use of an **inventory plugin**. 

https://docs.ansible.com/ansible/latest/plugins/inventory.html#inventory-plugins

https://medium.com/faun/learning-the-ansible-aws-ec2-dynamic-inventory-plugin-59dd6a929c7f

## Host Patterns

Ansible has a very flexible way of addressing different hosts, through pattern matching syntax.

    test1:test2  # OR pattern, the hest exists in test1 or test2.
    
    all  # ALL hosts.
    *  # ALL hosts.
    
    test1:!test2  # NOT pattern, the host exists in test 1 and not test2.
    
    test1:&test2  # AND pattern, the host exists in both test1 and test2.
    
    ~(web|db).*\.test\.com  # REGEX pattern, the host is web.test.com or db.test.com.

## Modules

Modules in Ansible are an individual unit of work. 

They represent things such as creating files, virtual machines, editing firewalls. Just about everything you could need.

Modules accept arguments as key-value pairs.

If you need something custom, Ansible allows custom modules to be written with any language, capable of writing JSON to standard output.

Ansible contains a program called test-module which allows you to test modules that you create on a local machine.

You can write modules in any language you want, but files can get quite complicated, quite quickly.

When you are ready to use these modules, you can copy them over to any of the directories mentioned in the $ANSIBLE_LIBRARIES environment variable.

If you add a 'library' directory in the same directory as your top level playbook, then your modules will also be included.



## Handlers, Facts, Variables, and Templates

### Loops

In a playbook, ansible lets you loop over a list of items using the 'with_items' property.

    tasks:
    - name: Install Packages
      apt:
        name: "{{ item }}"
        state: present
        update_cache: true

      with_items:
        - apache2
        - mysql-server
        - mysql-common
        - mysql-client
        - libapache2-mod-wsgi 

### Cleaning up duplicated tasks:

A handler is a task that is called whenever it has been notified of a change. For example, you would always want to restart Apache2 whenever the config file changes.

Handlers are only ever called when they are needed. they are defined as so:

    handlers:
      - name: restart apache
        service:
          - name: apache2
            state: restarted

In order to call this handler, we also have to add a notify tag to any task in which we want our handler to run afterwards.

    - name: Copy Apache Configuration File
      copy:
        src: "apache.conf:
        dest: /etc/apache2/sites-available/000-default.conf
      notify: restart apache
  
### Cleaning up Hardcoded Strings:

Variables allow for modular code and are very flexible You can set default variables within your code, but override it at the command line.  Ansible can fetch variables from different locations. Because of this, it has a very specific order of precedence. 

You can set variables in the 'vars' section of your play. 

    vars:
      app_download_dest: a
      app_dest: b

You declare variables using Jinja2 style curly braces. 

    key: "{{ variable }}"
    
### Dynamically Processing files with Jinja2

Ansible allows you to use Jinja2 templating syntax in order to apply changes to a file with pre-processing. This is done using the 'template' module.

### Facts

Ansible uses something called 'facts' to provide you with information about the servers that you are managing. They are obtained automatically using the 'setup' module.

You can run this module as an 'ad-hoc' command, and see all of the extra variables in which ansible provides for use in your playbooks. It makes it really easy to get information about your hosts dynamically. 

### Conditionals

Ansible allows you to use the 'when' statement in order to conditionally run a task. This is most commonly used with ansible facts.

### Saving Module Output to Variables

You can save the output of a module to an ansible variable using the 'register' keyword.

    - name: Ping
      win_ping:
      register: winping

    - name: Print Ping
      debug: var=winping
      
## Roles

Roles are a key feature for making re-usable code in Ansible.

They allow you to bundle common functionality into a single role. They follow a specific folder structure.

Ansible Galaxy helps with creating and sharing roles.

To create a role structure, you can use the ansible-galaxy command.

    ansible-galaxy init <name_of_role>
    
When ansible looks for specific files in a role, then they expect to see the default names provided by ansible-galaxy.

## Errors

When a task in Ansible fails, the error fails. 

Sometimes an error isn't all that important. You can use the 'ignore_errors' property to ignore any errors. 

We use a **'failed_when'** statement in conjunction with a 'register' statement.

First, we have to register the output of our module that is expecting a failure.

We then use the 'failed_when' statement to declare our failure. Any Jinja2 statement will work.

### Debugging

The debug module was a module first created by the ansible community in an effort to aid with debugging playbooks. 

## Chef

Chef is a better way to manage all of your servers at the same time. It is a way to configure servers consistently whilst preventing configuration drift.

Chef is both the name of the configuration management software, and the name of the company that created it. It used to be called ox-code.
 
Chef has several products that revolve around the configuration management problem; Chef, Inspec, and habitat.

Chef is a platform that allows you to automate the creation, configuration, and management of your infrastructure.

Chef can also communicate with cloud providers such as AWS, Google, and Microsoft Azure using Infrastructure as Code.

Companies that use Chef include: Gannett, Facebook, Intuit, Riot Games.

### High Level Architecture

There are three core components of Chef.

A **workstation** is a computer that the chef development kit is installed. It is where developers write and test their code which chef uses to manage servers.

Chef uses a client server architecture. There are two components, a server, and clients.

The **chef server** is a central hub where all of your automation code lives, and is responsible for knowing all about the **nodes** in which it manages.

Chef is capable of managing all different types of devices, not just servers.
 
Once code is on the Chef server, you can instruct a node to download this code from the Chef server and execute it.
￼
### The Chef Development Kit

The development kit has everything required to develop with chef. 

The **chef executable** is used to:
- Generate code templates.
- Run system commands.
- Install Ruby gems into the development kit environment. (Ruby's Package Manager.

The **chef-client** is the driving force behind nodes. It is an executable that can also be run as a service. It is responsible for:
- Registering and authenticating a node.
- Synchronising code from the Chef server to the node.
- Making sure that the node is configured correctly.

**Ohai** is a tool for gathering information about the node it is running on. It is automatically run by the chef-client, and the information it gathers is available to a developer in code.

Ohai attributes are saved on the Chef Server, which allows you to use them in order to search for nodes based on those values. It collects information such as:
- Platform Details.
- Network, Memory, and CPU usage.
- Host Names and FQDN.
- Virtualisation Data.
- Cloud Provider Details.

**Knife** is a tool used to interact with the chef server in order to do things like uploading code from a workstation, setting global variables, and bootstrap the chef-client onto nodes. It can even provision cloud infrastructure. 

**Kitchen** is used for testing the Chef code in which you develop. It gives you the power to run code against multiple platforms.

**Berkshelf** is a dependency management tool, that allows you to download code which is shared with the community, from the Chef Supermarket.

#### The Chef Server

The Chef Server acts as a central hub that our nodes look to for the latest configuration data. It is a restful API that allows authenticated users to interact with different endpoints.

For the most part, we don't interact with the Chef API directly. Instead, we use the tools built around the API.

**Chef Web Management UI** - Interact with the API via a web server.

**Chef-client** - This is how nodes interact with the server. Nodes grab what ever they need from the server, and then perform any configuration on the node directly, in order to reduce the amount of work in which our server needs to perform at any one time. 

**Knife** - Used to interact with the web server. 

#### Nodes

A node is a generic name for devices running the chef-client software. This could be a physical device, a virtual server, a network device, or a container. 

The **chef-client** is responsible for making sure that the node is authenticated and registered with the chef server, using RSA public key pairs.

Once a node is registered with the chef server, then it can access the server's data and configuration information. 


#### Chef Repo

A Chef repo is a directory in which your cookbook resides. It also has space for things other than cookbooks, such as environments, data bags, and roles.

The only thing required to create a chef repo is that the directories match what is expected. 

You could create the chef repo manually, however the easy way is to use a Chef command.

Your Chef repo should be under version-control. 

### The Anatomy of a Cookbook

The code to automate our configuration management commands in Chef resides in something called a cookbook. It is a package for your automation code.  Recipes

Recipes contain the configuration code and is written in Ruby. 

You can create dependent recipes that allow you to expand on an existing recipe from the Chef Supermarket.

The code written inside of a recipe is based on resources, which represent the **desired configuration for a specific aspect of a node**.

    # Installing a package
    package 'nginx' do
      action :install
    end

    # Start a service
    service 'nginx' do
      action [:enable, :start]
    end

All a user needs to do is set the desired state, and chef will be able to move from the current state, to the desired state.

### Custom Resources

As of Chef version 12.5, Chef allows engineers to create custom resources for their application. 

### Definitions

Definitions are an older implementation of custom resources, and are akin to a compile-time macro across multiple recipes.

 There are a few properties that a definition does not support, such as 'notifies', 'subscribes', 'not_if', and 'only_if'.

### Attributes

**Attributes** are details about a node, related to its state. Think of them as variables.

Some attributes are set automatically by Ohai, such as IP Address, Host Name, Host OS, and Host Platform.

Some attributes can be set by the developer.

There are 6 types of attribute, and they have different presence. Default and Automatic are the most common types.

They can be sourced from:

- Nodes (Fetched with Ohai when chef-client runs)
- Attribute Files
- Recipes
- Environments
- Roles

    # Attribute File
    default['database']['username'] = 'database_user'
    default['database']['dbname'] = 'my_database'

**Files** in Chef are just files in which you would like to deploy to nodes. You can do this with the 'cookbook_file' resource.

    # Cookbook File
    cookbook_file '/var/www/html/index.html' do
      source 'index.html.erb
      owner 'www-data'
      group 'www-data'
      action :create
    end

**Templates** are similar to files, except they allow programming logic within them. They reside in the templates subdirectory of the cookbook.

They use ERB templates, based on the **Erubis** template engine. 

It is best practice to use the ".erb" extension for files.

**Libraries** are ruby files that are used to add new functionality to your recipes. Anything that you can do in ruby can be added to a library.

The **metadata.rb** file contains information related to the cookbook itself. It contains things like the cookbook name, description, and the version of the cookbook, which is important to the Chef server. 

It also stores any gems to be installed, the allowed version of the chef-client, and a list of any dependent cookbooks.
