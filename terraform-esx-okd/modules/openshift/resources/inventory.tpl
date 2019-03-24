[OSEv3:children]
masters
nodes
etcd

[OSEv3:vars]
# admin user created in previous section
ansible_ssh_user=root
openshift_deployment_type=origin
openshift_additional_repos=[{'id': 'centos-paas', 'name': 'centos-paas', 'baseurl' :'https://buildlogs.centos.org/centos/7/paas/x86_64/openshift-origin311', 'gpgcheck' :'0', 'enabled' :'1'}]


deployment_type=origin
openshift_disable_check=memory_availability

openshfit_release="3.11"
openshift_docker_insecure_registries=172.30.0.0/16


# use HTPasswd for authentication
openshift_master_identity_providers=[{'name': 'htpasswd_auth', 'login': 'true', 'challenge': 'true', 'kind': 'HTPasswdPasswordIdentityProvider'}]
# define default sub-domain for Master node
openshift_public_hostname=${public_hostname}.${domain}
openshift_master_default_subdomain=${public_hostname}.${domain}
# allow unencrypted connection within cluster
openshift_master_api_port=8443
openshift_master_console_port=8443

[masters]
${master_hostname} openshift_schedulable=true containerized=false

[etcd]
${master_hostname}

[nodes]
# defined values for [openshift_node_group_name] in the file below
# [/usr/share/ansible/openshift-ansible/roles/openshift_facts/defaults/main.yml]
${master_hostname} openshift_node_group_name='node-config-master-infra'
