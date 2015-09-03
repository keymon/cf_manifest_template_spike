---
terraform_outputs:
  aws:
    microbosh_subnet_name: ${aws_subnet_id}
    microbosh_security_groups:
    - ${bosh_security_group}
    region: ${aws_region}
    default_security_groups:
    - ${default_security_group}
  bosh:
    private_static_ips:
    - ${bosh_private_ip}
    public_static_ips:
    - ${bosh_public_ip}
    microbosh_endpoint_ip: ${bosh_private_ip}
    bastion_public_ip: ${bastion_public_ip}
    bastion_ssh_user: ${bastion_ssh_user}
