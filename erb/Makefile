all: cf_myspiff

cf_myspiff: cf_myspiff_aws

cf_myspiff_aws:
	cd cf && \
	../myspiff.rb \
		secrets.yml \
		terraform-outputs-aws.rb \
		variables-common.rb \
		jobs/*.erb \
		> generated.manifest-aws.yml





