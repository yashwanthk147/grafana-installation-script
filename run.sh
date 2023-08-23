#!/bin/bash

if [ $# -eq 0 ]; then
    echo "No arguments provided. Exiting..."
    exit 0
fi

# Detect the operating system
if [[ -f /etc/os-release ]]; then
  source /etc/os-release
  os_type="ubuntu"
elif [[ -f /etc/redhat-release ]]; then
  os_type="centos"
else
  echo "Unsupported operating system. Exiting..."
  exit 1
fi
  
if [[ $os_type == "ubuntu" ]]; then
  if ! command -v aws >/dev/null; then
    echo "AWS CLI is not installed. Installing..."
    sudo apt update
    sudo apt install -y awscli gnupg2 curl unzip
  fi
elif [[ $os_type == "centos" ]]; then
  if ! command -v aws >/dev/null; then
    echo "AWS CLI is not installed. Installing..."
    sudo yum update -y
    sudo yum install -y awscli gnupg2 curl unzip
  fi
else
  echo "Unsupported operating system. Exiting..."
  exit 1
fi


# Configure access key and secret key
if [[ ! -f ~/.aws/credentials ]]; then
  echo "AWS credentials not found. Configuring..."
  mkdir -p ~/.aws
  echo "[default]" > ~/.aws/credentials
  echo "aws_access_key_id = AKIASZASMGKRVF47IKE5" >> ~/.aws/credentials
  echo "aws_secret_access_key = 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" >> ~/.aws/credentials
fi

# Copy shell script files from S3 bucket
echo "Copying shell script files from S3 bucket..."
aws s3 cp s3://loginstallscript/ /opt --recursive

# Give executable permissions to the script files
echo "Giving executable permissions..."
sudo chmod +x /opt/install.sh

# Run the script with the provided argument
if [ -z "$1" ]; then
  echo "No argument provided. Exiting..."
  exit 0
fi

echo "Running the script..."
sudo bash /opt/install.sh "$1"