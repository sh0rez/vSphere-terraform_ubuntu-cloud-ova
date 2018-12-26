#!/bin/bash
yum update
yum install -y python2 \
    python-six tar java-1.8.0-openjdk-headless \
    httpd-tools libselinux-python python-passlib \
    python2-crypto patch pyOpenSSL openssh-clients tmux


yum -y install epel-release
sed -i -e "s/^enabled=1/enabled=0/" /etc/yum.repos.d/epel.repo
