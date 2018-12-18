#!/bin/bash

sudo apt-add-repository ppa:ansible/ansible -y
sudo apt update
sudo apt install ansible -y
ansible-galaxy install bertvv.bind

