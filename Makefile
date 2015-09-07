.PHONY: terraform_outputs spiff erb

all: terraform_outputs spiff erb

terraform_outputs:
	cd common && \
	terraform apply -var env=myenvi && \
	terraform output terraform_outputs_aws_yml > terraform-outputs-aws.yml && \
	terraform output terraform_outputs_gce_yml > terraform-outputs-gce.yml


spiff: terraform_outputs
	make -C spiff all

erb: terraform_outputs
	make -C erb all

