#!/bin/bash

echo ECS_CLUSTER="cluster-${cluster_vault}" > /etc/ecs/ecs.config

yum update -y
yum install wget -y

yum install -y awslogs
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

# Configurar o arquivo de logs do CloudWatch (/etc/awslogs/awslogs.conf)
cat <<EOL > /etc/awslogs/awslogs.conf
[general]
state_file = /var/lib/awslogs/agent-state

[/vault/audit]
file = /vault/logs/vault_audit.log
log_group_name = ${log_group_name}
log_stream_name = audit-log
datetime_format = %Y-%m-%dT%H:%M:%S
EOL

cat <<EOL > /etc/awslogs/awscli.conf
[plugins]
cwlogs = cwlogs
[default]
region = ${region_principal}
EOL

systemctl start awslogsd
systemctl enable awslogsd.service