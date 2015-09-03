all: spiff_gce spiff_aws

spiff_gce:
	spiff merge \
		cf-manifest-main.yml \
		cf-manifest-common.yml \
		cf-manifest-gce.yml \
		terraform-outputs-gce.yml \
		secrets.yml \
		> generated.manifest-gce.yml

spiff_aws:
	spiff merge \
		cf-manifest-main.yml \
		cf-manifest-common.yml \
		cf-manifest-aws.yml \
		terraform-outputs-aws.yml \
		secrets.yml \
		> generated.manifest-aws.yml


