#!/bin/bash
cd resources
ansible-galaxy install bertvv.bind
python gen_master.py
ansible-playbook -i hosts.master master.yml
python gen_slave.py
ansible-playbook -i hosts.slave slave.yml
