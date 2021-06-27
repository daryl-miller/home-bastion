#!/bin/bash -e

#Clean up old output directory
rm -rf output
mkdir output

#Pull down passphrases and privatekey
aws ssm get-parameter --name "/bastion/remotePassphrase" --with-decryption --output text --query Parameter.Value > output/remotePassphrase
aws ssm get-parameter --name "/bastion/localPassphrase" --with-decryption --output text --query Parameter.Value > output/localPassphrase
aws ssm get-parameter --name "/bastion/privatekey" --with-decryption --output text --query Parameter.Value > output/privatekey

#Set private key permissions
chmod 400 output/privatekey