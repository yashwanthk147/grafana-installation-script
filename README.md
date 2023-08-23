Notes:
1. run.sh file copies .sh, yaml and service files to s3 bucket 
2. To fetch the files from s3 bucket to your remote machine you needs inputs like access key and secret key
3. To install Grafana, node exporter, loki, promtail you need to run run.sh file with argument (sudo bash run.sh loki)
4. To run the run.sh file add or copy the file to your home directory
5. Give the exectuable permissions to the run.sh file
    sudo chmod +x run.sh
6. run the run.sh file with arugment
    ex: sudo bash run.sh loki
        sudo bash run.sh promtail
        sudo bash run.sh node_exporter
        sudo bash run.sh grafana


