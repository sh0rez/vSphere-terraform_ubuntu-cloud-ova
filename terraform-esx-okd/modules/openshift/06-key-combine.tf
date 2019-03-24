resource "null_resource" "combine_key"{
  provisioner "local-exec" {
    command = "cat ${path.module}/resources/node_key.tmp >> ${path.module}/resources/install_key.sh"
  }
  depends_on = ["null_resource.export_node_key_tmp", "null_resource.export_master_key" ]
}
