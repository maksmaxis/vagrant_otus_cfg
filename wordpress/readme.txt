- wordpress
# Присвоим значения:database=wp_vagrant user=wpuser и password=Ghjcnjnfr_01.:

# Создаём БД
CREATE DATABASE wp_vagrant;

# Создаём пользователя 
CREATE USER wpuser@localhost IDENTIFIED BY 'Ghjcnjnfr_01.';
# Даём ему права
GRANT ALL PRIVILEGES ON wp_vagrant.* TO wpuser@localhost;

FLUSH PRIVILEGES;
