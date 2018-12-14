resource "null_resource" "okd"{
  provisioner "file"{
    source  = "${path.module}/resources"
    destination = "~/"
  }
  provisioner "remote-exec"{
    inline = [
      "chmod +x resources/install_key.sh",
      "bash -x resources/install_key.sh",
      "sleep 1",
      "chmod +x resources/install_req.sh",
      "bash -x resources/install_req.sh",
      "sleep 1",
      "chmod +x resources/install_ansible.sh",
      "bash -x resources/install_ansible.sh",
      "sleep 1",
    ]
  }
  connection {
    type = "ssh"
    user = "root"
    password = "abc=123"
    host = "${var.master_ip}"
  }
}

