# 🚀 Terraform + Ansible: AWS EC2 Adventure

In this project, I am simply using **Terraform** to build an AWS EC2 instance and then managing it with **Ansible**.  

The main reason for this project was to learn how to connect to an EC2 machine with Ansible and install an `httpd` server.  

Sounds simple, right?  
I thought the same... until I ran into all sorts of problems. 😅  

<insert image / meme here for extra fun>

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
├── terraform/              # Terraform configuration files
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
├── ansible/                # Ansible playbooks
│   ├── provision-configure.yml
│   └── inventory.ini
└── README.md               # You're reading this 😎
 