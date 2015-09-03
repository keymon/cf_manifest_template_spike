all: spiff_gce spiff_aws

spiff_gce:
	spiff merge \
		bosh-manifest-main.yml \
		bosh-manifest-common.yml \
		bosh-manifest-gce.yml \
		terraform-outputs-gce.yml > generated.manifest-gce.yml

spiff_aws:
	spiff merge \
		bosh-manifest-main.yml \
		bosh-manifest-common.yml \
		bosh-manifest-aws.yml \
		terraform-outputs-aws.yml > generated.manifest-aws.yml


