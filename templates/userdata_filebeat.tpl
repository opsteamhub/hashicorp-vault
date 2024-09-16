#!/bin/bash

echo ECS_CLUSTER="cluster-${cluster_vault}" > /etc/ecs/ecs.config

yum update -y
yum install wget -y

yum install -y amazon-ssm-agent
systemctl enable amazon-ssm-agent


echo "Download Exporter" 
wget https://github.com/prometheus/node_exporter/releases/download/v1.5.0/node_exporter-1.5.0.linux-amd64.tar.gz 

echo "unzip exporter" 
tar xvf node_exporter-1.5.0.linux-amd64.tar.gz 

echo "access dir" 
cd /node_exporter-1.5.0.linux-amd64/ 

echo "exec exporter" 
./node_exporter & 

# Baixa e instala o Filebeat versão ${FILEBEAT_VERSION}
curl -L -O "https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-${FILEBEAT_VERSION}-x86_64.rpm"
rpm -vi "filebeat-${FILEBEAT_VERSION}-x86_64.rpm"

# Habilita o Filebeat para iniciar automaticamente com o sistema
systemctl enable filebeat

# Configura o Filebeat (altere os valores de host, username e password abaixo)
tee /etc/filebeat/filebeat.yml > /dev/null <<EOL
filebeat.modules:
filebeat.inputs:
- type: filestream
  id: "${cluster_vault}"
  enabled: true
  paths:
    - /mnt/vault/logs/vault_audit.log  
 
setup.template.name: "${cluster_vault}"
setup.template.pattern: "${cluster_vault}-*"

output.elasticsearch:
  hosts: ["${ELASTICSEARCH_HOST}"]
  username: "${ELASTICSEARCH_USERNAME}"
  password: "${ELASTICSEARCH_PASSWORD}"
  ssl.verification_mode: ${ELASTICSEARCH_SSL_VERIFICATION_MODE}
  index: "${cluster_vault}-%{+yyyy.MM.dd}"
EOL

# Inicia o serviço do Filebeat
systemctl start filebeat
