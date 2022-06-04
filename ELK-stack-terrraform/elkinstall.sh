#!/bin/bash
sudo apt update && sudo apt-get upgrade -y
sudo apt-get  install default-jre -y
sudo java -version

#install elasticsearch on ubuntu 
sudo apt-get install apt-transport-https
curl -fsSL https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-7.x.list
sudo apt update
sudo apt install elasticsearch -y
sleep 10
sudo service elasticsearch start
sudo curl http://localhost:9200

#install logstash 
sudo apt-get install logstash -y 
sleep 10

#install kibana 
sudo apt-get install kibana -y 
sleep 10 

sudo mv /tmp/kibana.yaml  /etc/kibana/kibana.yaml
sudo service kibana start 

#install metricbeat 
sudo apt-get install metricbeat
sleep 10
sudo service metricbeat start


#start logstash 
sudo mv /tmp/apache.conf  /etc/logstash/conf.d/apache.conf
sleep 15
sudo service logstash start 

