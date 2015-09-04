terraform_outputs = {
  :env => "myenv",
  :aws => {
    :microbosh_subnet_name => "subnet12345",
    :microbosh_security_groups => "myenv-bosh-sg",
    :region => "eu-west-1a",
    :default_security_groups => [ "myenv-default-sg" ],
  },
  :bosh => {
    :private_static_ips => [
      "10.0.0.6"
    ],
    :public_static_ips => [
      "194.11.22.33"
    ],
    :microbosh_endpoint_ip => "10.0.0.6",
    :bastion_public_ip => "194.11.22.31",
    :bastion_ssh_user => "ubuntu"
  }
}


