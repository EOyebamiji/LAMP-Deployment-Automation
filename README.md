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
    git clone https://github.com/laravel/laravel
    ```
2. On cloning the repository, run the following command:

   ```bash
   vagrant up
   ```

   This will excute the configuration as defined in the Vagrantfile. The file is configured to deploy two (2) ubuntu-based servers "Master" and "Slave" will prvisioning the "Master" wih an execution script which automates the installation of the LAMP Stack and the dependencies. The Vagrantfile is provisioned to excute the [execution script]() which prepaes the installation of the the LAMP Stack and the dependencies via the [master script]()

3. On Successful execution of the Vagrantfile, you will be welcomed with a similar banner message as seen below.

    ![Success](assets/Successful%20execution%20of%20the%20Vagrantfile%20Master%20Script.png)

    - The Laravel Application has been successfully deployed and hosted on the Master Node and his accessible via the IP Address set by the Vagrantfile for the Master Node.
    
    ![Confirmed Deployment](assets/Confirmed%20Deployment%20of%20the%20Laravel%20App%20on%20the%20Master%20Node.png)

4. Confirm Access to the Master Node and Slave Node by executing the following command:

    ```bash
    vagrant ssh master
    vagrant ssh slave
    ```
    The above command will grant access to the Master Node and Slave Node respectively. Next step is to create an ssh key for the Master Node and Slave Node to allow access to the Master Node from the Slave Node and vice versa.

5. In the Master Node, execute the following command:

    ```bash
    sudo su #This is to switch to the root user
    cd ~
    ssh-keygen #Press Enter to all questions
    cat ~/.ssh/id_rsa.pub #This will disable the generated ssh key
    ```

    Next step is to launch a new CLI via Git Bash (Our preferred CLI client) and ssh into the Slave Node

    ```bash
    vagrant ssh slave
    ```

    next step is to to switch to the root user and save the generated ssh key from the Master Node

    ```bash
    sudo su
    vim ~/.ssh/authorized_keys #This will open the authorized_keys for this node, save the copied ssh key into it and save
    ```

    ![ssh](assets/ssh-keygen%master.png)

