data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

data "template_file" "scripts" {
  template = file("${path.module}/templates/scripts.sh")
  vars = {
    username            = var.username
    password            = var.password
    backend_roles       = "[ ${join(", ", [for s in var.backend_roles : format("%q", s)])} ]"
    opensearch_endpoint = var.opensearch_endpoint
  }
}

data "template_file" "cloud_init" {
  template = file("${path.module}/templates/cloud-init.yml")
}

data "template_cloudinit_config" "user_data" {
  gzip          = false
  base64_encode = false

  # Main cloud-config configuration file.
  part {
    filename     = "init.cfg"
    content_type = "text/cloud-config"
    content      = data.template_file.cloud_init.rendered
  }

  part {
    filename     = "user_data.sh"
    content_type = "text/x-shellscript"
    content      = data.template_file.scripts.rendered
  }
}
