#!/bin/bash

echo ECS_CLUSTER="cluster-${cluster_vault}" > /etc/ecs/ecs.config

yum update -y
yum install wget -y

wget https://github.com/prometheus/node_exporter/releases/download/v1.5.0/node_exporter-1.5.0.linux-amd64.tar.gz

tar xvf node_exporter-1.5.0.linux-amd64.tar.gz

cd /node_exporter-1.5.0.linux-amd64/

cp node_exporter /usr/bin/

node_exporter $
