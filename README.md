# Configuration Management
My configuration management repository used for testing configuration management tools.

## Contents

- [Ansible](#ansible)
  - [Uses For Ansible](#uses-for-ansible)
  - [Ansible Quirks](#ansible-quirks)

## Ansible

Ansible is a configuration management software, allowing you to specify tasks that you want to run on multiple servers, and uses the YAML syntax.

Ansible uses an idempotent management method, in which resources converge to the specified code upon an ansible run. This is considered in place configuration management, as it executes on existing systems and instances.

### Uses For Ansible

#### Infrastructure Management

Ansible can automate setting up and tearing down of environments. Ansible all you to specify the desired structure of an environment within code, the engine will automatically create it.

#### OS Configuration

If you need to configure the operating system of a virtual machine, Ansible allows you to specify the particular state that services and settings should be in.

#### Application Deployment

In a playbook, you can specify the individual tasks required to deploy an application.   Ansible will execute them, and will let you know the status of each task. 

#### Compliance Checks

You can use ansible to create tasks which check for the desired state of a system service, or firewall rule. 

Because Ansible is idempotent, you can run these tasks at any time, and report on the changes.

### Ansible Quirks

Ansible is stateless, meaning that it doesn't require an agent to be installed on a host. However it does require:
- SSH Access.
- Python installed on Linux hosts.
- PowerShell 3 on Windows hosts.

Ansible playbooks are written in YAML syntax, whereas Chef and Puppet use a Ruby DSL.