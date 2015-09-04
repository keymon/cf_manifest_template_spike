all: cf_myspiff

cf_myspiff: cf_myspiff_aws

cf_myspiff_aws:
	cd cf && \
	../myspiff.rb \
		secrets.yml \
		director_uuid.rb \
		terraform-outputs-aws.yml \
		cf-manifest-shared.yml.erb \
		cf-manifest-aws.yml.erb \
		cf-manifest-common.yml.erb \
		jobs/*.erb \
		> generated.manifest-aws.yml





