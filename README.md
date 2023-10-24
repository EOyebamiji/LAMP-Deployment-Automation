# AltSchool SOE: Cloud Engineering Second Semester Examination Project

## Automating The Provisioning and Deployment of a LAMP Stack Deployment on Two (2) Ubuntu-Based Server

## Project Objective

+ Automate the provisioning of two Ubuntu-based servers, named "Master" and "Slave", using Vagrant.
+ On the Master node, create a bash script to automate the deployment of a LAMP (Linux, Apache, MySQL, PHP) stack.
+ This script should clone a PHP application from GitHub, install all necessary packages, and configure Apache web server and MySQL. 
+ Ensure the bash script is reusable and readable.
+ Using an Ansible playbook:
    - Execute the bash script on the Slave node and verify that the PHP application is accessible through the VM's IP address (take screenshot of this as evidence)
    - Create a cron job to check the server's uptime every 12 am.


## Requirements for this project
- A strong internet connection
- Ubuntu-based host machine with Vagrant and VirtualBox installed.
- Basic knowledge of Vagrant, Bash scripting, Ansible, and LAMP stack components.
- A PHP (Laravel) application hosted on GitHub.
    - Official PHP Laravel GitHub Repository: https://github.com/laravel/laravel

## Prequisite Steps

1. Clone the repository 

Create a directory for your project and navigate to it in your terminal.

```bash
git clone git@github.com:EOyebamiji/AltSchoolSecondSemesterProject.git
```

2. After cloning the repository, run the following commands:

```bash
cd AltSchoolSecondSemesterProject
vagrant up
```

This will execute the configuration defined in the Vagrantfile. The [Vagrantfile](/Vagrantfile) is set up to deploy two Ubuntu-based servers, "Master" and "Slave." The "Master" is provisioned with an execution script that automates the installation of the LAMP Stack and its dependencies. The [Vagrantfile](/Vagrantfile) [executes](/execute.sh) the [master script](/master.sh) to achieve this.

3. Access the Master Node:

On successful execution of the Vagrantfile, you'll see a welcome message similar to the one shown below:

![Success](assets/Successful%20execution%20of%20the%20Vagrantfile%20Master%20Script.png)

- The Laravel Application has been successfully deployed and hosted on the Master Node, accessible via the IP Address set by the Vagrantfile.
    
![Confirmed Deployment](assets/Confirmed%20Deployment%20of%20the%20Laravel%20App%20on%20the%20Master%20Node.png)

4. Access the Master and Slave Nodes:

Confirm access to the Master and Slave Nodes by executing the following commands:

```bash
vagrant ssh master
vagrant ssh slave
```
The above commands will grant access to the Master and Slave Nodes, respectively. 

![Vag-Master](assets/Successful%20access%20to%20vagrant%20master.png)

![Vag-Slave](assets/Successful%20access%20to%20vagrant%20slave.png)
    
5.   SSH Key Setup:

To allow access to the Slave Node from the Master Node using Ansible, create an SSH key for the Master Node. On the Master Node, execute the following commands:

```bash
sudo su #This is to switch to the root user
cd ~
ssh-keygen #Press Enter to all questions
cat ~/.ssh/id_rsa.pub #This will display the generated ssh key
``` 

![SSH](assets/ssh-keygen%20master.png)

Next, open a new CLI (such as Git Bash) and SSH into the Slave Node:

```bash
vagrant ssh slave
```

Switch to the root user and save the generated SSH key from the Master Node:

```bash
sudo su
vim ~/.ssh/authorized_keys #This will open the authorized_keys for this node, save the copied ssh key into it and save
```
![ssh](assets/save%20ssh%20slave.png)

Test the connection from the Master Node to the Slave Node to ensure it's reachable via SSH:

```bash
ssh root@iP_Address
```
![ssh](assets/successful%20ssh%20to%20slave%20node.png)

6. Run Ansible Playbook:

To deploy the configuration of the Slave Node from the Master Node using Ansible, run the following commands:

```bash
sudo su # Switch to the root user
cd /vagrant # Change to the /vagrant directory containing the Ansible playbook and other files
cd Ansible/ # Change to the Ansible directory and initiate the playbook
ansible-playbook -i inventory site.yml # Deploy the Ansible script to configure the Slave Node and deploy the LAMP Stack
```

![Ansible](assets/Successful%20execution%20of%20ansible%20playbook%20on%20the%20slave%20node.png)

![Ansible](assets/Successful%20execution%20of%20ansible%20playbook.png)

After successful execution of the Ansible Playbook and the deployment of the LAMP stack on the Slave Node, the Laravel application is reachable from the Slave Node's IP Address.

![Laravel](assets/Confirmed%20Deployment%20of%20the%20Laravel%20App%20on%20the%20Slave%20Node.png)


This marks the end of the deployment, successfully automating the provisioning and configuration of two Ubuntu-based servers using Vagrant, bash scripts, and Ansible.