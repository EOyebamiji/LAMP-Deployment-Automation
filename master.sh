#! /usr/bin/env bash
set -e # stop the execution of the script if it fails

# Define a function to allow for colored output
print_colored() {
  CYAN='\033[1;36m'
  NO_COLOR='\033[0m'
  printf "${CYAN}== $1 ${NO_COLOR}\n"
}

# Pass the IP Address of the Master Node as a variable
ip_address=$(ip addr show eth1 | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1' | head -n 1)
echo $ip_address

GITHUB_REPO=https://github.com/laravel/laravel.git

print_colored "=== Executing Master Script for deploying LAMP Stack ==="

# Update and Upgrade the Server
print_colored "== Update package repository =="
sudo apt-get update -y < /dev/null
sudo apt-get upgrade -y < /dev/null

# Install LAMP Stack
print_colored "== Installing the LAMP Stack on the Master Node =="
sudo apt-get install ansible -y  < /dev/null
sudo apt-get install apache2 -y < /dev/null
sudo apt-get install mysql-server -y < /dev/null
sudo add-apt-repository -y ppa:ondrej/php < /dev/null
sudo apt-get update < /dev/null
sudo apt-get install libapache2-mod-php php php-common php-xml php-mysql php-gd php-mbstring php-tokenizer php-json php-bcmath php-curl php-zip unzip -y < /dev/null
sudo sed -i 's/cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/' /etc/php/8.2/apache2/php.ini
sudo systemctl restart apache2 < /dev/null


# Install the Composer
print_colored "== Installing The Composer =="
sudo apt-get install curl -y
sudo apt-get install --reinstall zlib1g #This is to Ensure that the zlib library is up to date on environment.
sudo apt-get install zlib1g-dev -y
sudo pwd && sudo whoami
cd ~
sudo apt update
sudo curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer
composer --version < /dev/null


# Configure Apache to serve the application
print_colored "== Configuring Apache to Serve the Laravel Application =="
sudo tee /etc/apache2/sites-available/laravel.conf > /dev/null <<EOF
<VirtualHost *:80>
  ServerAdmin admin@example.com
  ServerName $ip_address
  DocumentRoot /var/www/html/laravel/public

  <Directory /var/www/html/laravel>
    Options Indexes MultiViews FollowSymLinks
    AllowOverride All
    Require all granted
  </Directory>

  ErrorLog ${APACHE_LOG_DIR}/error.log
  CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOF

sudo a2enmod rewrite
sudo a2ensite laravel.conf || true
sudo systemctl restart apache2 || true


# Clone Laravel Application and Dependencies
sudo pwd
sudo whoami
cd ~
print_colored "=== Cloning the Laravel framework from GitHub ==="
print_colored "== Cloning Laravel Application and Dependencies =="
sudo mkdir /var/www/html/laravel && cd /var/www/html/laravel
cd /var/www/html
if sudo git clone $GITHUB_REPO; then
  echo "== Cloning successful =="
  print_colored "== Cloning successful =="
else
  echo "== Cloning failed =="
  print_colored "== Cloning failed =="
fi

cd /var/www/html/laravel && composer install --no-dev < /dev/null
sudo chown -R www-data:www-data /var/www/html/laravel
sudo chmod -R 775 /var/www/html/laravel
sudo chmod -R 775 /var/www/html/laravel/storage
sudo chmod -R 775 /var/www/html/laravel/bootstrap/cache
cd /var/www/html/laravel && sudo cp .env.example .env
php artisan key:generate

# Configure MYSQLL: Create Username and Password
print_colored "== Configuring MySQL Database and Creating Username and Password =="
echo "Creating MYSQL username and password"
PASS=$2
if [ -z "$2" ]; then
  PASS=`openssl rand -base64 8`
fi

mysql -u root <<MYSQL_SCRIPT
CREATE DATABASE $1;
CREATE USER '$1'@'localhost' IDENTIFIED BY '$PASS';
GRANT ALL PRIVILEGES ON $1.* TO '$1'@'localhost';
FLUSH PRIVILEGES;
MYSQL_SCRIPT

echo "MySQL User and Database Created"
echo "Username: $1"
echo "Database: $1"
echo "Password: $PASS"

# Execute Key Generation and Migration for PHP
print_colored "== Executing Key Generation and Migration for PHP =="
sudo sed -i 's/DB_DATABASE=laravel/DB_DATABASE=emma/' /var/www/html/laravel/.env
sudo sed -i 's/DB_USERNAME=root/DB_USERNAME=emma/' /var/www/html/laravel/.env
sudo sed -i 's/DB_PASSWORD=/DB_PASSWORD=emma90/' /var/www/html/laravel/.env

php artisan config:cache

cd /var/www/html/laravel && php artisan migrate


print_colored "=== Finished Executing the configuration script for the Master Node ==="

print_colored "=== Access the Deployed Laravel Applicatiion via http://$ip_address ==="

print_colored "=== Returning to Vagrant for Deployment of the Slave Node ==="