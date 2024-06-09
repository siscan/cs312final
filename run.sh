#!/bin/bash

# Generate SSH key pair
ssh-keygen -t rsa -f minecraft_server_key -N ""

cd terraform

# Initialize Terraform
terraform init

# Apply the Terraform configuration
terraform apply -auto-approve

# Retrieve the public IP address from Terraform output
INSTANCE_PUBLIC_IP=$(terraform output -raw public_ip)

# Wait for the instance to be ready
sleep 60

# SSH into the EC2 instance and run the setup commands
ssh -i ../minecraft_server_key ec2-user@$INSTANCE_PUBLIC_IP << EOF
  sudo yum update -y
  sudo yum install -y java-17-amazon-corretto
  sudo mkdir -p /opt/minecraft
  cd /opt/minecraft
  sudo wget -O server.jar https://piston-data.mojang.com/v1/objects/8f3112a1049751cc472ec13e397eade5336ca7ae/server.jar
  sudo java -Xmx1024M -Xms1024M -jar /opt/minecraft/server.jar nogui
  echo 'eula=true' | sudo tee ./eula.txt
  echo 'difficulty=normal' | sudo tee -a /opt/minecraft/server.properties
  echo 'gamemode=survival' | sudo tee -a /opt/minecraft/server.properties
  echo 'level-name=world' | sudo tee -a /opt/minecraft/server.properties
  echo 'server-port=25565' | sudo tee -a /opt/minecraft/server.properties
  echo 'max-players=20' | sudo tee -a /opt/minecraft/server.properties
sudo tee /etc/systemd/system/minecraft.service > /dev/null << EOT
[Unit]
Description=Minecraft Server
After=network.target

[Service]
User=ec2-user
Nice=5
KillMode=none
SuccessExitStatus=0 1
InaccessibleDirectories=/root /sys /srv /media -/lost+found
NoNewPrivileges=true
WorkingDirectory=/opt/minecraft
ReadWriteDirectories=/opt/minecraft
ExecStart=/usr/bin/java -Xms1024M -Xmx1024M -jar server.jar nogui
ExecStop=/usr/bin/screen -p 0 -S minecraft -X eval 'stuff "say SERVER SHUTTING DOWN. SAVING MAP..."\\015'
ExecStop=/bin/sleep 5
ExecStop=/usr/bin/screen -p 0 -S minecraft -X eval 'stuff "save-all"\\015'
ExecStop=/usr/bin/screen -p 0 -S minecraft -X eval 'stuff "stop"\\015'
Restart=always

[Install]
WantedBy=multi-user.target
EOT
sudo systemctl daemon-reload
sudo systemctl enable minecraft
sudo systemctl start minecraft
EOF

# Print the connection details
echo "Minecraft server is now running. Connect to the server using the following IP address:"
echo "$INSTANCE_PUBLIC_IP"