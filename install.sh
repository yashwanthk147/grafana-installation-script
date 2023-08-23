#!/bin/bash

if [ $# -eq 0 ]; then
    echo "No arguments provided. Exiting..."
    exit 0
fi

# Function to install Node Exporter
install_node_exporter() {
    if ! command -v node_exporter &> /dev/null; then
        if command -v apt &> /dev/null; then
            wget https://github.com/prometheus/node_exporter/releases/download/v1.0.1/node_exporter-1.0.1.linux-amd64.tar.gz
            tar xzf node_exporter-1.0.1.linux-amd64.tar.gz
            sudo cp /home/ubuntu/node_exporter-1.0.1.linux-amd64/node_exporter /usr/local/bin/node_exporter
        elif command -v yum &> /dev/null; then
            wget https://github.com/prometheus/node_exporter/releases/download/v1.0.1/node_exporter-1.0.1.linux-amd64.tar.gz
            tar xzf node_exporter-1.0.1.linux-amd64.tar.gz
            sudo cp /home/centos/node_exporter-1.0.1.linux-amd64/node_exporter /usr/local/bin/node_exporter
        else
            echo "Package manager not found. Exiting..."
            exit 1
        fi
    else
        echo "Node Exporter is already installed. Skipping..."
    fi
}

# Function to install Grafana
install_grafana() {
    if ! dpkg -s grafana &> /dev/null; then
        if command -v apt &> /dev/null; then
            curl https://packages.grafana.com/gpg.key | sudo apt-key add -
            sudo add-apt-repository -y "deb https://packages.grafana.com/oss/deb stable main"
            sudo apt-get update -y
            sudo apt-get -y install grafana
        elif command -v yum &> /dev/null; then
            sudo yum install -y https://dl.grafana.com/oss/release/grafana-8.0.6-1.x86_64.rpm
        else
            echo "Package manager not found. Exiting..."
            exit 1
        fi
    else
        echo "Grafana is already installed. Skipping..."
    fi
}

# Function to install Loki
install_loki() {
    if ! command -v loki &> /dev/null; then
        curl -s https://api.github.com/repos/grafana/loki/releases/latest | grep browser_download_url | cut -d '"' -f 4 | grep loki-linux-amd64.zip | wget -i -
        #sudo apt-get -y install unzip  # Install unzip package
        sudo unzip loki-linux-amd64.zip
        if [[ $(grep -Ei "debian|ubuntu" /etc/*release) ]]; then
            sudo mv /home/ubuntu/loki-linux-amd64 /usr/local/bin/loki
        elif [[ $(grep -Ei "centos|red hat|fedora" /etc/*release) ]]; then
            sudo mv /home/centos/loki-linux-amd64 /usr/local/bin/loki
        fi
    else
        echo "Loki is already installed. Skipping..."
    fi
}

# Function to install Promtail
install_promtail() {
    if ! command -v promtail &> /dev/null; then
        curl -s https://api.github.com/repos/grafana/loki/releases/latest | grep browser_download_url | cut -d '"' -f 4 | grep promtail-linux-amd64.zip | wget -i -
        #sudo apt-get -y install unzip  # Install unzip package  
        sudo unzip promtail-linux-amd64.zip
        if [[ $(grep -Ei "debian|ubuntu" /etc/*release) ]]; then
            sudo mv /home/ubuntu/promtail-linux-amd64 /usr/local/bin/promtail
        elif [[ $(grep -Ei "centos|red hat|fedora" /etc/*release) ]]; then
            sudo mv /home/centos/promtail-linux-amd64 /usr/local/bin/promtail
        fi
    else
        echo "Promtail is already installed. Skipping..."
    fi
}


# Check the operating system
# Check the operating system
if [[ $(grep -Ei "debian|ubuntu" /etc/*release) ]]; then
    # Ubuntu/Debian based installation
    echo "Installing packages for Ubuntu/Debian..."

    #if ! command -v apt >/dev/null; then
        #echo "apt command not found. Exiting..."
        #exit 1
    #fi

    # Check if the packages need to be installed or updated
    #if [[ $2 == "install" ]]; then
        #sudo apt update -y
        #sudo apt upgrade -y
        #sudo apt-get install -y gnupg2 curl unzip
    #elif [[ $2 == "update" ]]; then
        #sudo apt update -y
        #sudo apt upgrade -y
    #fi

    if [ $1 == "node_exporter" ]; then
        install_node_exporter
    elif [ $1 == "grafana" ]; then
        install_grafana
    elif [ $1 == "loki" ]; then
        install_loki
    elif [ $1 == "promtail" ]; then
        install_promtail
    else
        echo "Invalid argument. Exiting..."
        exit 1
    fi

elif [[ $(grep -Ei "centos|red hat|fedora" /etc/*release) ]]; then
    # CentOS/RHEL based installation
    echo "Installing packages for CentOS/RHEL..."

    #if ! command -v yum >/dev/null; then
        #echo "yum command not found. Exiting..."
        #exit 1
    #fi

    # Check if the packages need to be installed or updated
    #if [[ $2 == "install" ]]; then
        #sudo yum update -y
        #sudo yum install -y gnupg2 curl unzip
    #elif [[ $2 == "update" ]]; then
        #sudo yum update -y
    #fi

    if [ $1 == "node_exporter" ]; then
        install_node_exporter
    elif [ $1 == "grafana" ]; then
        install_grafana
    elif [ $1 == "loki" ]; then
        install_loki
    elif [ $1 == "promtail" ]; then
        install_promtail
    else
        echo "Invalid argument. Exiting..."
        exit 1
    fi

else
    echo "Unsupported operating system. Exiting..."
    exit 1
fi


# Continue with the rest of your script for both Ubuntu and CentOS installations

# Create directories and set permissions
#sudo useradd --no-create-home prometheus
#sudo mkdir /etc/prometheus
#sudo mkdir /var/lib/prometheus
#sudo chown prometheus:prometheus /etc/prometheus
# sudo chown prometheus:prometheus /usr/local/bin/prometheus
# sudo chown prometheus:prometheus /usr/local/bin/promtool
#sudo chown -R prometheus:prometheus /etc/prometheus/consoles
#sudo chown -R prometheus:prometheus /etc/prometheus/console_libraries
#sudo chown -R prometheus:prometheus /var/lib/prometheus

# Copy configuration files
#sudo cp prometheus.yml /etc/prometheus/
#sudo cp prometheus.service /etc/systemd/system/prometheus.service
sudo cp /opt/node-exporter.service /etc/systemd/system/node-exporter.service
sudo cp /opt/loki-local-config.yaml /etc/loki-local-config.yaml
sudo cp /opt/loki.service /etc/systemd/system/loki.service
sudo cp /opt/promtail-local-config.yaml /etc/promtail-local-config.yaml
sudo cp /opt/promtail.service /etc/systemd/system/promtail.service

# Start services
sudo systemctl daemon-reload
# sudo systemctl enable prometheus
# sudo systemctl start prometheus
sudo systemctl enable node-exporter
sudo systemctl start node-exporter
sudo systemctl start grafana-server
sudo systemctl enable loki.service
sudo systemctl start loki.service
sudo systemctl start promtail.service

# Check service status
# sudo systemctl status prometheus
sudo systemctl status node-exporter
sudo systemctl status grafana-server
sudo systemctl status loki.service
sudo systemctl status promtail.service
