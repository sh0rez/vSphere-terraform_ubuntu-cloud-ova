# vSphere terraform unify os for customize ip hostname setting

The original repository using ova package, the alternative way using ISO pre-install VM
convert VM to template for customize.

For pre-install VM step:

1. Just install VM by ISO in normal way.
2. Left most option default.
3. Check below critiria, ensure you setup VM template correct.

Some point you may need to know before using vSphere plugin

1. vmware tool is required for clone customize
2. perl is required(if you search you will see a lot of user failed because perl
3. please aware the support matrix, some essential OS may failed the guestOS check.

Note: if you are using CentOS, sometime may failed because /etc/redhat-release not match.
There is a trick hint: for me using **Red Hat Enterprise Linux Server release 7.0 (Maipo)**
, it will work and not effect function.
