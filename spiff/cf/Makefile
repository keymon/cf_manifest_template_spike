all: spiff_gce spiff_aws

director_uuid:
	# TODO
	echo "---\ndirector_uuid: abcd-abcd-abcd-abcd-abcd-abcd" > director_uuid.yml

spiff_gce: director_uuid
	spiff merge \
		cf-manifest-main.yml \
		cf-manifest-common.yml \
		cf-manifest-gce.yml \
		terraform-outputs-gce.yml \
		secrets.yml \
		director_uuid.yml \
		> generated.manifest-gce.yml

spiff_aws: director_uuid
	spiff merge \
		cf-manifest-main.yml \
		cf-manifest-common.yml \
		cf-manifest-aws.yml \
		terraform-outputs-aws.yml \
		secrets.yml \
		director_uuid.yml \
		> generated.manifest-aws.yml


