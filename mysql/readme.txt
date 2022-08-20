- mysql confi

# После установки mysql выясняем временный пароль (master/slave)
grep "A temporary password" /var/log/mysqld.log

# Устанавливаем пароль (master/slave)
ALTER USER 'root'@'localhost' IDENTIFIED WITH 'caching_sha2_password' BY 'Ghjcnjnfr_01.';

# Запускаем скрипт безопасности для MySQL (master/slave)
mysql_secure_installation
Указываем 'временный пароль' и устанавливаем новый пароль.

# Создаём пользователя для реплики (master)
CREATE USER repluser@'%' IDENTIFIED WITH 'caching_sha2_password' BY 'oTUSlave#2020'; 
# Даём ему права на репликацию
GRANT REPLICATION SLAVE ON *.* TO repluser@'%'; (master)

# Укажем пароль в /etc/my.cnf чтобы не вводить пароль (master/slave)

[client]
user = root
password = Ghjcnjnfr_01.
host = 127.0.0.1
[mypath]
user = root
password = Ghjcnjnfr_01.
host = localhost
# для входа используем параметр
mysql --login-path=mypath

# На слейве устанавливаем репликацию с указанием бинлога
STOP SLAVE;
CHANGE MASTER TO MASTER_HOST='192.168.56.10', MASTER_USER='repluser', MASTER_PASSWORD='oTUSlave#2020', MASTER_LOG_FILE='binlog.000003', MASTER_LOG_POS=157, GET_MASTER_PUBLIC_KEY = 1;
START SLAVE

#  статус
show slave status\G
