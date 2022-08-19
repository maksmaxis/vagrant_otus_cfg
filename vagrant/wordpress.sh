# создать директорию , в которую загрузим последнюю версию Wordpress:
mkdir /home/vagrant/temp_wp; cd /home/vagrant/temp_wp; wget http://192.168.56.1:80/latest.zip

# Добавить репозитарии REMI и EPEL
yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
yum -y install https://rpms.remirepo.net/enterprise/remi-release-7.rpm

# Установка PHP 7.4
yum install -y yum-utils
yum-config-manager --enable remi-php74
yum install -y php php-cli
sudo yum install php  php-cli php-fpm php-mysqlnd php-zip php-devel php-gd php-mcrypt php-mbstring php-curl php-xml php-pear php-bcmath php-json
# restart apache
systemctl restart httpd.service

# распаковка zip файла Wordpress
yum install -y unzip
cd /home/vagrant/temp_wp; unzip -q latest.zip -d /var/www/html/

# предоставление директории соответствующие права доступа
chown -R apache:apache /var/www/html/wordpress
chmod -R 755 /var/www/html/wordpress

# создание родительской директории контента
mkdir -p /var/www/html/wordpress/wp-content/uploads

# разрешить веб-серверу производить запись в данную директорию
chown -R :apache /var/www/html/wordpress/wp-content/uploads

# скопировать в директорию предоставления контента
cd /var/www/html/wordpress/; cp wp-config-sample.php wp-config.php


# поменять данные как в mysql
sed -i 's/database_name_here/wp_vagrant/' /var/www/html/wordpress/wp-config.php
sed -i 's/username_here/vagrant/' /var/www/html/wordpress/wp-config.php
sed -i 's/password_here/Ghjcnjnfr_01./' /var/www/html/wordpress/wp-config.php
