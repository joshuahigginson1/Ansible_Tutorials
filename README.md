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

WinRM requires port 5986 to be open on our windows firewall.

The final step is to connect to our windows server, and run the following powershell script.

https://github.com/ansible/ansible/blob/devel/examples/scripts/ConfigureRemotingForAnsible.ps1

Start a powershell terminal as an admin and drag the ps1 file into it.

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
