# 🚀 Terraform + Ansible + Github Actions: AWS EC2 Adventure

In this project, I am simply using **Terraform** to build an AWS EC2 instance and then dressing it up with **Ansible** all while running this through a **CI/CD** pipeline using **GitHub** actions.  

The main reason for this project was to learn how to connect to an EC2 machine at start up with Ansible and install an `httpd` server.  

Sounds simple, right?  
I thought the same... until I ran into all sorts of problems. 😅  
---

## 💡 Why I Did This
- To connect Terraform + Ansible in a real-world way.  
- To learn how to provision an EC2 instance and then configure it automatically.  
- To practice solving the *unexpected* issues that always come up when working with infrastructure.  
- To have a reusable workflow that I can apply at work.  

Despite the many failed attempts, I figured it out ✅  
Now I can put this in my bag of experience **and** actually use it in production scenarios.  

---

## 📋 What This Project Covers
1. Building an **EC2 instance** with Terraform.  
2. Using Terraform outputs (like IPs, SSH keys) to feed into Ansible.  
3. Running an **Ansible playbook** to install and start `httpd`.  
4. Lessons learned the hard way (and documented so you don’t suffer like I did).  

---

## ⚙️ Tech Stack
- [Terraform](https://www.terraform.io/) → For infrastructure provisioning.  
- [Ansible](https://www.ansible.com/) → For configuration management.  
- [AWS](https://aws.amazon.com/) → Cloud provider of choice.  

---

## 🗂️ Project Structure
```bash
.
├── .github/
│   ├── workflows/
|      ├── deploy.yml
├── terraform/              # Terraform configuration files
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
├── ansible/                # Ansible playbooks
│   ├── site.yml
|   ├── ansible.cfg
│   └── inventory
└── README.md               # You're reading this 😎
```
 
# 🧰 Ansible (first things first)

This project is Terraform → EC2 → Ansible. Since Ansible is where “it actually works (or breaks)”, we’ll start here.

ansible/
├── ansible.cfg
├── inventory # static example (INI or YAML)
└── site.yml # main playbook

## Why this structure?

- **`ansible.cfg`** → keeps CLI commands short and consistent (inventory path, SSH key, roles path, etc.).
- **`inventory`** → defines “who” to manage (from Terraform output or a static host/IP).
- **`site.yml`** → defines “what” to do (install & start `httpd`, plus any bootstrap you need).

As this grows, you can add:

ansible/
├── group_vars/ # vars shared by group (e.g., web)
├── host_vars/ # vars for single host
└── roles/ # reusable roles (apache/, users/, etc.)

# ansible.cfg
```bash
---

## `ansible.cfg` (opinionated but beginner-friendly)

[defaults]
host_key_checking = False     # ok for labs! Enable in production
retry_files_enabled = False
inventory = inventory
roles_path = roles
collections_paths = collections

# Optional: if you add roles later
# roles_path = ./roles
```

# 🤷🏽‍♂️Why these choices?

host_key_checking = False stops first-contact prompts (nice for ephemeral EC2). Turn it back on in real environments.

interpreter_python = auto_silent helps Ansible find Python on various distros.

inventory = Path of the inventory file in your current project directory

roles_path = Path of the roles directory in your current project directory

collections_paths = Path of the roles directory in your current project directory

inventory
Leave your inventory file empty.... Why Steph?
Normally, Ansible needs to know which hosts to manage (EC2 public IPs, hostnames, etc.), and you’d list those in the inventory file like this:

[web]
ec2-1-2-3-4.compute-1.amazonaws.com ansible_user=ec2-user

But in this project, the EC2 instance doesn't exist until Terraform builds it. That means you can't hardcode its IP/DNS in advance. Later in the project, you are going to have Terraform output the instance's public IP once it's created. Then you are going to plug that IP into Ansible when you run the playbook.

If you know anything about AWS though, when you stop an EC2 instance and start it back up, the public IP address changes. So keep that in mind! You'll have to change the ip address in your inventory file each time. OR, you can create an Elastic IP, which is like you leasing a static connection from AWS so you'll always have the same public ip address. Keyword though, "leasing". You are going to have to pay for that Elastic IP! Yikes! This is a simple project though so you won't need to lease anything. There are other ways to generate an inventory file using terraform collections, but I'm not doing it in this project. Ok, im done ranting! Moving along now...

# site.yml

```bash
- name: Configure Web Server
  hosts: all
  become: true
  tasks:
    - name: Install httpd
      ansible.builtin.yum:
        name: 
          - httpd
        state: present

    - name: Start and enable Apache service
      ansible.builtin.service:
        name: httpd
        state: started
        enabled: true

    - name: Create web page
      ansible.builtin.copy:
        content: "DevOps Journey is coming along!"
        dest: /var/www/html/index.html 

    - name: Add content to Message of the day file
      ansible.builtin.lineinfile:
        path: /etc/motd
        line: |
          ********************************************
          * Hello! Welcome to {{ ansible_hostname }}.*
          * Great job on completing this project.    *
          * You are slowly but surely becoming a     *
          * DevOps engineer!                         *
          ********************************************
```
This ansible file installs httpd, starts and enables the httpd service, creates an html file with a fun message, and finally, writes to the motd file so when you log into the ec2 instance, you'll be greeted with a success message.

# ☁️Terraform Setup — Building the Foundation
Now that our Ansible setup is ready, let’s move on to the Terraform side — the part that actually builds the EC2 instance in AWS.

Before Terraform can talk to AWS, we need two things:

The AWS CLI (so we can authenticate and test credentials).

The Terraform binary (to build infrastructure as code).

Let’s go step by step 👇

# 🧩 Step 1 — Install the AWS CLI
Terraform needs AWS credentials, and the easiest, most secure way to handle them is through the AWS CLI. I am using linux, so I googled "install awscli on linux" and came across this documentation >> [Install AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)

# 🔐 Step 2 — Configure Your AWS Credentials Securely

Instead of hardcoding credentials into Terraform files like I did at first 😬, store them safely using the AWS CLI. Run the following command:
```bash
aws configure
```
You'll be prompted for four values

```bash
AWS Access Key ID [None]: <Your Access Key>
AWS Secret Access Key [None]: <Your Secret Key>
Default region name [None]: us-east-1
Default output format [None]: json
```

This command stores your credentials in:

~/.aws/credentials → your keys

~/.aws/config → your default region and output format

Terraform automatically reads from these files — no extra steps needed!

💡 Pro tip: Your keys are stored locally for your user account only.
If you ever rotate them, just rerun aws configure.

# 🧱 Step 3 — Install Terraform
Now that AWS is set up, install terraform so you can start building infrastructure.

Download from the official Terraform site: [Install Terraform](https://developer.hashicorp.com/terraform/install)

Again, I'm using Linux so the commands to install terraform are below:

```bash
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
sudo yum -y install terraform
```

# ☁️ Step 4 — Time to Build!

Now you’re ready to:

1. Move into your Terraform directory

```bash
cd terraform
```

## main.tf

```bash
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}


resource "aws_security_group" "allow_ports" {
  name        = "allow_ports"
  description = "Allow TLS inbound traffic and all outbound traffic"
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.allow_ports.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = var.aws_ssh_port
  ip_protocol       = "tcp"
  to_port           = var.aws_ssh_port
}

resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.allow_ports.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = var.aws_http_port
  ip_protocol       = "tcp"
  to_port           = var.aws_http_port
}

resource "aws_vpc_security_group_egress_rule" "all_out" {
  security_group_id = aws_security_group.allow_ports.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_key_pair" "my_key" {
  key_name   = "deployer-key"
  public_key = file(var.public_key)
}

resource "aws_instance" "web" {
  ami                         = var.aws_ami # Amazon Linux 2
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.my_key.key_name
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.allow_ports.id]

  tags = {
    Name = "Terraform-Ansible-AmazonLinux"
  }
}
```
