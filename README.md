# Configuration Management
My configuration management repository used for testing configuration management tools.

## Contents

- [Ansible](#ansible)
  - [Uses For Ansible](#uses-for-ansible)
  - [Ansible Quirks](#ansible-quirks)
  - [Ansible Concepts](#ansible-concepts)
  - [Installing Ansible On Linux](#installing-ansible-on-linux)
  - [Configuring Ansible on a Windows Server](#configuring-a-windows-server-for-ansible-connectivity)

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

https://docs.ansible.com/ansible/latest/user_guide/windows_setup.html


