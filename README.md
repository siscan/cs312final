```markdown
# cs312final
# Automated Minecraft Server Deployment on Amazon Linux 2023

This project automates the deployment of a Minecraft server on an Amazon Linux 2023 EC2 instance using Terraform and a bash script.

## Prerequisites

Before running the project, make sure you have the following prerequisites:

- AWS account with appropriate permissions to create and manage EC2 instances
- AWS CLI installed and configured with your AWS credentials
- Terraform installed on your local machine
- Git installed on your local machine
- SSH client (e.g., OpenSSH) installed on your local machine

## Setup

1. Install the required packages and tools:

   - AWS CLI: Follow the installation instructions from the [AWS CLI documentation](https://aws.amazon.com/cli/).
   - Terraform: Download and install Terraform from the [official website](https://www.terraform.io/downloads.html).
   - Git: Install Git on your local machine. You can download it from the [official website](https://git-scm.com/downloads).
   - SSH client: Most operating systems have an SSH client pre-installed. If you're using Windows, you can use [PuTTY](https://www.putty.org/) or [Windows Subsystem for Linux (WSL)](https://docs.microsoft.com/en-us/windows/wsl/install-win10).

2. Clone this repository to your local machine:

   ```bash
   git clone https://github.com/your-username/minecraft-server-deployment.git
   cd minecraft-server-deployment
   ```

3. Configure your AWS credentials:

   Make sure you have the AWS CLI installed and configured with your AWS access key and secret key. You can configure the AWS CLI by running the following command and providing your credentials:

   ```bash
   aws configure
   ```

4. (Optional) Modify the Terraform configuration:

   If you want to customize the EC2 instance configuration or other settings, you can modify the `main.tf` and `variables.tf` files in the project directory.

## Deployment

To deploy the Minecraft server, follow these steps:

1. Run the deployment script:

   ```bash
   chmod +x run.sh
   ./run.sh
   ```

   The script will perform the following actions:
   - Generate an SSH key pair for accessing the EC2 instance
   - Initialize and apply the Terraform configuration to provision the EC2 instance
   - SSH into the EC2 instance and execute the setup commands to install Java, download the Minecraft server, and configure the server properties
   - Create a systemd service file for the Minecraft server and start the server

2. Connect to the Minecraft server:

   Once the deployment script finishes, it will display the public IP address of the Minecraft server. Use this IP address to connect to the server using your Minecraft client.

## Cleanup

To destroy the provisioned resources and avoid incurring further costs, run the following command:

```bash
terraform destroy -auto-approve
```

This command will terminate the EC2 instance and remove all associated resources.

## Required Packages

The following packages will be automatically installed on the EC2 instance during the deployment process:

- Java 17 (Amazon Corretto)
- Screen

## Customization

If you want to customize the Minecraft server configuration or modify the deployment process, you can update the relevant files:

- `main.tf`: Terraform configuration file for provisioning the EC2 instance and related resources
- `variables.tf`: Terraform variable definitions
- `run.sh`: Bash script that orchestrates the deployment process and executes setup commands on the EC2 instance

Feel free to modify these files to suit your specific requirements.
```
