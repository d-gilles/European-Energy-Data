setup_aws:
	cd ./aws-infra && \
	pwd && \
	terraform apply

start_ui:
	# Open the mage ui in browser.
	# Wait a view minutes after setting up the infrastructure.
	# The load balancer takes some time to fully spin up.
	@echo "Opening URL from alb_dns_name.txt..."
	@url=$$(cat ./aws-infra/infra_details/alb_dns_name.txt); \
	if ! echo "$$url" | grep -q "^http://\|^https://"; then \
		url="http://$$url"; \
	fi; \
	echo "Formatted URL: $$url"; \
	open "$$url" # Use 'xdg-open' on Linux

s3list:
	# List the content of your S3 datalake
	@bucket_name=$$(cat ./aws-infra/infra_details/bucketname.txt); \
	aws s3 ls s3://"$$bucket_name"
