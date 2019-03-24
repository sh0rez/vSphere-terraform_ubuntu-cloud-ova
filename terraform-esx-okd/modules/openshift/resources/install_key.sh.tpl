#!/bin/bash
yum update
yum install sshpass -y
cat /dev/zero | ssh-keygen -q -N ""
cd resources
sshpass -f password.txt ssh-copy-id -o StrictHostKeyChecking=no root@${master_hostname}.${domain}
