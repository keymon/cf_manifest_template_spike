.PHONY: terraform_outputs spiff erb

all: terraform_outputs spiff erb

terraform_outputs:
	cd common && \
	touch terraform-outputs-aws.yml terraform-outputs-gce.yml && \
	terraform apply -var env=myenv

spiff: terraform_outputs
	make -C spiff all

erb: terraform_outputs
	make -C erb all

