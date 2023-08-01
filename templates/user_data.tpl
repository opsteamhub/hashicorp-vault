#!/bin/bash

echo ECS_CLUSTER="cluster-${cluster_vault}" > /etc/ecs/ecs.config

yum update -y
yum install wget -y

echo "Download Exporter" >> /home/ec2-user/exporter.log
wget https://github.com/prometheus/node_exporter/releases/download/v1.5.0/node_exporter-1.5.0.linux-amd64.tar.gz >> /home/ec2-user/exporter.log

echo "unzip exporter" >> /home/ec2-user/exporter.log
tar xvf node_exporter-1.5.0.linux-amd64.tar.gz >> /home/ec2-user/exporter.log

echo "access dir" >> /home/ec2-user/exporter.log
cd /node_exporter-1.5.0.linux-amd64/ >> /home/ec2-user/exporter.log

echo "exec exporter" >> /home/ec2-user/exporter.log
./node_exporter & >> /home/ec2-user/exporter.log


