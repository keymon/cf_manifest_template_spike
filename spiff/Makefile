all: bosh_spiff cf_spiff

terraform_outputs:
	touch terraform-outputs-aws.yml terraform-outputs-gce.yml
	terraform apply -var env=myenv

bosh_spiff: bosh_spiff_gce bosh_spiff_aws

bosh_spiff_gce: terraform_outputs
	cd bosh && \
	spiff merge \
		bosh-manifest-main.yml \
		bosh-manifest-common.yml \
		bosh-manifest-gce.yml \
		terraform-outputs-gce.yml \
		secrets.yml \
		> generated.manifest-gce.yml

bosh_spiff_aws: terraform_outputs
	cd bosh && \
	spiff merge \
		bosh-manifest-main.yml \
		bosh-manifest-common.yml \
		bosh-manifest-aws.yml \
		terraform-outputs-aws.yml \
		secrets.yml \
		> generated.manifest-aws.yml

cf_spiff: cf_spiff_gce cf_spiff_aws

director_uuid:
	# TODO
	cd cf && \
	echo "---\ndirector_uuid: abcd-abcd-abcd-abcd-abcd-abcd" > director_uuid.yml

cf_spiff_gce: director_uuid terraform_outputs
	cd cf && \
	spiff merge \
		cf-manifest-main.yml \
		cf-manifest-common.yml \
		jobs/*.yml \
		cf-manifest-gce.yml \
		cf-manifest-shared.yml \
		terraform-outputs-gce.yml \
		secrets.yml \
		director_uuid.yml \
		> generated.manifest-gce.yml

cf_spiff_aws: director_uuid terraform_outputs
	cd cf && \
	spiff merge \
		cf-manifest-main.yml \
		cf-manifest-common.yml \
		jobs/*.yml \
		cf-manifest-aws.yml \
		cf-manifest-shared.yml \
		terraform-outputs-aws.yml \
		secrets.yml \
		director_uuid.yml \
		> generated.manifest-aws.yml



