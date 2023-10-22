#! /usr/bin/env bash
#set -e # stop the execution of the script if it fails

# Remeber to change the IP to the Slave Node IP

# Pass the IP Address of the Master Node as a variable
ip_address=$(ip addr show eth1 | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1' | head -n 1)
echo $ip_address

# Update and Upgrade the Server
sudo apt-get update -y < /dev/null
sudo apt-get upgrade -y < /dev/null

# Install LAMP Stack
sudo apt-get install ansible -y  /dev/null
sudo apt-get install apache2 -y < /dev/null
sudo apt-get install mysql-server -y < /dev/null
sudo add-apt-repository -y ppa:ondrej/php < /dev/null
sudo apt-get update < /dev/null
sudo apt-get install libapache2-mod-php php php-common php-xml php-mysql php-gd php-mbstring php-tokenizer php-json php-bcmath php-curl php-zip unzip -y < /dev/null
sudo sed -i 's/cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/' /etc/php/8.2/apache2/php.ini
sudo systemctl restart apache2 < /dev/null


# Install the Composer
sudo apt-get update
sudo apt-get install --reinstall zlib1g #This is to Ensure that the zlib library is up to date on environment.
sudo apt-get install curl -y
sudo curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer
composer --version < /dev/null

# Configure Apache to serve the application
# sudo cat << EOF > /etc/apache2/sites-available/laravel.conf
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
sudo mkdir /var/www/html/laravel && cd /var/www/html/laravel
cd /var/www/html && sudo git clone https://github.com/laravel/laravel.git
cd /var/www/html/laravel && composer install --no-dev < /dev/null
sudo chown -R www-data:www-data /var/www/html/laravel
sudo chmod -R 775 /var/www/html/laravel
sudo chmod -R 775 /var/www/html/laravel/storage
sudo chmod -R 775 /var/www/html/laravel/bootstrap/cache
cd /var/www/html/laravel && sudo cp .env.example .env
php artisan key:generate

# Configure MYSQLL: Create Username and Password
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
sudo sed -i 's/DB_DATABASE=laravel/DB_DATABASE=emma/' /var/www/html/laravel/.env
sudo sed -i 's/DB_USERNAME=root/DB_USERNAME=emma/' /var/www/html/laravel/.env
sudo sed -i 's/DB_PASSWORD=/DB_PASSWORD=emma90/' /var/www/html/laravel/.env

php artisan config:cache

cd /var/www/html/laravel && php artisan migrate