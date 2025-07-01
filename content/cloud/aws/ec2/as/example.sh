#!/bin/bash

yum install nginx -y
systemctl start nginx

echo $(hostname -s) >> /usr/share/nginx/html/index.html