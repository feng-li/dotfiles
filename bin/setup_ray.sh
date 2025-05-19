#!/bin/bash

set -e

# Ray Cluster Configuration
HEAD_IP="10.10.10.9"
WORKER_IPS=("10.10.10.10" "10.10.10.11" "10.10.10.12" "10.10.10.13" "10.10.10.14" "10.10.10.15" "10.10.10.16")
RAY_PORT=2024  # Default Ray head node port

NUM_CPUS=$(nproc --all)
echo "Detected $NUM_CORES cores"

# NUM_CPUS=32    # Number of CPUs per node

# Automatically get the current user
SSH_USER=$(whoami)

# Path to Ray installation (modify if needed)
RAY_PATH="${HOME}/.local/miniforge3/bin"  # Example: "/home/$SSH_USER/.local/bin"

# SSH options to automatically accept new host keys and disable strict checking
SSH_OPTS="-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null"

start_ray() {
    echo "Starting Ray head node on $HEAD_IP..."
    ssh $SSH_OPTS "$SSH_USER@$HEAD_IP" "export PATH=$RAY_PATH:\$PATH; ray stop; ray start --head --port=$RAY_PORT --num-cpus=$NUM_CPUS"

    echo "Starting Ray worker nodes..."
    for ip in "${WORKER_IPS[@]}"; do
        echo "Starting worker on $ip..."
        ssh $SSH_OPTS "$SSH_USER@$ip" "export PATH=$RAY_PATH:\$PATH; ray stop; ray start --address=$HEAD_IP:$RAY_PORT --num-cpus=$NUM_CPUS"
    done

    echo "Ray cluster started successfully!"
}

stop_ray() {
    echo "Stopping Ray cluster..."
    
    # Stop workers first
    for ip in "${WORKER_IPS[@]}"; do
        echo "Stopping Ray on worker $ip..."
        ssh $SSH_OPTS "$SSH_USER@$ip" "export PATH=$RAY_PATH:\$PATH; ray stop"
    done

    # Stop head node
    echo "Stopping Ray on head node $HEAD_IP..."
    ssh $SSH_OPTS "$SSH_USER@$HEAD_IP" "export PATH=$RAY_PATH:\$PATH; ray stop"

    echo "Ray cluster stopped successfully!"
}

if [ "$1" == "start" ]; then
    start_ray
elif [ "$1" == "stop" ]; then
    stop_ray
else
    echo "Usage: $0 {start|stop}"
    exit 1
fi
