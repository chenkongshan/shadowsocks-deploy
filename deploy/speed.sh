#!/bin/bash

#首先安装net-tools
yum install -y net-tools
#安装速锐
wget -N --no-check-certificate https://github.com/91yun/serverspeeder/raw/master/serverspeeder.sh && bash serverspeeder.sh