#!/bin/bash

echo ECS_CLUSTER="cluster-${cluster_vault}" > /etc/ecs/ecs.config

yum update -y
yum install wget -y

echo "Download Exporter" 
wget https://github.com/prometheus/node_exporter/releases/download/v1.5.0/node_exporter-1.5.0.linux-amd64.tar.gz 

echo "unzip exporter" 
tar xvf node_exporter-1.5.0.linux-amd64.tar.gz 

echo "access dir" 
cd /node_exporter-1.5.0.linux-amd64/ 

echo "exec exporter" 
./node_exporter & 


