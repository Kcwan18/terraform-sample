BUCKET_NAME=kcwan-iac-terraform-sample
TABLE_NAME=kcwan-iac-terraform-sample-lockid
REGION=ap-southeast-1

terraform-s3-init:
	@echo "Initializing S3..."
	@aws s3api create-bucket --bucket $(BUCKET_NAME) --region $(REGION) --create-bucket-configuration LocationConstraint=$(REGION)

terraform-ddb-init:
	@echo "Initializing DynamoDB..."
	@aws dynamodb create-table --table-name $(TABLE_NAME) --attribute-definitions AttributeName=LockID,AttributeType=S --key-schema AttributeName=LockID,KeyType=HASH --provisioned-throughput ReadCapacityUnits=1,WriteCapacityUnits=1 --table-class STANDARD --region $(REGION)

terraform-init: terraform-s3-init terraform-ddb-init
	@echo "Initialized Terraform"
