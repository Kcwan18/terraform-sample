# Configuration variables
BUCKET_NAME=kcwan-iac-terraform-sample
TABLE_NAME=kcwan-iac-terraform-sample-lockid
REGION=ap-southeast-1

# Phony targets to avoid conflicts with files of the same name
.PHONY: terraform-s3-init terraform-ddb-init terraform-init k3s k3s-d clean

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

# Initialize Terraform backend
terraform-init: terraform-s3-init terraform-ddb-init
	@echo "Initializing Terraform..."
	@terraform init

# Apply K3s module
setup-k3s:
	@echo "Applying K3s module..."
	@terraform apply -target=module.k3s -auto-approve

# Destroy K3s module
destroy-k3s:
	@echo "Destroying K3s module..."
	@terraform destroy -target=module.k3s -auto-approve

# Clean up local files
clean:
	@echo "Cleaning up..."
	@rm -rf .terraform
	@rm -f terraform.tfstate*
