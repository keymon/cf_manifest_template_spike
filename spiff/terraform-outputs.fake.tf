resource "template_file" "terraform_outputs_aws_yml" {
    filename = "${path.module}/terraform-outputs-aws.yml.tpl"

    vars {
        bastion_public_ip       = "194.11.22.31"
        bastion_ssh_user        = "ubuntu"
        bosh_private_ip         = "10.0.0.6"
        bosh_public_ip          = "194.11.22.33"
        bosh_security_group     = "${var.env}-bosh-sg"
        aws_subnet_id           = "subnet12345"
        aws_availability_zone   = "eu-west-1"
        aws_secret_access_key   = "VERYSECRETVERYSECRETVERYSECRETVERYSECRETVERYSECRET"
        aws_access_key_id       = "verysecretverysecretverysecretverysecretverysecretverysecret"
        aws_region              = "${var.zones.zone0}"
        default_security_group  = "${var.env}-default-sg"
    }

    provisioner "local-exec" {
      command = "echo '${template_file.terraform_outputs_aws_yml.rendered}' > terraform-outputs-aws.yml"
    }
}

resource "template_file" "terraform_outputs_gce_yml" {
    filename = "${path.module}/terraform-outputs-gce.yml.tpl"

    vars {
        gce_microbosh_net       = "${var.env}-microbosh-net"
        gce_cf_net              = "${var.env}-cf-net"
        gce_default_zone        = "europe-gce-zone"
        bastion_public_ip       = "195.11.22.31"
        bastion_ssh_user        = "ubuntu"
        bosh_private_ip         = "10.0.0.6"
        bosh_public_ip          = "195.11.22.33"
    }

    provisioner "local-exec" {
      command = "echo '${template_file.terraform_outputs_gce_yml.rendered}' > terraform-outputs-gce.yml"
    }
}

