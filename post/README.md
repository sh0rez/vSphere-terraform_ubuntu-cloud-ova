# Deploying Ubuntu Cloud Images to vSphere using Terraform

It's fairly easy to deploy cloud-init configurable Ubuntu Cloud OVA Images to vSphere (standalone ESXi or vCenter, using Terraform. The following post illustrates how to achieve this, all project files are provided on [GitHub here](https://github.com/sh0rez/vSphere-terraform_ubuntu-cloud-ova).


The real benefit of this is probably the way the final deployment works: On the one hand it is fully declarative (thank's Terraform) but on the other all configuration of the actual Ubuntu OS is done by cloud-init, so the image is ready to boot, no installation required, just by a single `terraform apply`.

## Ubuntu Cloud Image? OVA?
#### Ubuntu Cloud Image
Canonical (the company behind Ubuntu) is distributing special kinds of the OS called "cloud images", available for download at at [cloud-images.ubuntu.com](https://cloud-images.ubuntu.com/). They are special compared to the regular Ubuntu Server: Being targeted at the cloud (most notably here OpenStack), they don't require actual installation to the hard drive. Rather they are in some kind of "virgin" state, ready to boot but unusable due to a lack of appropriate configuration.

This configuration must be done by the administrator using a tool called [cloud-init](https://cloudinit.readthedocs.io/en/latest/). Basically, in some way a `.yaml` file is injected into the system at boot time, declaring the desired state of the OS. `cloud-init` then takes the needed steps to reach that state. Luckily, we do not need to know how this works in detail here, vSphere does the hard part of injecting the configuration. We just need to provide it.

#### OVA
Ok. So what's to OVA?
OVA (or OVF) is a standardized, open format for storing Virtual Machines, mostly used in the worlds of VMware and VirtualBox. For people wanting to know how this actually works, there is an excellent [Wikipedia Entry](https://en.wikipedia.org/wiki/Open_Virtualization_Format) about this.

While other popular platforms like OpenStack prefer `.qcow2` images, `.ova` is the perfect fit for our vSphere, also because Canonical provides an [Ubuntu OVA](https://cloud-images.ubuntu.com/bionic/current/bionic-server-cloudimg-amd64.ova) which is configurable using cloud-init.

## Getting started
There are several steps needed to get started:

1. Access to vSphere. This may be vCenter or standalone ESXi, but keep in mind the pro or trial version is needed to access the API needed for Terraform. The free tier does not work here :(
2. Terraform. Installation is covered here, the tested version at the time of writing this article is `v0.11.7`

## Uploading the OVA (once!)
Before creating actual instances, the template (OVA) must be uploaded to vSphere.

First, head over to [cloud-images.ubuntu.com](https://cloud-images.ubuntu.com/), select your version of Ubuntu (sticking with `16.04 Xenial` release here, altough there should be no difference when using `18.04 Bionic` or any other Ubuntu version), select the **`current`** release (or if you know what you're doing something else) and download the file called something similar to `VERSION-server-cloudimg-amd64.ova`


![ubuntu-cloud-ova-download](./img/ubuntu-cloud-ova-download.png)


Once we have this file, we can upload it to our vSphere. This is shown using vCenter 6.7 here:

**1.** First, right click the datacenter or single host and select `Deploy OVF Template`:


![deploy-ova-vcenter](./img/deploy-ova-vcenter.png)


After that, upload the downloaded OVA File and hit next:


![deploy_ova_step1](./img/deploy_ova_step1.png)


**2.** Once uploaded, select where to store the template and name it appropriately. We need that name later on.

**3, 4, 5.** Select your compute resource in step 3 and review your setup in step 4, continue with step 5, storage. The only thing here to do is select `Thin Provision` as disk format, as it saves (a lot of) storage.


![deploy_ova_step5](./img/deploy_ova_step5.png)


**6. & 7.** What you select in steps 6 and 7 doesn't matter as it is going to be overwritten by Terraform anyways. Just leave the default values here, that's fine.

**8.** Finally, in step 8 review the selection and hit import.

**WARNING:** After the import succeeds, **don't power on the template**. This will break cloud-init.

## Terraforming Ubuntu Instances
We are done with the 'manual' part here. Let's dive in to the world of IAC.

Let's talk quickly how this is going to work. So: vSphere provides cloud-init support using a feature called `vApp properties`. I'm unable to find further documentation about this but it works so let's don't care. 

Terraform also supports this with little hassle: The cloud-init data needs to be base-64 encoded for vApp but Terraform can do this easily using built in functions. Finally, I decided to load an external `cloud-init.yml` file into the base64 function and submit this to vSphere.

The full example is available on [GitHub](https://github.com/sh0rez/vSphere-terraform_ubuntu-cloud-ova).

The basic procedure of creating a virtual machine on vSphere using Terraform is [perfectly described in the official docs](https://www.terraform.io/docs/providers/vsphere/index.html). To use the benefits of the Ubuntu-Cloud OVA, there are important key aspects that matter:

1. Cloning from the template. The new VM is just a clone of the template VM with several settings overriden.
```js
data "vsphere_virtual_machine" "template" {
  name          = "TEMPLATE_VM_NAME_HERE"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

resource "vsphere_virtual_machine" "vm" {
  clone {
    template_uuid = "${data.vsphere_virtual_machine.template.id}"
  }
}
```


2. vApp properties: To push the values from the cloud-init.yml file to the new VM, base64 encode the file:
```js
resource "vsphere_virtual_machine" "vm" {
  clone {
    template_uuid = "${data.vsphere_virtual_machine.template.id}"
  }
  vapp {
    properties {
      user-data = "${base64encode(file("cloud-init.yml"))}"
    }
  }
}
```

3. cloud-init.yml: This file is where the actual configuration magic happens. Explaining cloud-init is out of scope here, but consider reading their documentation, it provides handy examples: [Here](https://cloudinit.readthedocs.io/en/latest/topics/examples.html#)

The rest of the `terraform.tf` is basically just the first example from the official docs. Just take a look at the GitHub repo, it's all self explanatory.

### Configuring
First, checkout the example project from GitHub:
```shell
$ git clone https://github.com/sh0rez/vSphere-terraform_ubuntu-cloud-ova
$ cd vSphere-terraform_ubuntu-cloud-ova
```

Then go ahead and move the `terraform.tfvars.example` to `terraform.tfvars` and edit it with the editor of your choice:
```shell
$ mv terraform.tfvars.example terraform.tfvars

# using vi here, take whatever you prefer
$ vi terraform.tfvars
```

This file is full of placeholders, waiting to be customized:


**General vSphere configuration:**
* `user`: Any user account present at your vSphere instance suitable for Terraform

* `password`: The appropriate password for the chosen user

* `vsphere_server`: Your vSphere instance. May be `IP-Address`, `FQDN` or `Hostname`. Has to resolve on the machine intended for using Terraform (probably your local machine)

* `datacenter`: The vSphere datacenter to deploy to

* `datastore`: The datastore to store the disk on

* `resource_pool`: The Resource-Pool to use


**VM Settings:**
* `name`: The name of the VM

* `template`: The name of the template. This MUST be the name you chose during importing the OVA.

* `network`: The network for the VM to reside in

* `cpus`: CPU-Cores of the VM. Just a number (e.g. `2`, `4`, etc.)

* `memory` = Memory of the VM in Mb (e.g. `1024`, `2048`, etc.)

### Deploying
Now as all neccessary data got filled in, there's nothing in the way to create the first VM.

Just enter to get an overview of the intended changes:
```shell
$ terraform plan
```

Review the changes and if they are fine (they should be) continue applying:
```shell
$ terraform apply
# enter 'yes' to approve
```


This takes around 1 minute and completes with a nice green message. Your new code-declarated VM is ready! Hooray 🎉. Just take a look at it in the web-interface: 


![terraformed_vm_final](./img/terraformed_vm_final.png)


It's just another virtual machine.

## Next steps
How to continue? Here are a few tips to get further on the topic:

1. Get familiar with cloud-init. To unleash the whole power of this project, you need to know how to configure the VM. Good examples are in the [official docs](https://cloudinit.readthedocs.io/en/latest/topics/examples.html)
2. Read the [Terraform vSphere provider docs](https://www.terraform.io/docs/providers/vsphere/index.html). Every capability of the provider is explained there.

## Troubleshooting

### Metadata not applied

Based on this artice [from VMWare Community](https://communities.vmware.com/t5/VMware-PowerCLI-Discussions/Set-fixed-IP-in-ova/m-p/484260/highlight/true#M13864) there's an issue that *User-data cannot change an instance’s network configuration*. Including network part in the cloud-init setup will cause all configuration is skipped.

As a workaround include your network setup as a file like this:

```tf
#cloud-config
write_files:
- encoding: base64
   content: "${base64encode(file("metadata.yml"))}"
   path: /etc/netplan/50-cloud-init.yaml
runcmd:
- netplan apply
```

and `metadata.yml` may look like this:

```yaml
network:
version: 2
ethernets:
   ens192:
    ens192:
      dhcp4: false
      dhcp6: false
      addresses:
        - 192.168.1.111
      routes:
      - to: default
        via: 192.168.1.1
      nameservers:
        addresses:
          - 1.1.1.1
```


