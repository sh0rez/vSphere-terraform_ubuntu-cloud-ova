#!/bin/bash
sudo apt-add-repository ppa:ansible/ansible -y
sudo apt update
sudo apt install ansible tmux sshpass -y
cd resources
cp config ~/.ssh/config
if [ -e ~/.ssh/id_rsa ]
then
    echo "pass"
else
    ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa
fi
sshpass -f password.txt ssh-copy-id '-o StrictHostKeyChecking=no' elsvent@${ns1}
sshpass -f password.txt ssh-copy-id '-o StrictHostKeyChecking=no' elsvent@${ns2}
sshpass -f password.txt ssh '-o StrictHostKeyChecking=no' elsvent@${ns2} sudo apt update
sshpass -f password.txt ssh '-o StrictHostKeyChecking=no' elsvent@${ns2} sudo apt install python -y
