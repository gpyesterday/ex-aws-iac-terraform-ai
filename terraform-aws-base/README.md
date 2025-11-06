# Terraform AWS Base Project

This project provides a basic setup for deploying AWS infrastructure using Terraform. It includes a VPC module and is structured to allow easy customization and expansion.

## Project Structure

```
terraform-aws-base
├── modules
│   └── vpc
│       ├── main.tf          # Main configuration for the VPC module
│       ├── variables.tf     # Input variables for the VPC module
│       └── outputs.tf       # Outputs for the VPC module
├── env
│   └── dev.tfvars           # Environment-specific variable values
├── main.tf                  # Entry point for the Terraform configuration
├── providers.tf             # Provider configuration (AWS)
├── variables.tf             # Input variables for the main configuration
├── outputs.tf               # Outputs for the main configuration
├── versions.tf              # Required Terraform and provider versions
├── backend.tf               # Backend configuration for state storage
├── .gitignore               # Files and directories to ignore by Git
└── README.md                # Project documentation
```

## Getting Started

1. **Prerequisites**
   - Install [Terraform](https://www.terraform.io/downloads.html).
   - Set up your AWS credentials (to be configured in `providers.tf`).

2. **Clone the Repository**
   ```bash
   git clone <repository-url>
   cd terraform-aws-base
   ```

3. **Initialize Terraform**
   Run the following command to initialize the Terraform configuration:
   ```bash
   terraform init
   ```

4. **Customize Variables**
   Edit the `env/dev.tfvars` file to set your environment-specific variables.

5. **Plan the Deployment**
   Generate an execution plan:
   ```bash
   terraform plan -var-file="env/dev.tfvars"
   ```

6. **Apply the Configuration**
   Deploy the infrastructure:
   ```bash
   terraform apply -var-file="env/dev.tfvars"
   ```

## Modules

### VPC Module
The VPC module is responsible for creating a Virtual Private Cloud in AWS. It can be customized through the variables defined in `modules/vpc/variables.tf`.

## Outputs
The outputs defined in `outputs.tf` will provide useful information about the deployed resources, such as VPC ID and subnet IDs.

## License
This project is licensed under the MIT License. See the LICENSE file for more details.