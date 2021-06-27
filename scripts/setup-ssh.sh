#!/bin/bash
# Setup one create ssh key with random password
# Step two push each key to ssm

#Cleaning .ssh
rm -rf .ssh
mkdir -p .ssh/remote


date_time=$(date +'%d/%m/%Y')

localPassphrase=$(uuidgen)
remotePassphrase=$(uuidgen)


#Generating new SSH Keys
ssh-keygen -t rsa -b 4096 -C "bastion-local-generated-${date_time}" -N "$localPassphrase" -f .ssh/id_rsa -q 
ssh-keygen -t rsa -b 4096 -C "bastion-remote-generated-${date_time}" -P "$remotePassphrase" -f .ssh/remote/bastion-keys -q 

#Cleaning out old remote keys
sed -i '/bastion/d' ~/.ssh/authorized_keys --quiet

#Pushing key into authorized_keys so that local key can acess server and bastion host is accessible by remote key
cat .ssh/id_rsa.pub >> ~/.ssh/authorized_keys
cat .ssh/remote/bastion-keys.pub >> ./.ssh/authorized_keys

#Storing keys and passwords in AWS
aws ssm put-parameter \
    --name "/bastion/privatekey" \
    --value "$(cat .ssh/remote/bastion-keys)" \
    --type SecureString \
    --overwrite

aws ssm put-parameter \
    --name "/bastion/publickey" \
    --value "$(cat .ssh/remote/bastion-keys.pub)" \
    --type SecureString \
    --overwrite

aws ssm put-parameter \
    --name "/bastion/localPassphrase" \
    --value "${localPassphrase}" \
    --type SecureString \
    --overwrite

aws ssm put-parameter \
    --name "/bastion/remotePassphrase" \
    --value "${remotePassphrase}" \
    --type SecureString \
    --overwrite


# Removing remote keys
rm -rf .ssh/remote