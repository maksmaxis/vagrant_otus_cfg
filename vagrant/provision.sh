#sudo yum update
# отлкючение selinux
setenforce 0
sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config

# отключение файрвол
systemctl stop firewalld
systemctl disable firewalld

yum install -y epel-release
# установка nginx
yum install -y nginx; systemctl start nginx; systemctl enable nginx

# установка apache
yum install -y httpd

# изменить порт Apache с 80 на 8080
sed -i 's/Listen 80/Listen 8080/' /etc/httpd/conf/httpd.conf

# запустить Apache
systemctl start httpd; systemctl enable httpd


yum install -y php php-fpm
systemctl start php-fpm
systemctl enable php-fpm

# установка git
yum install -y git

# создание директории для файлов git
mkdir /home/vagrant/repo/

# перейти в директорию workin statuin и скачать файлы из репозитория github
cd /home/vagrant/repo/; git init; git clone https://github.com/maksmaxis/vagrant_otus_cfg.git

