# создаем директорию для rpm файлов
mkdir /home/vagrant/prometheus/

# скачиваем prometheus
cd home/vagrant/prometheus/; curl -LO https://github.com/prometheus/prometheus/releases/download/v2.37.0/prometheus-2.37.0.linux-amd64.tar.gz
# скачиваем node_exporter
cd home/vagrant/prometheus/; curl -LO https://github.com/prometheus/node_exporter/releases/download/v1.3.1/node_exporter-1.3.1.linux-amd64.tar.gz

# скачиваем grafana

rm -f *.tar.gz /home/vagrant/prometheus/

# создаем пользователся для prometheus
useradd --no-create-home --shell /usr/sbin/nologin prometheus

# создаем пользователя для node_exporter
useradd --no-create-home --shell /bin/false node_exporter

# создаем директории для prometheus
mkdir {/etc/,/var/lib/}prometheus

# выдаем права для пользователя

cd /home/vagrant/prometheus/prometheus-2.37.0.linux-amd64/; cp -r consoles console_libraries prometheus.yml /etc/prometheus/
cd /home/vagrant/prometheus/prometheus-2.37.0.linux-amd64/; cp prom{etheus, tool} /usr/local/bin/
cd /home/vagrant/prometheus/node_exporter-1.3.1.linux-amd64/; cp node_exporter /usr/local/bin/

# выдаем права на пользователям
chown -R prometheus: /etc/prometheus/ /var/lib/prometheus /usr/local/bin/prom*
chown node_exporter: /usr/local/bin/node_exporter

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

