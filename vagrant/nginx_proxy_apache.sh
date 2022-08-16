# backup конфигурации nginx
cd /etc/nginx/; mv nginx.conf nginx.conf.bak;
# backup конфигурации apache
cd /etc/httpd/conf.d/; mv nginx.conf nginx.conf.bak;

# копируем конфигурацию из репозитория
cp /home/vagrant/repo/vagrant_otus_cfg/nginx/nginx.conf /etc/nginx/

# копируем конфигурацию для upstream в nginx на BackEnd apache (проксирование на 8080 с 80)
cp /home/vagrant/repo/vagrant_otus_cfg/nginx/balancing.conf /etc/nginx/conf.d/

# Конфигурация локальных хостов
cp /home/vagrant/repo/vagrant_otus_cfg/apache/servers.conf /etc/httpd/conf.d/

# Создаем индексы для кажого порта 8080, 8081 и 8082 

mkdir /var/www/html1 /var/www/html2

cat > /var/www/html/index.html <<EOF
<h1> Welcome 8080 </h1>
EOF

cat > /var/www/html1/index.html <<EOF
<h1> Welcome 8081 </h1>
EOF

cat > /var/www/html2/index.html <<EOF
<h1> Welcome 8082 </h1>
EOF

# перезапустить конфигурацию nginx и apache
systemctl reload nginx
systemctl reload httpd