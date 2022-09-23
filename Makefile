# Configs
TERRAFORM_BIN = /usr/bin/terraform
CURRENT_ENV = ${TERRAFORM_ENV}
INFRA_DIRECTORY = ./.infra
BUCKET = ${TF_VAR_BUCKET_NAME}

# Commands
.DEFAULT_GOAL := help
help: 
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n",	$$1, $$2}'

# NodeJS Commands

install:  ## Install Application Dependences
	npm install

build:  ## Build Application source code
	npm run build
	
test:  ## Test Application source code
	npm run test


# AWS Commands

deploy:  build ## Build and Deploy  
	aws s3 sync $(APP_DIST) s3://$(BUCKET)


# Terraform Commands

init: # Initialize Terraform
	cd $(TF_DIRECTORY); $(TERRAFORM_BIN) init

clean: ## Format terraform configurations
	cd $(TF_DIRECTORY);	$(TERRAFORM_BIN) fmt -list

validate: ## validate terraform configs
	cd $(TF_DIRECTORY); $(TERRAFORM_BIN) validate

check: clean validate ## Validate syntax and format

plan: ## Check local terraform state and produce plan of terraform configs 
	cd $(TF_DIRECTORY); $(TERRAFORM_BIN) plan

infra: check ## Check local terraform state and apply terraform configs 
	cd $(TF_DIRECTORY); $(TERRAFORM_BIN) apply --auto-approve

publish: check ## Check local terraform state and validate terraform configs 
	cd $(TF_DIRECTORY); $(TERRAFORM_BIN) apply
	$(MAKE) deploy

purge: ## Teardown applied terraform configurations
	cd $(TF_DIRECTORY); $(TERRAFORM_BIN) destroy --auto-approve


# Docker Commands

environment: # Build Docker environment 
	cd $(INFRA_DIRECTORY); docker compose up -d
