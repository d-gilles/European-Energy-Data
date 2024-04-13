start:
	@echo "Opening URL from alb_dns_name.txt..."
	@url=$$(cat ./aws_manifest/infra_details/alb_dns_name.txt); \
	if ! echo "$$url" | grep -q "^http://\|^https://"; then \
		url="http://$$url"; \
	fi; \
	echo "Formatted URL: $$url"; \
	open "$$url" # Use 'xdg-open' on Linux
