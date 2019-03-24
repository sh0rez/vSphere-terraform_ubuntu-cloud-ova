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
=======
~~**It is [part of a blog post](https://shorez.de/2018/deploying-ubuntu-cloud-images-to-vsphere-using-terraform/) , consider reading it for further instructions**~~
I do not have a blog anymore, so the [post is included in this repository](post/README.md)

# License :book:
Released into the public domain under terms of the [UNLICENSE](/LICENSE).
Any PR will be welcome.:)
