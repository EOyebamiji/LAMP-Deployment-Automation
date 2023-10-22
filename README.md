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

### 1. Clone the repository 
1. Create a directory for your project and navigate to it in your terminal.

    ```bash
    git clone git@github.com:EOyebamiji/AltSchoolSecondSemesterProject.git
    ```
2. On cloning the repository, run the following command:

   ```bash
   cd AltSchoolSecondSemesterProject
   vagrant up
   ```

   This will excute the configuration as defined in the Vagrantfile. The file is configured to deploy two (2) ubuntu-based servers "Master" and "Slave" will prvisioning the "Master" wih an execution script which automates the installation of the LAMP Stack and the dependencies. The [Vagrantfile](/Vagrantfile) is provisioned to excute the [execution script](/execute.sh) which prepaes the installation of the the LAMP Stack and the dependencies via the [master script](/master.sh)

3. On Successful execution of the Vagrantfile, you will be welcomed with a similar banner message as seen below.

    ![Success](assets/Successful%20execution%20of%20the%20Vagrantfile%20Master%20Script.png)

    - The Laravel Application has been successfully deployed and hosted on the Master Node and his accessible via the IP Address set by the Vagrantfile for the Master Node.
    
    ![Confirmed Deployment](assets/Confirmed%20Deployment%20of%20the%20Laravel%20App%20on%20the%20Master%20Node.png)

4. Confirm Access to the Master Node and Slave Node by executing the following command:

    ```bash
    vagrant ssh master
    vagrant ssh slave
    ```
    The above command will grant access to the Master Node and Slave Node respectively. 

    ![Vag-Master](assets/Successful%20access%20to%20vagrant%20master.png)

    ![Vag-Slave](assets/Successful%20access%20to%20vagrant%20slave.png)
    
5.   Next step is to create an ssh key for the Master Node to allow access to the Slave Node from thebMaster Node. This is crucial for our Ansible script. In the Master Node, execute the following command:

        ```bash
        sudo su #This is to switch to the root user
        cd ~
        ssh-keygen #Press Enter to all questions
        cat ~/.ssh/id_rsa.pub #This will display the generated ssh key
        ```
![SSH](assets/ssh-keygen%20master.png)

Next step is to launch a new CLI via Git Bash (Our preferred CLI client) and ssh into the Slave Node.

```bash
vagrant ssh slave
```

Switch to the root user and save the generated ssh key from the Master Node

```bash
sudo su
vim ~/.ssh/authorized_keys #This will open the authorized_keys for this node, save the copied ssh key into it and save
```
![ssh](assets/save%20ssh%20slave.png)

Once you have copied the ssh key into the authorized_keys for this node, test connection to the slave node from the master node to verify that the slave node is reachable from the master node via ssh.

```bash
ssh root@iP_Address
```
![ssh](assets/successful%20ssh%20to%20slave%20node.png)

6. Next step is to run the Ansible playbook to deploy the configuration of the slave node from the master node.

```bash
sudo su # This will switch to the root user
cd /vagrant # Change to the /vagrant directory which contains our Ansible playbook and other files
cd Ansible/ #Change to the Ansible directory and initiate the playbook
ansible-playbook -i inventory site.yml #This will deploy the ansible script to configure the slave node and deplploy the LAMP Stack
```

![Ansible](assets/Successful%20execution%20of%20ansible%20playbook%20on%20the%20slave%20node.png)

![Ansible](assets/Successful%20execution%20of%20ansible%20playbook.png)

After a successful execution of the Ansible Playbook and successful deployment of the LAMP stack on the slave node. The Laravel application is also reachable from the slave node's IP Address.

![Laravel](assets/Confirmed%20Deployment%20of%20the%20Laravel%20App%20on%20the%20Slave%20Node.png)


This marks the end of the deployment and the successful deployment of two (2) Ubuntu-based servers via Vagrant, the automation of the provisioning and configuration of the Master node using bash scripts and the slave node using Ansible.