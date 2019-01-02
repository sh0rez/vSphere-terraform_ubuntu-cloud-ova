# Add openshift install using terraform trigger ansible
Need install ubuntu 16.04 LTS template
Trick: Add this line **After=dbus.service** in /lib/systemd/system/open-vm-tools.service [Unit] section

# vSphere terraform unify os for customize ip hostname setting
This repository fork from sh0rez/vSphere-terraform_ubuntu-cloud-ova

The original repository using ova package, this repository using ISO pre-install
template for customize.

Some point you may need to know before using vSphere plugin

1. vmware tool is required for clone customize
2. perl is required(if you search you will see a lot of user failed because perl
3. please aware the support matrix, some essential OS may failed the guestOS check.

Note: if you are using CentOS, sometime may failed because /etc/redhat-release not match.
There is a trick hint: for me using **Red Hat Enterprise Linux Server release 7.0 (Maipo)**
, it will work and not effect function.

# OKD template

Change terraform.tfvars.example for your setting than cp to terraform.tfvars

Install terraform via below website

https://www.terraform.io/downloads.html

After install terraform execute to construct your okd set
```
terraform init
make
```

Use below command to destroy okd set
```
make destroy
```

**if you deploy failed**
go to master

```
cd openshift-ansible
ansible-playbook -i inventory.ini playbooks/deploy_cluster.yml
```

Take a look into openshift-ansible.log wait the deploy complete
Using below command add a cluster-admin user
```
htpasswd /etc/origin/master/htpasswd <user>
oc adm policy add-cluster-role-to-user cluster-admin <user>
```

for lab template password
okd node/master password: root/abc=123
nameserver password: elsvent/password


# License :book:
Released into the public domain under terms of the [UNLICENSE](/LICENSE).
Any PR will be welcome.:)
