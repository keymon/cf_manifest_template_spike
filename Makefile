all: terraform_outputs spiff erb

common/terraform.tfstate:
	cd common && \
	terraform apply -var env=myenv

terraform-outputs-aws.yml: common/terraform.tfstate
	cd common && \
	terraform output terraform_outputs_aws_yml > terraform-outputs-aws.yml

terraform-outputs-gce.yml: common/terraform.tfstate
	cd common && \
	terraform output terraform_outputs_gce_yml > terraform-outputs-gce.yml

.PHONY: terraform_outputs spiff erb

terraform_ouputs: terraform-outputs-aws.yml terraform-outputs-gce.yml

spiff: terraform_outputs
	make -C spiff all

erb: terraform_outputs
	make -C erb all

