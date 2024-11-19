# Configuration variables
BUCKET_NAME=kcwan-iac-terraform-sample
TABLE_NAME=kcwan-iac-terraform-sample-lockid
REGION=ap-southeast-1
MODULE_NAME ?= k3s  # Default value if not specified

# Phony targets to avoid conflicts with files of the same name
.PHONY: terraform-s3-init terraform-ddb-init terraform-init list-modules setup destroy clean help

# Help target to display available commands
help:
	@echo "Available commands:"
	@echo "  terraform-s3-init  	- Create S3 bucket for Terraform state"
	@echo "  terraform-ddb-init 	- Create DynamoDB table for state locking"
	@echo "  terraform-init     	- Initialize Terraform backend (runs s3-init and ddb-init)"
	@echo "  list-modules       	- List available Terraform modules"
	@echo "  setup              	- Apply specified module (use MODULE_NAME=xxx)"
	@echo "  destroy            	- Destroy specified module (use MODULE_NAME=xxx)"
	@echo "  clean              	- Clean up local Terraform files"

# Initialize S3 bucket for Terraform state
terraform-s3-init:
	@echo "Creating S3 bucket for Terraform state..."
	@aws s3api create-bucket \
		--bucket $(BUCKET_NAME) \
		--region $(REGION) \
		--create-bucket-configuration LocationConstraint=$(REGION)
	@aws s3api put-bucket-versioning \
		--bucket $(BUCKET_NAME) \
		--versioning-configuration Status=Enabled
	@aws s3api put-bucket-encryption \
		--bucket $(BUCKET_NAME) \
		--server-side-encryption-configuration '{"Rules": [{"ApplyServerSideEncryptionByDefault": {"SSEAlgorithm": "AES256"}}]}'
	@aws s3api put-public-access-block \
		--bucket $(BUCKET_NAME) \
		--public-access-block-configuration "BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true"

# Initialize DynamoDB table for state locking
terraform-ddb-init:
	@echo "Creating DynamoDB table for state locking..."
	@aws dynamodb create-table \
		--table-name $(TABLE_NAME) \
		--attribute-definitions AttributeName=LockID,AttributeType=S \
		--key-schema AttributeName=LockID,KeyType=HASH \
		--provisioned-throughput ReadCapacityUnits=1,WriteCapacityUnits=1 \
		--table-class STANDARD \
		--region $(REGION)
	@aws dynamodb wait table-exists --table-name $(TABLE_NAME)

# Initialize Terraform backend
terraform-init: terraform-s3-init terraform-ddb-init
	@echo "Initializing Terraform..."
	@terraform init

# List all module names
list-modules:
	@echo "Available modules:"
	@find modules -type d -depth 1 | sed 's|modules/||'

# Apply specified module
setup:
	@if [ -z "$$(find modules -type d -name "$(MODULE_NAME)")" ]; then \
		echo "Error: Module '$(MODULE_NAME)' not found"; \
		exit 1; \
	fi
	@echo "Applying module $(MODULE_NAME)..."
	@terraform init
	@terraform apply -target=module.$(MODULE_NAME) -auto-approve

# Destroy specified module
destroy:
	@if [ -z "$$(find modules -type d -name "$(MODULE_NAME)")" ]; then \
		echo "Error: Module '$(MODULE_NAME)' not found"; \
		exit 1; \
	fi
	@echo "Destroying module $(MODULE_NAME)..."
	@terraform init
	@terraform destroy -target=module.$(MODULE_NAME) -auto-approve

# Clean up local files
clean:
	@echo "Cleaning up..."
	@rm -rf .terraform
	@rm -f terraform.tfstate*
	@rm -f .terraform.lock.hcl
