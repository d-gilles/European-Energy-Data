.PHONY: export-credentials
# initialize Terraform
init:
	cd ./aws-infra && \
	terraform init
# Check if Terraform is initialized, AWS CLI is installed and AWS access is working
check:
	@if [ -d "./aws-infra/.terraform" ]; then \
		echo "Terraform ready to go"; \
	else \
		echo "Terraform is not initialized, run 'terraform init' in ./aws-infra"; \
		exit 1; \
	fi
	@if command -v aws > /dev/null; then \
		echo "AWS CLI installed"; \
	else \
		echo "AWS CLI is not installed. Please install it."; \
		exit 1; \
	fi
	@if aws sts get-caller-identity > /dev/null; then \
		echo "AWS access ok"; \
	else \
		echo "Failed to access AWS. Check your AWS credentials."; \
		exit 1; \
	fi



# Spin up the infrastructure
setup_aws:
	cd ./aws-infra && \
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
	while ! curl -s --head --request GET $$url | grep "200 OK" > /dev/null; do \
		echo "Waiting for URL to become available..."; \
		sleep 5; \
	done; \
	echo "URL is now accessible, opening in browser..."; \
	open "$$url"  # Use 'xdg-open' on Linux

	@echo "Opening Redshift UI from redshift_ui.txt..."
	@url=$$(cat ./aws-infra/infra_details/redshift_ui.txt); \
	if ! echo "$$url" | grep -q "^http://\|^https://"; then \
		url="http://$$url"; \
	fi; \
	echo "Formatted URL: $$url"; \
	open "$$url"  # Use 'xdg-open' on Linux



s3list:
	# List the content of your S3 datalake
	@bucket_name=$$(cat ./aws-infra/infra_details/bucketname.txt); \
	aws s3 ls s3://"$$bucket_name"

off:
	cd ./aws-infra && \
	terraform destroy