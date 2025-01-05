## 1. Authenticating to Azure using a Service Principal

To authenticate with Azure, you can utilize a service principal through various methods such as Cloud Shell, the Azure portal, or Bash.

## 2. Key Terraform Commands

- **`terraform init`**: Prepares the working directory for subsequent commands.
- **`terraform validate`**: Verifies whether the configuration is valid.
- **`terraform plan`**: Displays the changes that will occur based on the current configuration, allowing you to preview what will happen when applying the Terraform configuration.
- **`terraform apply`**: Executes the changes specified in the configuration.
- **`terraform destroy`**: Removes the infrastructure that was previously created.
- To view all available commands, simply type `terraform`.

## 3. Managing Workspaces in Terraform CLI

Note that environments can be managed by organizing configurations into different folders instead of using workspaces.

Terraform Workspaces allow for separate instances of state data within a single working directory, effectively enabling environment separation.

In contrast, Terraform Cloud Workspaces create distinct working directories, while CLI workspaces operate within the same directory but generate different files.

- **`terraform workspace show`**: Displays the current workspace.
- **`terraform workspaces list`**: Lists all existing workspaces.
- **`terraform workspace select <name>`**: Switches to a specified workspace.
- **`terraform workspaces new dev`**: Creates a new workspace for development purposes.

## 4. Understanding Terraform State

The state file serves to link real-world resources to your configuration, track metadata, and enhance performance for large infrastructures.

State files are formatted in JSON and should not be edited manually.

By default, state files are stored locally as `terraform.tfstate`, but they can also be saved remotely in Terraform Cloud or cloud storage services.

State files are refreshed to align with actual infrastructure, ensuring consistency between what exists and what is defined in the state file. For instance, if resources are modified directly in Azure and no longer match the state file, an import request will be made to update the state file accordingly.

Maintaining alignment between the state file and Azure resources is crucial to avoid potential issues.

## 5. Resource Blocks in Terraform

Resource blocks are fundamental components of Terraform that define one or more infrastructure objects such as virtual machines (VMs) and virtual networks (VNETs).

Resources are not created until the `terraform apply` command is executed. Once real infrastructure is established, these objects are updated in the state file. This allows for future updates or deletions of infrastructure based on existing resource blocks by comparing them with the state file and making necessary adjustments.

Resource blocks declare specific types of resources and allow you to specify parameters such as name, location, SKU, and operating system.

## 6. Providers in Terraform

Terraform requires "providers" to interact with cloud services or APIs; without them, resource creation is not possible. Declaring a provider is essential for starting any Terraform project.

Most providers configure specific object types such as:

- Infrastructure
- Naming conventions
- Random number generation

These providers simplify infrastructure implementation and configuration management.

For example, here's how to declare an Azure provider:

```
terraform {
  required_providers {
	azurerm = {
	  source  = "hashicorp/azurerm"
	  version = "~> 2.90.0"
	}
  }
}
```

After configuring a provider, it must be installed to ensure it functions correctly within your environment. Running `terraform init` checks for providers and installs them while adding them to your state file.

![alt text](./image.png)

## 7. Creating Your First Resource Group



With your first configuration block ready, open your terminal and ensure you are authenticated. Execute `terraform plan` to see which resources will be created; if no changes appear, confirm that your configuration file is saved.

While running `terraform plan`, it will take some time as it matches your resource block with the state file.

![alt text](image-1.png)

These changes will be applied once you execute `terraform apply`. The command will prompt you for confirmation before proceeding with the actions.

![alt text](image-2.png)

It's essential to keep your Terraform state file secure since it contains sensitive information.

## Walkthrough - Resource Creation

Azure Virtual Networks (VNETs) enable communication between resources. Network Interface Cards (NICs) connect to VNETs, allowing VMs and other resources within Azure to communicate seamlessly. NICs connect with subnets within VNETs without requiring additional configuration.

For demonstration purposes, VNICs will be created without public interfaces so that VMs remain inaccessible from the internet. This setup enhances security by restricting external communication.

The materials referenced are based on a LinkedIn Learning course on [Terraform in Azure](https://www.linkedin.com/learning/introduction-to-terraform-on-azure).
