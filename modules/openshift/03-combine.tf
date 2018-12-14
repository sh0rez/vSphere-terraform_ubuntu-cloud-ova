resource "null_resource" "combine"{
  provisioner "local-exec" {
    command = "cat ${path.module}/resources/node.tmp >> ${path.module}/resources/inventory.ini"
  }
  depends_on = ["null_resource.export_hostname_inventory", "null_resource.export_node_tmp" ]
}
