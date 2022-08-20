#!/bin/bash 

# Mysql backup script

PATH=$PATH:/usr/local/bin
user='-uroot'

MYSQL='mysql --skip-column-names'

for db in `$MYSQL -e "SHOW DATABASES LIKE '%\_tbl'"`;
	do
for tbl in $($MYSQL $user --password $db -e "SHOW TABLES LIKE '%_tbl'");
	do
	/usr/bin/mysqldump $user --password --master-data=2 $db  $tbl | gzip -1 > /home/vagrant/mysqldump/dump_$(date +%F_%T_%N).gz
done    
done
