# Установка репозитория Oracle MySQL 8.0
rpm -Uvh https://repo.mysql.com/mysql80-community-release-el7-6.noarch.rpm
rpm --import https://repo.mysql.com/RPM-GPG-KEY-mysql-2022

# Включаем репозиторий
sed -i 's/enabled=1/enabled=0/' /etc/yum.repos.d/mysql-community.repo

# Устанавливаем MySQL
yum --enablerepo=mysql80-community install -y mysql-community-server

# Запускаем
systemctl start mysqld

# Ставим в автозагрузку
systemctl enable mysqld

sed -i '6ibind-address           = 0.0.0.0\nserver-id              = 1\nbinlog_do_db                = master-bin' /etc/my.cnf

#echo "
#[client]
#user = root
#password = $(cat /var/log/mysqld.log | grep 'A temporary password' | awk '{print $NF}')
#host = 127.0.0.1
#[mypath]
#user = root
#password = $(cat /var/log/mysqld.log | grep 'A temporary password' | awk '{print $NF}')
#host = localhost
#" >> /etc/my.cnf

# Перезагрузка mysql
systemctl restart mysqld

# перезапустить конфигурацию nginx и apache
systemctl reload nginx
systemctl reload httpd
