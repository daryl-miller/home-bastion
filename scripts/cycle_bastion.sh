#!/bin/bash -e

echo "generating new keys"
./scripts/setup-ssh.sh 
echo "shutdowning bastion host"
docker-compose down 
echo "starting bastion host and injecting keys"
docker-compose up -d
echo "Fetching key and passphrases from ssm"
./scripts/fetch-ssh.sh 
echo "resetting finger print for bastion host"
ssh-keygen -f "/home/dmiller/.ssh/known_hosts" -R "[127.0.0.1]:2222"