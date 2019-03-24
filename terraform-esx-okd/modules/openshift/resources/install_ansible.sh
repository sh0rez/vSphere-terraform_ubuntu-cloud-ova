#!/bin/bash
curl -o ansible.rpm https://releases.ansible.com/ansible/rpm/release/epel-7-x86_64/ansible-2.6.5-1.el7.ans.noarch.rpm
yum -y --enablerepo=epel install ansible.rpm
git clone https://github.com/openshift/openshift-ansible.git
cd openshift-ansible
git checkout release-3.11
cp ../resources/inventory.ini ./
ansible-playbook -i inventory.ini playbooks/prerequisites.yml
ansible-playbook -i inventory.ini playbooks/deploy_cluster.yml

