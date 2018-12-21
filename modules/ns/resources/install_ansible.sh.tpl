#!/bin/bash

sudo apt update
sudo apt install ansible tmux sshpass -y
sshpass -f password.txt ssh-copy-id -o StrictHostKeyChecking=no elsvent@${ns1}
sshpass -f password.txt ssh-copy-id -o StrictHostKeyChecking=no elsvent@${ns2}
