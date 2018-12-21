resource "null_resource" "test"{
  provisioner "file"{
    source  = "${path.module}/resources"
    destination = "/tmp"
    
    connection {
      type = "ssh"
      user = "elsvent"
      password = "password"
      host = "${var.ns_ip_list[0]}"
    }
  }
}
