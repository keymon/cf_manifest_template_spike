all: cf_myspiff

cf_myspiff: cf_myspiff_aws

cf_myspiff_aws:
	cd cf && \
	../myspiff.rb \
		secrets.rb \
		terraform-outputs-aws.rb \
		variables-common.rb \
		jobs/*.erb \
		jobs/*.yml \
		> generated.manifest-aws.yml





