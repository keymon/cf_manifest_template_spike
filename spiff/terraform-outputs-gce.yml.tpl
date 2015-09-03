---
terraform_outputs:
  gce:
    microbosh_network_name: ${gce_network_name}
    network_name: ${gce_network_name}
    default_zone: ${gce_default_zone}
  bosh:
    private_static_ips:
    - ${bosh_private_ip}
    public_static_ips:
    - ${bosh_public_ip}
    microbosh_endpoint_ip: ${bosh_public_ip}
    bastion_public_ip: ${bastion_public_ip}
    bastion_ssh_user: ${bastion_ssh_user}
