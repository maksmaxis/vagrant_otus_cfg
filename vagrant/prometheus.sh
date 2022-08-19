# создаем директорию для rpm файлов
mkdir /home/vagrant/prometheus/

# скачиваем prometheus
cd /home/vagrant/prometheus/; wget http://192.168.56.1:80/node_exporter-1.3.1.linux-amd64.tar.gz
# скачиваем node_exporter
cd /home/vagrant/prometheus/; wget http://192.168.56.1:80/prometheus-2.37.0.linux-amd64.tar.gz
# скачиваем grafana
cd /home/vagrant/prometheus/; wget http://192.168.56.1:80/grafana-enterprise-9.1.0-1.x86_64.rpm

# делаем распаковку архивов
cd /home/vagrant/prometheus/; tar -xf prometheus-2.37.0.linux-amd64.tar.gz; tar -xf node_exporter-1.3.1.linux-amd64.tar.gz

# удаляем архивы
#rm -f /home/vagrant/prometheus/*.tar.gz

# создаем пользователся для prometheus
useradd --no-create-home --shell /usr/sbin/nologin prometheus

# создаем пользователя для node_exporter
useradd --no-create-home --shell /bin/false node_exporter

# создаем директории для prometheus
mkdir {/etc/,/var/lib/}prometheus

# копируем конфигурацию сервисов в директории

cd /home/vagrant/prometheus/prometheus-2.37.0.linux-amd64/; cp -r consoles console_libraries prometheus.yml /etc/prometheus/
cd /home/vagrant/prometheus/prometheus-2.37.0.linux-amd64/; cp prom{etheus,tool} /usr/local/bin/
cd /home/vagrant/prometheus/node_exporter-1.3.1.linux-amd64/; cp node_exporter /usr/local/bin/

# выдаем права для пользователям
chown -R prometheus: /etc/prometheus/ /var/lib/prometheus /usr/local/bin/prom*
chown node_exporter: /usr/local/bin/node_exporter

cp /home/vagrant/repo/vagrant_otus_cfg/prometheus/prometheus.service /etc/systemd/system/
cp /home/vagrant/repo/vagrant_otus_cfg/prometheus/node_exporter.service /etc/systemd/system/

# перезапустить демона
systemctl daemon-reload

systemctl start node_exporter
systemctl start prometheus
systemctl enable node_exporter
systemctl enable prometheus

# запрашивать у node_exporter данные каждые 5s
echo "
  - job_name: 'node_exporter'
    scrape_interval: 5s
    static_configs:
      - targets: ['localhost:9100']

" >> /etc/prometheus/prometheus.yml

# перезапустить конфигурацию prometheus
systemctl reload prometheus

# установка grafana
sudo yum install -y /home/vagrant/prometheus/grafana-enterprise-9.1.0-1.x86_64.rpm
# запуск grafana
systemctl start grafana-server.service
systemctl enable grafana-server.service
